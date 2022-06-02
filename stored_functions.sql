SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'B%';

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'G%';


-- Create a stored function - give us the count of actors whose last name begins with *letter*
--def get_actor_count(letter):
--	count = 0
--	FOR actor IN actors:
--		IF actor.last_name[0] == letter:
--			count += 1
--	RETURN count
CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name LIKE CONCAT(letter, '%');

	RETURN actor_count;
END;
$$

-- Execute our function - use SELECT clause
SELECT get_actor_count('D');

SELECT get_actor_count('F');


-- Create a function that will return the employee with the most transactions (based on payments)

SELECT CONCAT(first_name, ' ', last_name) AS employee
FROM staff 
WHERE staff_id = (
	SELECT staff_id 
	FROM payment p 
	GROUP BY staff_id 
	ORDER BY COUNT(*) DESC
	LIMIT 1
);

CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR(100);
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) INTO employee
	FROM staff 
	WHERE staff_id = (
		SELECT staff_id 
		FROM payment p 
		GROUP BY staff_id 
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);

	RETURN employee;
END;
$$

SELECT employee_with_most_transactions();


-- Functions can return Tables
-- Create a function that will return a table with customers and their full address (address, city, district, country) by country
CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR(50))
RETURNS TABLE(
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	city VARCHAR,
	district VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci 
	ON a.city_id = ci.city_id 
	JOIN country co 
	ON ci.country_id = co.country_id 
	WHERE co.country = country_name;
END;
$$



SELECT *
FROM customers_in_country('United States');

SELECT *
FROM customers_in_country('China');


SELECT *
FROM customers_in_country('United States')
WHERE district = 'Illinois';


-- Delete a function - DROP FUNCTION function_name
DROP FUNCTION IF EXISTS get_actor_count;



