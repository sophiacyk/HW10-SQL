USE sakila;

-- 1a --
SELECT first_name, last_name FROM actor;

-- 1b --
SELECT upper(CONCAT(first_name, ' ' ,last_name)) AS 'Actor Name' 
FROM actor; 

-- 2a -- 
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'Joe'; 

-- 2b --
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name LIKE '%GEN%'; 

-- 2c -- 
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d -- 
 SELECT country_id, country
 FROM country
 WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
 
 -- 3a --
ALTER TABLE actor
ADD middle_name VARCHAR(45);

ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` VARCHAR(45) NULL AFTER `first_name`;

-- 3b --
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

-- 3c --
ALTER TABLE actor 
DROP COLUMN middle_name; 

-- 4a --
SELECT last_name, COUNT(last_name) AS actor_count
FROM actor
GROUP BY last_name;

-- 4b --
SELECT last_name, COUNT(last_name) AS actor_count
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>1;

-- 4c --
SELECT *
FRom actor
WHERE first_name='GROUCHO';

UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- 4d --
SELECT *
FROM actor
WHERE first_name='HARPO';

SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = CASE 
				WHEN (last_name='WILLIAMS' AND first_name='HARPO') 
				THEN 'GROUCHO'
                WHEN (last_name='WILLIAMS' AND first_name='GROUCHO') 
                THEN 'MUCHO GROUCHO'
END
WHERE actor_id=172;

SELECT * 
FROM actor
WHERE actor_id=172;

-- 5a --
SHOW CREATE TABLE address;

-- 6a --
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;

-- 6b --
SELECT s.staff_id, sum(p.amount) AS total_amount_in_2005Aug  
FROM payment AS p
INNER JOIN staff s ON s.staff_id=p.staff_id
WHERE p.payment_date BETWEEN '2005-08-01' and '2005-08-31'
GROUP BY s.staff_id;

-- 6c --
SELECT f.title, count(fa.actor_id) AS actor_number
FROM film_actor fa
INNER JOIN film f ON f.film_id=fa.film_id
GROUP BY fa.film_id;

-- 6d --
SELECT i.film_id, f.title, count(i.inventory_id) AS total_count
FROM inventory i
INNER JOIN film f ON f.film_id=i.film_id
WHERE f.title='Hunchback Impossible';

-- 6e --
SELECT c.first_name, c.last_name, sum(p.amount) AS total_amount  
FROM payment AS p
INNER JOIN customer c ON p.customer_id=c.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name ASC;

-- 7a --
SELECT f.title 
FROM film f
WHERE (f.title LIKE "K%" or "Q%") AND f.language_id IN
(
	SELECT language_id
	FROM language 
	WHERE name = 'English'
);

-- 7b --
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN
(
	 SELECT actor_id 
	 FROM film_actor
	 WHERE film_id IN
		(
			SELECT film_id
			FROM film
			WHERE title = 'Alone Trip'
		)
);

SELECT * FROM address LIMIT 5;

-- 7c --
SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
INNER JOIN address a 
ON a.address_id = cu.address_id 
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country='Canada';

-- 7d --
SELECT f.film_id, f.title
FROM film f
WHERE f.film_id IN
(	
	 SELECT film_id
     FROM film_category
     WHERE category_id IN
     (
		SELECT category_id
        FROM category
        WHERE name='Family'
    )
    
);

-- 7e --
-- This is to make sure no duplicate copies for each movie --
SELECT film_id, COUNT(DISTINCT film_id) 
FROM inventory
GROUP BY film_id
ORDER BY COUNT(DISTINCT film_id) DESC;

SELECT r.inventory_id, f.film_id, f.title, count(r.inventory_id) AS rented_count
FROM rental r
INNER JOIN inventory i
ON i.inventory_id = r.inventory_id
INNER JOIN film f
ON f.film_id = i.film_id
GROUP BY r.inventory_id
ORDER BY count(inventory_id) DESC;

-- 7f --
SELECT s.store_id, count(p.rental_id) AS rental_count, sum(p.amount) AS amount_USD$
FROM payment p
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN store s
ON s.store_id = i.store_id
GROUP BY s.store_id;

-- 7g --
SELECT s.store_id, a.address, ci.city, co.country
FROM store s
INNER JOIN address a
ON a.address_id = s.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country co
ON co.country_id = ci.country_id 
GROUP BY s.store_id;

-- 7h -- 
SELECT ca.name, sum(p.amount) AS amount_USD$
FROM payment p 
INNER JOIN rental r
ON r.rental_id = p.rental_id
INNER JOIN inventory i
ON i.inventory_id = r.inventory_id
INNER JOIN film_category fc
ON i.film_id = fc.film_id
INNER JOIN category ca
ON ca.category_id = fc.category_id
GROUP BY ca.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

-- 8a --
CREATE VIEW Top_5_genres_by_gross_revenue AS
SELECT ca.name, sum(p.amount) AS amount_USD$
FROM payment p 
INNER JOIN rental r
ON r.rental_id = p.rental_id
INNER JOIN inventory i
ON i.inventory_id = r.inventory_id
INNER JOIN film_category fc
ON i.film_id = fc.film_id
INNER JOIN category ca
ON ca.category_id = fc.category_id
GROUP BY ca.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

-- 8b --
SELECT * FROM Top_5_genres_by_gross_revenue;

-- 8c --
DROP VIEW Top_5_genres_by_gross_revenue;