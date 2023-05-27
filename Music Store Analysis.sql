--Who is the senior most employee based on job title?

SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1

-- Which countries have the most invoices?

SELECT count(*), billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY count desc

--What are top 3 values of invoice?

SELECT TOTAL FROM invoice
order by total DESC
LIMIT 3

-- Which city has the best customers? 
--We would like to throw a promotional Music Festival in the city we made the most money.
--Write a query that returns one city that has the highest sum of invoice totals.
--Return both the city name & sum of all invoice totals.

SELECT billing_city, SUM(total) FROM invoice
group by billing_city
order by SUM(total) desc
limit 1

--Who is the best customer? 
--The customer who has spent the most money will be declared the best customer.
--Write a query that returns the person who has spent the most money

select customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total)
from customer
inner join invoice
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by SUM(invoice.total) desc
limit 1

--Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
--Return your list ordered alphabetically by email starting with A

select distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id = genre.genre_id 
where genre.name like 'Rock'
)
order by email


--Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id, artist.name, count(artist.artist_id) as no_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10


-- Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track.
--Order by the song length with the longest songs listed first

select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track) 
order by milliseconds desc


--Find how much amount is spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent

WITH best_selling_artist as select artist.artist_id as artist_id, artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by artist.artist_id
order by 3 desc
limit 1  


--We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre.
--For countries where the maximum number of purchases is shared return all Genres
	--rowno for returning the highest out of all countries, to find out the single highest out of a group
    
    
with popular_genre AS
( select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as RowNo
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join track on track.track_id = invoice_line.track_id
join customer on customer.customer_id = invoice.customer_id
join genre on genre.genre_id = track.genre_id
group by 2, 3, 4
order by 2 asc, 1 desc )

select * from popular_genre where RowNo <= 1
	--rowno for returning the highest out of all countries, to find out the single highest out of a group



--Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount


 with cust_with_country as (select customer.customer_id, first_name, last_name, billing_country,sum(total) as tot_spending,
row_number() over(partition by billing_country order by sum(total)desc)as rowno
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1, 2, 3, 4
order by 4 asc, 5 desc)
select * from cust_with_country where rowno =1






















