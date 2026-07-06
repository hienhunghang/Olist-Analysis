USE master;
GO

ALTER DATABASE [Olist Raw]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [Olist Raw];
GO

Create database [Olist raw]
go

Use [Olist raw];
go

CREATE TABLE customers (
    customer_id CHAR(100) PRIMARY KEY,
    customer_unique_id CHAR(100) NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city NVARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL
);

CREATE TABLE sellers (
    seller_id CHAR(100) PRIMARY KEY,
    seller_zip_code_prefix INT NOT NULL,
    seller_city NVARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL
);

CREATE TABLE products (
    product_id CHAR(100) PRIMARY KEY,
    product_category_name NVARCHAR(100) NOT NULL,
    product_name_lenght FLOAT NOT NULL,
    product_description_lenght FLOAT NOT NULL,
    product_photos_qty FLOAT NOT NULL,
    product_weight_g FLOAT NOT NULL,
    product_length_cm FLOAT NOT NULL,
    product_height_cm FLOAT NOT NULL,
    product_width_cm FLOAT NOT NULL
);

CREATE TABLE category_translation (
    product_category_name NVARCHAR(100) PRIMARY KEY,
    product_category_name_english NVARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id CHAR(100) PRIMARY KEY,
    customer_id CHAR(100) NOT NULL,
    order_status VARCHAR(20) NOT NULL,

    order_purchase_timestamp DATETIME2 NOT NULL,
    order_approved_at DATETIME2 NULL,
    order_delivered_carrier_date DATETIME2 NULL,
    order_delivered_customer_date DATETIME2 NULL,
    order_estimated_delivery_date DATETIME2 NOT NULL
);

CREATE TABLE order_items (
    order_id CHAR(100) NOT NULL,
    order_item_id INT NOT NULL,
    product_id CHAR(100) NOT NULL,
    seller_id CHAR(100) NOT NULL,

    shipping_limit_date DATETIME2 NOT NULL,

    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE payments (
    order_id CHAR(100) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE reviews (
    review_id CHAR(100) PRIMARY KEY,
    order_id CHAR(100) NOT NULL,
    review_score INT NOT NULL,

    review_comment_title NVARCHAR(MAX) NULL,
    review_comment_message NVARCHAR(MAX) NULL,

    review_creation_date DATETIME2 NOT NULL,
    review_answer_timestamp DATETIME2 NOT NULL
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat FLOAT NOT NULL,
    geolocation_lng FLOAT NOT NULL,
    geolocation_city NVARCHAR(100) NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);

ALTER TABLE orders
ADD CONSTRAINT FK_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

ALTER TABLE payments
ADD CONSTRAINT FK_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);



DELETE FROM order_items;
DELETE FROM payments;
DELETE FROM reviews;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM sellers;
DELETE FROM customers;
DELETE FROM geolocation;
DELETE FROM category_translation;

select * from order_items
SELECT * FROM customers;
SELECT * FROM sellers;
SELECT * FROM products;
SELECT * FROM category_translation;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT * FROM reviews;
SELECT * FROM geolocation;

SELECT name
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('reviews');


ALTER TABLE reviews
DROP CONSTRAINT PK__reviews__60883D9084E7D76D;
ALTER TABLE reviews
ADD CONSTRAINT PK_reviews
PRIMARY KEY (review_id, order_id);

--EDA
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_type
ORDER BY total_payments DESC;

SELECT TOP 10
    ct.product_category_name_english,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation ct
ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY revenue DESC;
