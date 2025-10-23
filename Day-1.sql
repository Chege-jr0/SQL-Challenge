CREATE TABLE customer_data (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(40),
last_name VARCHAR(40),
customer_email VARCHAR(100)
);

CREATE TABLE product_data (
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(40),
product_price DECIMAL (10,2)
);

CREATE TABLE order_data (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
order_date DATE
);


CREATE TABLE order_items (
order_id INT,
product_id INT,
quantity INT);
