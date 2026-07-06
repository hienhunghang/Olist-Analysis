--Marketplace Growth
--Total GMV
SELECT
SUM(price+freight_value) AS Total_GMV
FROM order_items;
--Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;
--Total Customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers;
--Total Seller
SELECT COUNT(seller_id) AS Total_sellers
FROM sellers
--AOV
SELECT SUM(price + freight_value) * 1.0 / COUNT(DISTINCT order_id) AS AOV
FROM order_items;
--
SELECT
    YEAR(o.order_purchase_timestamp) AS Year,
    MONTH(o.order_purchase_timestamp) AS Month,
    SUM(oi.price + oi.freight_value) AS GMV,
    COUNT(DISTINCT o.order_id) AS Orders,
    COUNT(DISTINCT c.customer_unique_id) AS Active_Customers,
    COUNT(DISTINCT oi.seller_id) AS Active_Sellers,
    SUM(oi.price + oi.freight_value) * 1.0 /
        COUNT(DISTINCT o.order_id) AS AOV
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id

JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)

ORDER BY
Year,
Month;

WITH MonthlyGrowth AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Month,

        SUM(oi.price + oi.freight_value) AS GMV

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    Month,
    GMV,

    LAG(GMV) OVER(ORDER BY Month) AS Previous_GMV,

    ROUND(
        (GMV - LAG(GMV) OVER(ORDER BY Month))
        *100.0/
        LAG(GMV) OVER(ORDER BY Month)
    ,2) AS Growth_Rate

FROM MonthlyGrowth;

--Create View Marketplace Growth
Go
CREATE VIEW vw_marketplace_growth AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    c.customer_unique_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS gmv
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id;
go

--Seller Performance
--Seller Summary
SELECT
oi.seller_id,
s.seller_city,
s.seller_state,
COUNT(DISTINCT oi.order_id) AS total_orders,
SUM(oi.price + oi.freight_value) AS total_gmv,
AVG(oi.price + oi.freight_value) AS avg_item_value
FROM order_items oi
JOIN sellers s
ON oi.seller_id=s.seller_id
GROUP BY
oi.seller_id,
s.seller_city,
s.seller_state;
--Revenue distribute
SELECT
seller_id,
SUM(price+freight_value) AS seller_gmv
FROM order_items
GROUP BY seller_id
ORDER BY seller_gmv DESC;
--Pareto Analysis (80/20)
WITH seller_gmv AS
(
SELECT
seller_id,
SUM(price+freight_value) AS seller_gmv
FROM order_items
GROUP BY seller_id
)
SELECT
seller_id,
seller_gmv,
SUM(seller_gmv)
OVER(ORDER BY seller_gmv DESC) AS cumulative_gmv,
SUM(seller_gmv)
OVER(ORDER BY seller_gmv DESC)*100.0/SUM(seller_gmv)
OVER() AS cumulative_pct
FROM seller_gmv
ORDER BY seller_gmv DESC;
--View Sale Performance
Go
CREATE VIEW vw_seller_performance AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,

    s.seller_id,
    s.seller_city,
    s.seller_state,

    c.customer_unique_id,

    p.product_id,
    ct.product_category_name_english,

    oi.order_item_id,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS gmv

FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN sellers s
    ON oi.seller_id = s.seller_id
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name;
Go
--Operation Performance
--View Operation
go
CREATE VIEW vw_marketplace_operations AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.order_status,
    cu.customer_unique_id,
    cu.customer_city,
    cu.customer_state,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS gmv,

    DATEDIFF(
        DAY,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) AS delivery_days,

    DATEDIFF(
        DAY,
        o.order_purchase_timestamp,
        o.order_approved_at
    ) AS approval_days,

    DATEDIFF(
        DAY,
        o.order_approved_at,
        o.order_delivered_carrier_date
    ) AS carrier_days,

    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS late_delivery

FROM orders o

INNER JOIN customers cu
    ON o.customer_id = cu.customer_id

INNER JOIN order_items oi
    ON o.order_id = oi.order_id;
go
--Median delivery time
SELECT
PERCENTILE_CONT(0.5)
WITHIN GROUP
(
ORDER BY delivery_days
)
OVER()
AS Median_Delivery_Days

FROM vw_marketplace_operations;
--Average delivery time
SELECT AVG(delivery_days) AS Avg_Delivery_Days
FROM vw_marketplace_operations;
--Late Delivery rate
SELECT 100.0* SUM(late_delivery)/COUNT(DISTINCT order_id)AS Late_Delivery_Rate
FROM vw_marketplace_operations;
--Avarage Freight
SELECT AVG(freight_value)
FROM vw_marketplace_operations;
--Monthly Delivery time
SELECT
YEAR(order_purchase_timestamp) AS Year,
MONTH(order_purchase_timestamp) AS Month,
AVG(delivery_days) AS Monthly_Delivery_time

FROM vw_marketplace_operations

GROUP BY YEAR(order_purchase_timestamp),
         MONTH(order_purchase_timestamp)

ORDER BY 1,2;
--Monthly Late Delivery rate
SELECT

YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp),
100.0*
SUM(late_delivery)
/COUNT(DISTINCT order_id)
AS late_rate

FROM vw_marketplace_operations

GROUP BY YEAR(order_purchase_timestamp),
         MONTH(order_purchase_timestamp)
ORDER BY
1,2;
--delivery time by state
SELECT customer_state, AVG(delivery_days) AS avg_delivery
FROM vw_marketplace_operations
GROUP BY customer_state
ORDER BY avg_delivery DESC;
--Late Delivery Rate by State
SELECT customer_state,
100.0*
SUM(late_delivery)
/COUNT(DISTINCT order_id)
AS late_rate

FROM vw_marketplace_operations
GROUP BY customer_state
ORDER BY late_rate DESC;
--Freight vs Delivery
SELECT
freight_value,
delivery_days
FROM vw_marketplace_operations;
--Freight by State
SELECT customer_state, AVG(freight_value) AS avg_freight
FROM vw_marketplace_operations
GROUP BY customer_state
ORDER BY avg_freight DESC;
--Customer Satisfaction
--View Customer Satisfaction
go
CREATE VIEW vw_customer_satisfaction AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    c.customer_unique_id,
    c.customer_state,

    r.review_id,
    r.review_score,
    r.review_creation_date,

    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS gmv,

    DATEDIFF(
        DAY,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) AS delivery_days,

    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS late_delivery

FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN reviews r
ON o.order_id = r.order_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id;
go
--Average Review Score
SELECT
AVG(CAST(review_score AS FLOAT)) AS avg_review_score
FROM vw_customer_satisfaction;
-- 5-Star rate
SELECT 100.0 * SUM(CASE
                        WHEN review_score=5
                        THEN 1
                        ELSE 0
                        END)
/COUNT(*)

AS five_star_rate
FROM vw_customer_satisfaction;
-- 1-star rate
SELECT 100.0 * SUM( CASE WHEN review_score=1 THEN 1 ELSE 0 END)
/
COUNT(*)

AS one_star_rate
FROM vw_customer_satisfaction;
-- review distribution
SELECT review_score, COUNT(*) AS total_reviews
FROM vw_customer_satisfaction
GROUP BY review_score
ORDER BY review_score;
-- Average Review by Delivery Status
SELECT late_delivery, AVG(CAST(review_score AS FLOAT)) AS avg_review
FROM vw_customer_satisfaction
GROUP BY late_delivery;
-- Review Distribution for Late Orders
SELECT review_score, COUNT(*) AS total_reviews
FROM vw_customer_satisfaction
WHERE late_delivery=1
GROUP BY review_score
ORDER BY review_score;
--Review Distribution for On-Time Orders
SELECT review_score, COUNT(*) AS total_reviews
FROM vw_customer_satisfaction
WHERE late_delivery=0
GROUP BY review_score
ORDER BY review_score;
-- Delivery Time vs Review
SELECT review_score, AVG(delivery_days) AS avg_delivery
FROM vw_customer_satisfaction
GROUP BY review_score
ORDER BY review_score DESC;