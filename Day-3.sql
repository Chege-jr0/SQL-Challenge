 Finding the cloumn with the highest price
SELECT * 
FROM product_data
ORDER BY product_price DESC
LIMIT 1;
-- or 
SELECT * 
FROM product_data
WHERE product_price = (SELECT MAX(product_price) FROM product_data);


-- Order that had the highest number of items
SELECT * 
FROM order_items
WHERE quantity = (SELECT MAX(quantity) FROM order_items)
