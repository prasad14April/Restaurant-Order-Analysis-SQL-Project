-- Restaurant Order Analysis SQL Project

CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

-- 1. Customers table
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  gender CHAR(1),
  city VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Rohan Mehta', 'M', 'Mumbai'),
(2, 'Priya Sharma', 'F', 'Delhi'),
(3, 'Amit Patel', 'M', 'Ahmedabad'),
(4, 'Neha Singh', 'F', 'Pune'),
(5, 'Arjun Nair', 'M', 'Bangalore');

-- 2. Menu items table
CREATE TABLE IF NOT EXISTS menu_items (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10,2)
);

INSERT INTO menu_items VALUES
(1, 'Margherita Pizza', 'Pizza', 350),
(2, 'Farmhouse Pizza', 'Pizza', 450),
(3, 'Veg Burger', 'Burger', 150),
(4, 'Chicken Burger', 'Burger', 200),
(5, 'French Fries', 'Snacks', 100),
(6, 'Cold Coffee', 'Beverage', 120),
(7, 'Brownie', 'Dessert', 180);

-- 3. Orders table
CREATE TABLE IF NOT EXISTS orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(101, 1, '2024-01-10', 820),
(102, 2, '2024-01-11', 670),
(103, 3, '2024-01-12', 470),
(104, 1, '2024-01-13', 270),
(105, 4, '2024-01-13', 720),
(106, 5, '2024-01-14', 420);

-- 4. Order details table
CREATE TABLE IF NOT EXISTS order_details (
  order_id INT,
  item_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

INSERT INTO order_details VALUES
(101, 1, 1),
(101, 5, 2),
(101, 6, 1),
(102, 2, 1),
(102, 7, 1),
(103, 3, 2),
(104, 5, 1),
(104, 6, 1),
(105, 4, 2),
(105, 7, 1),
(106, 3, 1),
(106, 6, 2);

Select * FROM customers;
Select * from menu_items;
Select * from orders;
Select * from order_details;


-- Sample Analysis Questions with Solution
#Show all customers
SELECT * FROM customers;

#Total number of orders
SELECT COUNT(*) AS total_orders FROM orders;
#Alternate way
SELECT COUNT(order_id) AS total_orders FROM orders;

#Total revenue
SELECT SUM(total_amount) AS total_revenue FROM orders;

#Average order value
SELECT AVG (total_amount) FROM orders;

#Find all customers from Mumbai
SELECT customer_name FROM customers
WHERE city = 'Mumbai';
#Output Insight: Rohan Mehta lives in Mumbai.

#List all items ordered in order ID = 101
SELECT m.item_name, od.quantity
FROM order_details od
JOIN menu_items m ON od.item_id = m.item_id
WHERE od.order_id = 101;

#Output Insight: Order 101 includes:Margherita Pizza (1)French Fries (2)Cold Coffee (1)
#If we just select m.item_name,then only name shows(which is also ok)


#Which menu items are most ordered
SELECT m.item_name, SUM(od.quantity) 
FROM order_details od
 JOIN menu_items m 
 ON od.item_id = m.item_id 
 GROUP BY m.item_name;



#Which customer spends the most
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
GROUP BY c.customer_name;
#Insight-Rohan Mehta spends the most
#Alternate Query(Same output)
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;
#Insight-Rohan Mehta spends the most

#How different cities are contributing to orders
SELECT c.city, COUNT(o.order_id) FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
GROUP BY c.city;
###Insight-Mumbai contributes the most...'contributing' to hence count is asked###

# Sort Customers alphabetically
SELECT customer_name FROM customers
ORDER BY customer_name ASC;
###Insight-Customers are sorted alphabetically from Amit Patel to Rohan Mehta
#For chronology and arrangement-order by is used

#Category-wise revenue(Extra Question)
SELECT m.category, SUM(m.price * od.quantity) AS category_revenue
FROM order_details od
JOIN menu_items m ON od.item_id = m.item_id
GROUP BY m.category
ORDER BY category_revenue DESC;
###Category-wise revenue displayed###
###First line,'price' is selected from menu_items and 'quantity' from order_details,hence price*quantity=revenue










