--Exercise 1
--Q.1 What is the title of the album with AlbumId 67? 
SELECT title FROM albums
WHERE albumid = 67;

--Q.2 Find the name and length (in seconds) of all tracks that have length between 50 and 70 seconds. 
SELECT name, milliseconds/1000 as seconds
FROM tracks
WHERE milliseconds >= 50000 AND milliseconds <= 70000;

--Q.3 List all the albums by artists with the word ‘black’ in their name. 
SELECT * FROM albums
WHERE title LIKE '%black%';

--Q.4 Provide a query showing a unique/distinct list of billing countries from the Invoice table 
SELECT DISTINCT billingcountry FROM invoices;

--Q.5 Display the city with highest sum total invoice
SELECT billingcity, ROUND(SUM(total),0) AS highest_sum FROM invoices
GROUP BY billingcity
order by highest_sum DESC
LIMIT 1;

--Q.6 Produce a table that lists each country and the number of customers in that country. 
--(You only need to include countries that have customers) in descending order. (Highest count at the top) 
SELECT country, COUNT(country) AS customers FROM customers
GROUP BY country
having customers > 0
ORDER BY COUNT(country) DESC;

--Q.7 Find the top five customers in terms of sales i.e. find the five customers whose total combined invoice amounts are the highest.
--Give their name, CustomerId and total invoice amount. Use join 
SELECT c.firstname, I.customerid, SUM(I.total) as invoice_amount FROM customers c
JOIN invoices I ON  c.customerid = I.customerid
GROUP BY I.customerid
ORDER BY invoice_amount DESC
LIMIT 5;

--Q.8 Find out state wise count of customerID and list the names of states with count of customerID in decreasing order.
--Note:- do not include where states is null value.
SELECT state, COUNT(customerid) as customer_count FROM customers
WHERE state IS NOT NULL
GROUP BY state
ORDER BY customer_count DESC;

--Q.9 How many Invoices were there in 2009 and 2011?
SELECT COUNT(invoicedate) ,strftime('%Y', invoicedate) AS year
FROM invoices
WHERE year in ('2009', '2011')
GROUP by year;

--Q.10 Provide a query showing only the Employees who are Sales Agents.
SELECT firstname , title FROM employees
WHERE title LIKE 'Sales Support Agent'

--Exercise 2
--Q.1 Display Most used media types: their names and count in descending order. 
SELECT mt.name, COUNT(mt.Name) as total FROM media_types mt
JOIN tracks ON mt.mediatypeid =  tracks.mediatypeid
GROUP BY tracks.mediatypeid
ORDER BY total DESC;

--Q.2 Provide a query showing the Invoices of customers who are from Brazil. 
--The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country. 
SELECT firstname|| ' ' ||lastname as fullname, invoiceid, invoicedate, billingcountry FROM invoices i
JOIN customers c ON i.customerid = c.customerid
WHERE c.Country = 'Brazil'
ORDER BY i.InvoiceDate;

--Q.3 Display artist name and total track count of the top 10 rock bands from dataset.
SELECT artists.name, COUNT(tracks.name) AS track_count from artists
JOIN albums ON artists.artistid = albums.artistid
JOIN tracks ON albums.albumid = tracks.albumid
JOIN genres ON tracks.genreid = genres.GenreId
WHERE genres.name = 'Rock'
GROUP BY artists.name
ORDER BY track_count DESC
LIMIT 10;

--Q.4 Display the Best customer (in case of amount spent). Full name (first name and last name) 
SELECT customers.firstname || ' ' || customers.lastname AS full_name, SUM(invoices.total) as amount_spend FROM customers
JOIN invoices ON customers.customerid = invoices.customerid
GROUP by invoices.customerid
ORDER by amount_spend DESC
LIMIT 1;

--Q.5 Provide a query showing Customers (just their full names, customer ID and country) who are not in the US. 
SELECT firstname|| ' ' || lastname AS FULL_NAME, customerid, country FROM customers
WHERE country != 'USA';

--Q.6 Provide a query that shows the total number of tracks in each playlist in descending order. 
--The Playlist name should be included on the resultant table.
SELECT p.name, COUNT(pt.trackid) AS total_track  FROM playlists p
JOIN playlist_track pt ON p.playlistid = pt.playlistid
GROUP BY p.name
ORDER by total_track DESC;

--Q.7 Provide a query that shows all the Tracks, but displays no IDs.
--The result should include the Album name, Media type and Genre.
SELECT albums.title AS Albums,tracks.Name AS Tracks,media_types.Name AS Format,genres.Name AS Type FROM albums
JOIN tracks ON albums.AlbumId = tracks.AlbumId
JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
JOIN genres ON genres.GenreId = tracks.GenreId;

--Q.8 Provide a query that shows the top 10 bestselling artists. (In terms of earning).
SELECT artists.Name AS Artist, SUM(invoice_items.UnitPrice * invoice_items.Quantity) AS TotalEarnings
FROM artists
JOIN albums ON artists.ArtistId = albums.ArtistId
JOIN tracks ON albums.AlbumId = tracks.AlbumId
JOIN invoice_items ON tracks.TrackId = invoice_items.TrackId
GROUP BY artists.Name
ORDER BY TotalEarnings DESC
LIMIT 10;

--Q.9 Provide a query that shows the most purchased Media Type. 
SELECT mt.name, COUNT(*) AS purchased_type FROM media_types mt
JOIN tracks ON mt.MediaTypeId = tracks.MediaTypeId
JOIN invoice_items ON tracks.trackid = invoice_items.TrackId
GROUP BY mt.name
ORDER BY purchased_type DESC
LIMIT 1;

--Q.10 Provide a query that shows the purchased tracks of 2013. Display Track name and Units sold. 
SELECT tracks.name, SUM(invoice_items.quantity) AS units_sold FROM tracks
JOIN invoice_items ON tracks.trackid = invoice_items.trackid
JOIN invoices ON invoice_items.invoiceid = invoices.invoiceid
WHERE invoices.invoicedate >= '2013-01-01' AND invoices.invoicedate <= '2013-12-31'
GROUP BY tracks.name;






