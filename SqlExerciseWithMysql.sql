-- SQL Practice - Part 1
-- Use Sakila

-- Q1 Display all tables available in the database “sakila”
 SHOW TABLES;

-- Q2 Display structure of table “actor”. (4 row)
DESCRIBE actor;

-- Q3 Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row)
 SHOW COLUMNS FROM actor;

-- Q4 Display the first and last names of all actors from the table actor. (200 rows)
SELECT first_name, last_name FROM actor;

-- Q5 Which actors have the last name ‘Johansson’. (3 rows)
SELECT * FROM actor
WHERE last_name LIKE '%johansson'

-- Q6 Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows)
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS `actor_name`
FROM actor;

-- Q7 You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? (1 row)
SELECT actor_id,first_name, last_name  FROM actor
WHERE first_name ='joe';

-- Q8 Which last names are not repeated? (66 rows)
SELECT last_name FROM actor
 GROUP BY last_name
 HAVING COUNT(*) = 1;

-- Q9 List the last names of actors, as well as how many actors have that last
SELECT last_name, COUNT(*) FROM actor
 GROUP BY last_name
-- (its look like question is incomplete)

-- Q10 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)
SELECT staff.first_name, staff.last_name, address.address FROM staff
 JOIN address ON address.address_id = staff.address_id;

-- Use world database 
-- Q1 Display all columns and 10 rows from table “city”.(10 rows)
SELECT * FROM city
LIMIT 10;

-- Q2 Modify the above query to display from row # 16 to 20 with all columns. (5 rows)
SELECT * FROM city
LIMIT 5 OFFSET  15;

-- Q3 How many rows are available in the table city. (1 row)-4079.
SELECT COUNT(*) FROM city;

-- Q4 Using city table find out which is the most populated city.
-- ('Mumbai (Bombay)', '10500000')
SELECT  name, population FROM city
ORDER BY population DESC
LIMIT 1;

-- Q5 Using city table find out the least populated city.
SELECT name, population FROM city
ORDER BY population ASC
LIMIT 1;

-- Q6 Display name of all cities where population is between 670000 to 700000. (13 rows)
SELECT Name, Population FROM city
WHERE Population BETWEEN 670000 AND 700000;

-- Q7 Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first.
SELECT Name, Population FROM city  
ORDER BY Population desc
LIMIT 10;

-- Q8 Order the data by city name and get first 10 cities from city table.
SELECT name  FROM city
ORDER by Name ASC
LIMIT 10;

-- Q9 Display all the districts of USA where population is greater than 3000000, from city table. (6 rows)
SELECT District FROM city
WHERE CountryCode = 'USA' AND Population > 3000000;

-- Q10 What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows).
SELECT Name, Population, ID FROM city
WHERE ID IN (5, 23, 432, 2021);

-- SQL Practice – Part 2
-- Use Sakila database
-- Q1 Which actor has appeared in the most films? (‘107', 'GINA', 'DEGENERES', '42')
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(fa.film_id) AS most_film FROM actor
JOIN film_actor fa ON actor.actor_id = fa.actor_id
GROUP BY actor.actor_id
ORDER BY most_film desc
LIMIT 1;

-- Q2 What is the average length of films by category? (16 rows)
SELECT  AVG(film.length) AS avg_length FROM film
JOIN  film_category fc ON  film.film_id = fc.film_id
GROUP BY fc.category_id;

-- Q4 How many copies of the film “Hunchback Impossible” exist in the inventory system? (6)
SELECT COUNT(film.film_id) AS total_stock FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible"

-- Q5 Using the tables “payment” and “customer” and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name (599 rows)
SELECT customer.last_name, SUM(payment.amount) AS total FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- Use world database
-- Q1 Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows)
SELECT code, name, continent, gnp FROM country
WHERE Name LIKE '%d_';

-- Q2 Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany)
SELECT code,name,continent,gnp FROM country
ORDER BY GNP DESC
LIMIT 2 OFFSET 1;

-- Q1 Write a query to display Employee id and First Name of an employee whose dept_id = 100. (Use:Sub-query)(6 rows)
SELECT employee_id, first_name FROM employees
JOIN departments ON employees.department_id= departments.department_id
WHERE employees.department_id = 100;

-- Q2. Write a query to display the dept_id, maximum salary, of all the departments whose maximum salary is greater than the average salary. (USE: SUB-QUERY) (11 rows) (doubt)
SELECT department_id, MAX(salary) AS max_salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
GROUP BY department_id ;      

-- Q3 Write a query to display department name and, department id of the employees whose salary is less than 35000. .(USE:SUB-QUERY)(11 rows) (doubt)
SELECT departments.department_name, departments.department_id FROM departments
JOIN employees ON employees.department_id = departments.department_id
WHERE employees.salary < 35000