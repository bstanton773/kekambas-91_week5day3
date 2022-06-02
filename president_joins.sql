-- Customer Table
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	address VARCHAR(100),
	city VARCHAR(30),
	state VARCHAR(2),
	zipcode VARCHAR(5)
);

SELECT *
FROM customer;

-- Order Table
CREATE TABLE order_(
	order_id SERIAL PRIMARY KEY,
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	amount NUMERIC(5,2),
	customer_id INTEGER,
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);


SELECT *
FROM order_;


-- Add Data to the customer table
INSERT INTO customer(first_name, last_name, email, address, city, state, zipcode)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA', '87522'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA', '43592'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA', '34532'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA', '43538'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL', '60623');


SELECT *
FROM customer;


-- Add data to the order table one by one

INSERT INTO order_(amount, customer_id)
VALUES (22.44, 1);

INSERT INTO order_(amount, customer_id)
VALUES (99.88, 1);

INSERT INTO order_(amount, customer_id)
VALUES (88.22, 3);

INSERT INTO order_(amount, customer_id)
VALUES (11.99, 2);

INSERT INTO order_(amount, customer_id)
VALUES (10.99, null);

INSERT INTO order_(amount, customer_id)
VALUES (11.02, null);

SELECT *
FROM order_;


SELECT first_name, last_name, email
FROM customer
WHERE customer_id = 1;


SELECT amount
FROM order_ 
WHERE customer_id = 1;


-- Inner Join
SELECT *
FROM order_
JOIN customer  -- JOIN and INNER JOIN are the same thing
ON customer.customer_id = order_.customer_id;


-- Full OUTER Join
SELECT *
FROM order_
FULL JOIN customer
ON customer.customer_id = order_.customer_id;



-- Left Join
SELECT *
FROM order_;

SELECT *
FROM order_  -- LEFT TABLE because it is first one mentioned 
LEFT JOIN customer -- RIGHT TABLE
ON customer.customer_id = order_.customer_id;


SELECT *
FROM customer;

SELECT *
FROM customer  -- LEFT TABLE because it is first one mentioned 
LEFT JOIN order_ -- RIGHT TABLE
ON customer.customer_id = order_.customer_id;


-- RIGHT JOIN
SELECT *
FROM customer;

SELECT *
FROM order_  -- LEFT TABLE because it is first one mentioned 
RIGHT JOIN customer -- RIGHT TABLE
ON customer.customer_id = order_.customer_id;



-- Left Join is just the opposite of the Right Join
SELECT first_name, last_name, email, amount, order_date
FROM order_
LEFT JOIN customer
ON customer.customer_id = order_.customer_id;

SELECT first_name, last_name, email, amount, order_date
FROM customer
RIGHT JOIN order_
ON customer.customer_id = order_.customer_id;


SELECT first_name, last_name, email, amount, order_date
FROM customer
LEFT JOIN order_
ON customer.customer_id = order_.customer_id;

SELECT first_name, last_name, email, amount, order_date
FROM order_
RIGHT JOIN customer
ON customer.customer_id = order_.customer_id;

-- Using JOINS with our DQL Statements
SELECT *
FROM customer 
LEFT JOIN order_ 
ON customer.customer_id = order_.customer_id
WHERE state = 'VA';


-- Specifying columns that show up in both tables
SELECT customer.customer_id, first_name, last_name, email, amount, order_date
FROM customer
JOIN order_
ON customer.customer_id = order_.customer_id;


--SELECT student.first_name, student.last_name, teacher.last_name
--FROM student
--JOIN teacher
--ON student.teacher_id = teacher.teacher_id;


-- Alias table names 
SELECT c.customer_id, c.first_name, c.last_name, c.email, o.amount, o.order_date
FROM customer c 
JOIN order_ o 
ON c.customer_id = o.customer_id;


-- Using Joins with Group Bys, Having, Order By, etc.
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spent
FROM customer c 
JOIN order_ o 
ON c.customer_id = o.customer_id 
GROUP BY c.customer_id
HAVING SUM(o.amount) > 50
ORDER BY total_spent DESC;







