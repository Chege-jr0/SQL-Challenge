-- Find the first order (by date) for each customer.
USE abc_data;

SELECT customer.customer_id,
orders.order_id,
orders.order_date
FROM customer
INNER JOIN orders ON customer.customer_id = orders.customer_id
WHERE orders.order_date = (
SELECT MIN(orders2.order_date)
FROM orders orders2
WHERE orders2.customer_id = orders.customer_id
);

-- Total revenue per product?
SELECT products.product_name,
SUM(products.price * order_items.quantity) AS total_revenue
FROM products
INNER JOIN order_items ON products.product_id = order_items.product_id
GROUP BY product_name
ORDER BY total_revenue DESC;

-- The day with the highest revenue.
SELECT products.product_name,MIN(orders.order_date) AS order_date,
SUM(products.price * order_items.quantity) AS total_revenue
FROM products
INNER JOIN order_items ON products.product_id = order_items.product_id
INNER JOIN orders ON order_items.order_id = orders.order_id
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 1;
