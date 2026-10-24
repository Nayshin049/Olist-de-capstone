SET search_path TO raw;

--Q1.Rewrite last week's Q5 (revenue vs payments per order) using two CTEs.
with revenue as (
select order_id , sum(price + freight_value) as item_revenue from order_items oi group by 1),
payment as (
select order_id,sum(payment_value) as payments from order_payments op group by 1)
select r.order_id,item_revenue , payments 
from revenue r inner join payment p on r.order_id = p.order_id
limit 5;

--Q2.Sellers with no 1-star reviews at all — use NOT EXISTS.
select * from sellers s where not exists (
select seller_id from order_items oi inner join order_reviews r on oi.order_id = r.order_id 
where oi.seller_id = s.seller_id and r.review_score = 1)

--Q2.Sellers with no 1-star reviews at all — use NOT in
select * from sellers s where s.seller_id not in  (
select seller_id from order_items oi inner join order_reviews r on oi.order_id = r.order_id
where r.review_score = 1)

--Q3.Monthly revenue for delivered orders.
with monthly as (select date_trunc('month',o.order_purchase_timestamp )as month,sum(oi.price + oi.freight_value ) as revenue
from orders o inner join order_items oi on o.order_id = oi.order_id 
where o.order_status ='delivered'
group by 1)
select month , sum(revenue) as month_total
from monthly 
group by 1
order by month;


--Q4.For each month, which product category earned the most delivered revenue?

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
),
ranked AS (
    SELECT
        month,
        product_category_name,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY revenue DESC
        ) AS rn
    FROM monthly
)
SELECT
    month,
    product_category_name,
    revenue
FROM ranked
WHERE rn = 1
ORDER BY month;


