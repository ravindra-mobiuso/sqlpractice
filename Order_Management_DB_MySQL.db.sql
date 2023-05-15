--1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]
SELECT product_class_code, product_id, product_desc, product_price,
CASE 
WHEN product_class_code = 2050 THEN product_price + 2000
WHEN product_class_code = 2051 THEN product_price + 500
WHEN product_class_code = 2052 THEN product_price + 600
ELSE product_price
END AS latest_price FROM PRODUCT

ORDER BY product_class_code ASC;

--2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]
SELECT product_class_desc, product_id, product_desc, product_quantity_avail,
CASE 
WHEN PC.product_class_code IN ('Electronics', 'Computer')
THEN
 CASE
   WHEN product_quantity_avail <=10 THEN 'Low stock'
   WHEN 11 <= product_quantity_avail <= 30 THEN 'In stock'
   WHEN product_quantity_avail = 0 THEN 'Out of stock'
 ELSE 'Enough stock'
 END
WHEN PC.product_class_code IN ('Stationery', 'Clothes')
THEN 
  CASE 
    WHEN product_quantity_avail <= 20 THEN 'Low stock'
    WHEN 21 <= product_quantity_avail <= 80 THEN 'In stock'
    WHEN product_quantity_avail = 0 THEN 'Out of stock'
    ELSE 'Enough stock'
END
ELSE
 CASE 
  WHEN product_quantity_avail <= 15 THEN 'Low stock'
  WHEN 16 <= product_quantity_avail <= 50 THEN 'In stock'
  WHEN product_quantity_avail = 0 THEN 'Out of stock'
  else 'Enough stock'
 END
END
FROM PRODUCT
JOIN PRODUCT_CLASS PC ON PRODUCT.PRODUCT_CLASS_CODE = PC.product_class_code

--3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]
SELECT country, COUNT(city) AS city_count FROM ADDRESS
WHERE country NOT IN ('USA', 'Malaysia')
GROUP by country
HAVING city_count > 1
ORDER by city desc;

--4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]
SELECT ONLINE_CUSTOMER.customer_id, count(), ONLINE_CUSTOMER.customer_fname|| '' || ONLINE_CUSTOMER.customer_lname as full_name, ADDRESS.city, ADDRESS.pincode, ORDER_HEADER.order_id, PRODUCT_CLASS.product_class_desc,  PRODUCT.product_desc, ORDER_ITEMS.product_quantity * PRODUCT.product_price AS subtotal FROM  ADDRESS
JOIN ONLINE_CUSTOMER  ON ONLINE_CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
JOIN ORDER_HEADER ON ONLINE_CUSTOMER.CUSTOMER_ID = ORDER_HEADER.CUSTOMER_ID
JOIN ORDER_ITEMS ON ORDER_HEADER.order_id = ORDER_ITEMS.ORDER_ID
JOIN PRODUCT ON PRODUCT.product_id = ORDER_ITEMS.PRODUCT_ID
JOIN PRODUCT_CLASS ON PRODUCT.product_class_code = PRODUCT_CLASS.PRODUCT_CLASS_CODE
WHERE ADDRESS.pincode NOT LIKE '%0%'
GROUP BY ONLINE_CUSTOMER.customer_id
order BY  full_name, subtotal

--5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item which has been bought maximum no. of times (Quantity Wise) along with product id 201. (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]
SELECT PRODUCT.product_id, PRODUCT.product_desc, SUM(ORDER_ITEMS.product_quantity) as totalquantity
from PRODUCT 
join ORDER_ITEMS on PRODUCT.product_id = ORDER_ITEMS.product_id
WHERE PRODUCT.product_id = 201 
GROUP BY PRODUCT.product_id

--6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]
SELECT oc.CUSTOMER_ID, oc.customer_fname, oc.CUSTOMER_EMAIL, oh.order_id, PRODUCT.PRODUCT_DESC, oi.PRODUCT_QUANTITY, oi.PRODUCT_QUANTITY * PRODUCT.product_price as subtotal from ONLINE_CUSTOMER oc
LEFT JOIN ORDER_HEADER oh on oc.CUSTOMER_ID = oh.CUSTOMER_ID
LEFT join ORDER_ITEMS oi on oh.order_id = oi.ORDER_ID
LEFT join PRODUCT on oi.product_id = PRODUCT.product_id

--7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]
SELECT c.CARTON_id, c.len * c.WIDTH * c.HEIGHT as carton_vol from CARTON c 
where c.len * c.width * c.height > (SELECT p.len * p.width * p.height* oi.product_quantity from PRODUCT p
                                    join ORDER_ITEMS oi on p.PRODUCT_ID = oi.PRODUCT_ID
                                    WHERE oi.ORDER_ID = 10006
                                   )
 order by carton_vol
 limit 1;
 
-- 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]
 SELECT oc.CUSTOMER_ID, oc.CUSTOMER_FNAME || ' ' || oc.CUSTOMER_LNAME as full_name, oh.order_id, SUM(oi.PRODUCT_QUANTITY)
 from ONLINE_CUSTOMER oc join ORDER_HEADER oh on oc.CUSTOMER_ID = oh.CUSTOMER_ID
 join ORDER_ITEMS oi on oh.ORDER_ID = oi.ORDER_ID
 WHERE oh.order_status = 'Shipped'
 group BY oc.CUSTOMER_ID, full_name, oh.ORDER_ID
 HAVING SUM(oi.PRODUCT_QUANTITY) > 10
LIMIT 10;

--9. Write a query to display the order_id, customer id and customer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]
 SELECT oh.order_id, oc.CUSTOMER_ID, oc.CUSTOMER_FNAME || ' ' || oc.CUSTOMER_LNAME as full_name, SUM(oi.PRODUCT_QUANTITY)
 from ONLINE_CUSTOMER oc 
 join ORDER_HEADER oh on oc.CUSTOMER_ID = oh.CUSTOMER_ID
 join ORDER_ITEMS oi on oh.ORDER_ID = oi.ORDER_ID
 WHERE oh.order_id > 10060 AND oh.order_status = 'Shipped'
 group BY oh.ORDER_ID, oc.CUSTOMER_ID, full_name;
 
-- 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]
  SELECT pc.product_class_desc, SUM(oi.product_quantity) as total_quantity, SUM(oi.product_quantity * PRODUCT.product_price) as total_value  FROM PRODUCT_CLASS pc
 JOIN PRODUCT ON pc.PRODUCT_CLASS_CODE = PRODUCT.product_class_code
 JOIN ORDER_ITEMS oi on PRODUCT.product_id = oi.product_id
 join ORDER_HEADER oh on oi.order_id = oh.order_id
 JOIN ONLINE_CUSTOMER oc on oh.CUSTOMER_ID = oc.CUSTOMER_ID
 JOIN ADDRESS on oc.address_id = ADDRESS.address_id
 WHERE ADDRESS.country NOT IN ('India', 'USA') AND oh.order_status = 'Shipped'
 GROUP BY pc.product_class_desc
 ORDER BY total_quantity DESC
 LIMIT 1;                                                                      
 
 
 
 