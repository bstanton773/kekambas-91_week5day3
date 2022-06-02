SELECT *
FROM actor;

SELECT *
FROM film;

SELECT *
FROM film_actor;

-- Join the actor table to the film_actor table
SELECT *
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id;


-- Join the film table to the film_actor;
SELECT *
FROM film_actor
JOIN film
ON film.film_id = film_actor.film_id
ORDER BY film.film_id;


-- Join the film table to the film_actor table and then join that to the actor table
SELECT f.rental_duration, f.film_id, f.title, f.description, a.actor_id, a.first_name, a.last_name 
FROM film f 
JOIN film_actor fa 
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id
WHERE f.rental_duration > 4
ORDER BY film_id;






-- SUBQUERIES!!!!
-- Which film has the most actors in it?

SELECT *
FROM film;

SELECT *
FROM film_actor;

-- Step 1. Get the film id of the film with the most actors in using the film_actor table
SELECT film_id
FROM film_actor
GROUP BY film_id
ORDER BY COUNT(*) DESC
LIMIT 1;
-- Film ID: 508 has the most.

-- Step 2. Get the film info from the film table using the id from step 1.
SELECT *
FROM film 
WHERE film_id = 508;


-- Combine the two queries into a subquery. The query you want to run FIRST is the subquery
-- *Subquery must return only ONE column* **unless used in a FROM

SELECT film_id, title, description
FROM film 
WHERE film_id = (
	SELECT film_id
	FROM film_actor
	GROUP BY film_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);


-- Have a subquery return ONE column with MULTIPLE rows
-- List the categories that have more than 60 films in that category
SELECT category_id
FROM film_category
GROUP BY category_id
HAVING COUNT(*) > 60
ORDER BY COUNT(*) DESC;

--15
--9
--8
--6
--2
--1
--13
--7
--14
--10

SELECT *
FROM category
WHERE category_id IN (
	15,
	9,
	8,
	6,
	2,
	1,
	13,
	7,
	14,
	10
);


-- Turn above into subquery
SELECT *
FROM category
WHERE category_id IN (
	SELECT category_id
	FROM film_category
	GROUP BY category_id
	HAVING COUNT(*) > 60
	ORDER BY COUNT(*) DESC
);


-- Use subquery for calculation

-- List all of the payments that are more that the average customer pay
SELECT AVG(amount)
FROM payment;


SELECT *
FROM payment
WHERE amount > (
	SELECT AVG(amount)
	FROM payment
);


-- Subqueries with FROM clause 
-- *Subquery in FROM must have an alias*
-- List customers who have more rentals than the average customer

SELECT *
FROM rental;

-- Get the customers rental counts
SELECT customer_id, COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id;

-- Find the average from the customer rental counts
SELECT AVG(num_rentals)
FROM (
	SELECT customer_id, COUNT(*) AS num_rentals
	FROM rental
	GROUP BY customer_id
) AS customer_rental_counts;

-- Find the customers by ID who have more rentals than the average
SELECT customer_id
FROM rental 
GROUP BY customer_id 
HAVING COUNT(*) > (
	SELECT AVG(num_rentals)
	FROM (
		SELECT customer_id, COUNT(*) AS num_rentals
		FROM rental
		GROUP BY customer_id
	) AS customer_rental_counts
);

-- List the customer names who have more rentals than average using the customer ids from prev query
SELECT customer_id, first_name, last_name
FROM customer 
WHERE customer_id IN (
	SELECT customer_id
	FROM rental 
	GROUP BY customer_id 
	HAVING COUNT(*) > (
		SELECT AVG(num_rentals)
		FROM (
			SELECT customer_id, COUNT(*) AS num_rentals
			FROM rental
			GROUP BY customer_id
		) AS customer_rental_counts
	)
);



