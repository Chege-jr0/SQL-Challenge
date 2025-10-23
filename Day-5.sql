-- First order for each customer
SELECT 
    customer_data.customer_id,
    customer_data.first_name,
    customer_data.last_name,
    MIN(order_data.order_date) AS first_order_date
FROM customer_data
JOIN order_data 
    ON customer_data.customer_id = order_data.customer_id
GROUP BY 
    customer_data.customer_id,
    customer_data.first_name,
    customer_data.last_name
ORDER BY first_order_date;


-- Calculating the total revenue for each product
SELECT 
    product_data.product_id,
    product_data.product_name,
    SUM(order_items.quantity * product_data.product_price) AS total_revenue
FROM order_items
JOIN product_data 
    ON order_items.product_id = product_data.product_id
GROUP BY 
    product_data.product_id,
    product_data.product_name
ORDER BY total_revenue DESC;


-- Find the day with the highest total revenue
SELECT 
    order_data.order_date,
    SUM(order_items.quantity * product_data.product_price) AS total_revenue
FROM order_data
JOIN order_items 
    ON order_data.order_id = order_items.order_id
JOIN product_data 
    ON order_items.product_id = product_data.product_id
GROUP BY order_data.order_date
ORDER BY total_revenue DESC
LIMIT 1;

-- or with aliases(but i don't like it)
SELECT 
    o.order_date,
    SUM(oi.quantity * p.product_price) AS daily_revenue
FROM order_data o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN product_data p 
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY daily_revenue DESC
LIMIT 1;
