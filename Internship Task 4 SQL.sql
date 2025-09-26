use pratiksha;
show tables;
-- All customers from Maharashtra
SELECT * 
FROM customers 
WHERE state = 'MH';

-- Orders above Rs. 1000 ordered by amount descending
SELECT * 
FROM orders 
WHERE amount > 1000 
ORDER BY amount DESC;

#GROUP BY + Aggregate Functions

-- Total amount spent by each customer
SELECT c.customer_id, c.first_name, SUM(o.amount) AS total_spent
FROM customers c
JOIN `orders (1)` o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name;

-- Count of orders per state
SELECT c.state, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN `orders (1)` o ON c.customer_id = o.customer_id
GROUP BY c.state;

# JOINS (INNER, LEFT, RIGHT)

-- INNER JOIN: Orders with customer names
SELECT o.order_id, c.first_name, o.amount
FROM `orders (1)` o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN: All customers and their orders (customers with no orders also visible)
SELECT c.first_name, o.order_id, o.amount
FROM customers c
LEFT JOIN `orders (1)` o ON c.customer_id = o.customer_id;

-- RIGHT JOIN: All orders and their customers (MySQL/PostgreSQL)
SELECT c.first_name, o.order_id, o.amount
FROM customers c
RIGHT JOIN `orders (1)` o ON c.customer_id = o.customer_id;

# Subqueries

-- Customers who spent more than the average total spend
SELECT first_name, last_name 
FROM customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM `orders (1)`
    GROUP BY customer_id
    HAVING SUM(amount) > (SELECT AVG(amount) FROM `orders (1)`)
);

-- Products with price higher than average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

# Create Views

-- View for total order amounts per customer
CREATE VIEW customer_order_summary AS
SELECT c.customer_id, c.first_name, SUM(o.amount) AS total_spent
FROM customers c
JOIN `orders (1)` o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name;

-- Query from the view
SELECT * 
FROM customer_order_summary 
WHERE total_spent > 1000;

# Indexes (for optimization)

-- Index on orders.customer_id for faster joins/lookups
CREATE INDEX idx_orders_customer ON `orders (1)`(customer_id);

-- Index on order_items.product_id for faster product lookups
CREATE INDEX idx_orderitems_product ON order_items(product_id);

-- Detailed breakdown of each order with product details
SELECT o.order_id, c.first_name, p.product_name, p.category, 
       oi.quantity, (oi.quantity * p.price) AS total_price
FROM `orders (1)` o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;