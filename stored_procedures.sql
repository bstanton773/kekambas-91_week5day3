SELECT *
FROM customer
WHERE loyalty_member = TRUE;

-- RESET ALL MEMBERS TO LOYALTY = FALSE
UPDATE customer
SET loyalty_member = FALSE;


-- Create a Procedure that will set customers who have spent at least $100 to loyalty members

-- Query to get customer_ids of those who have spent at least $100
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >= 100;

-- UPDATE STATEMENT to set loyalty_member to true based on previous query
UPDATE customer 
SET loyalty_member = TRUE
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);


-- Put the above steps into a procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer 
	SET loyalty_member = TRUE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= 100
	);
END;
$$


-- Execute a procedure - use the CALL keyword
CALL update_loyalty_status(); 

SELECT *
FROM customer 
WHERE loyalty_member = TRUE;


SELECT customer_id, SUM(amount)
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount) BETWEEN 95 AND 100;

-- Push one of the customers over the $100 threshold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(554, 1, 2, 5, '2022-06-03 10:43:00');

SELECT *
FROM customer c 
WHERE customer_id = 554;

-- Call the procedure 
CALL update_loyalty_status(); 

-- Check that 554 has been updated
SELECT *
FROM customer c 
WHERE customer_id = 554;


-- Create a procedure that takes in agruments
CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR(50), last_name VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES (first_name, last_name, NOW());
END;
$$



-- Add an actor using the procedure
CALL add_actor('Tom', 'Hanks');

SELECT *
FROM actor
WHERE last_name = 'Hanks';


CALL add_actor('Tom', 'Cruise');


SELECT *
FROM actor 
WHERE first_name = 'Tom';



-- To delete a procedure, use DROP
DROP PROCEDURE IF EXISTS add_actor;



