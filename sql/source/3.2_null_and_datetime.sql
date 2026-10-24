--Q1. NULL audit: count NULLs in product_category_name and product_weight_g.
select
COUNT(*) - COUNT(product_category_name) AS null_category_count,
COUNT(*) - COUNT(product_weight_g) AS null_weight_count
FROM products;

--Q2. For each month of purchase, what is the average delivery time, and how many orders (and what percentage) were delivered within 30 days of purchase?
SELECT
DATE_TRUNC('month', o.order_purchase_timestamp)::date AS purchase_month,
ROUND( AVG(EXTRACT(EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )) / 86400
        )::numeric, 2
    ) AS avg_delivery_days,
   COUNT(*) AS total_orders,
    COUNT(*)filter (where o.order_delivered_customer_date
              <= o.order_purchase_timestamp + INTERVAL '30 days'
    ) AS delivered_within_30_days,
    ROUND(
        100.0 * COUNT(*)filter (where o.order_delivered_customer_date
              <= o.order_purchase_timestamp + INTERVAL '30 days'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS within_30_days_pct
FROM orders o
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

--Q.3On which day of the week do customers place the most orders? Show each weekday’s name and number, and the total orders for that day, sorted from busiest to quietest.

SELECT
TO_CHAR(order_purchase_timestamp,'Day') AS weekday_name,
EXTRACT(DOW FROM order_purchase_timestamp) AS weekday_number,
COUNT(*) AS total_orders       
from orders
GROUP by weekday_name,weekday_number
ORDER by total_orders DESC;
    
    --Q.4 What is the total revenue for each product category, shown with its English name? If a category has no English translation, show the original Portuguese name instead. If the product has no category at all, show it as ‘unknown’.
SELECT
COALESCE(
t.product_category_name_english,
p.product_category_name,
'unknown') AS category_name,
ROUND(SUM(oi.price+oi.freight_value)::numeric, 2) AS total_revenue
FROM order_items oi
join products p ON oi.product_id = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY total_revenue DESC;

--Q.5 Group delivered orders by delivery speed:
--•           Fast: 7 days or less from purchase to delivery.
--•           Normal: 8 to 14 days.
--•           Slow: 15 to 30 days.
--•           Very slow: more than 30 days.
--How many orders fall into each group, and what percentage of the total is each?

WITH delivery_times AS (
SELECT
EXTRACT( EPOCH FROM ( order_delivered_customer_date
                - order_purchase_timestamp) ) / 86400 AS delivery_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT null),

group_orders AS (
SELECT
case when delivery_days <= 7
     then'Fast'
     WHEN delivery_days <= 14
     THEN 'Normal'
     WHEN delivery_days <= 30
     then 'Slow'
     ELSE 'Very slow' 
     end  as delivery_speed
FROM delivery_times),

summary AS ( 
SELECT
delivery_speed,
COUNT(*) AS total_orders 
FROM group_orders
GROUP BY delivery_speed
)

select 
delivery_speed,
total_orders,
ROUND( 100.0 * total_orders/ SUM(total_orders) OVER (),2) as percentage
FROM summary 
ORDER by delivery_speed;
    