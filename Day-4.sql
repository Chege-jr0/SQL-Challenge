-- Which Customer has the most orders
SELECT order_counts as (
SELECT customer_id, count(order_id) AS order_count
FROM xxxx
GROUP BY xxxx),
max_order_count AS (
SELECT max(order_count) as max_count
FROM xxxx )
SELECT c.first_name, c.last_name
FROM xxxx c
JOIN order_counts oc ON c.customer_id = oc.customer_id
JOIN max_order_count moc ON oc.order_count = moc.max_count;
