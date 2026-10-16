set search_path to raw;

--Q1.Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.

select 
customer_state,
sum(price) as revenue
from orders o 
inner join customers c 
on c.customer_id =o.customer_id
inner join order_items oi
on o.order_id = oi.order_id
where order_status = 'delivered'
group by customer_state 
order by revenue desc 
limit 10;

--Q2.How many orders have no review at all? (anti-join)
select 
count(*) total_orders
from orders o
left join order_reviews r on 
o.order_id = r.order_id
where r.order_id is null;



--Q3.Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?
select 
count(*)as items_sold,
ct.product_category_name_english
from order_items oi
inner join products p
on oi.product_id = p.product_id 
left join category_translation ct
on p.product_category_name = ct.product_category_name
group by ct.product_category_name_english
 order by items_sold desc
  limit 10;
--We used left join for question-3 because we wanna keep the categories without translation in english by null.


--Q4.What share of order items were sold by a seller in the same state as the customer?
with same_state as 
(select 
count(*) same_state_items
from order_items oi
inner join sellers s
on oi.seller_id = s.seller_id
inner join orders o
on oi.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
where s.seller_state = c.customer_state)
select round(100.00 * same_state_items/ (select count(*) from order_items) ,2)as share_of_same_state
from same_state;


--Q.5.For 5 orders, show item revenue and payment total side by side — without fan-out.
select oi.order_id, oi.revenue,p.total_payments
from (select order_id,sum(price)as revenue from order_items group by 1) oi 
inner join (select order_id,sum(payment_value) as total_payments from order_payments group by 1) p
on oi.order_id = p.order_id   
order by oi.revenue desc
limit 5;


--Q.6.Find orders where payments differ from price + freight by more than 1.00.

select oi.order_id,
oi.total_price,
oi.total_freight,
p.total_payments,
oi.total_price+oi.total_freight as expected_total,
ABS(p.total_payments - (oi.total_price+oi.total_freight)) as difference
from (select order_id,sum(price) total_price,sum(freight_value)total_freight from order_items group by 1)oi
inner join (select order_id,sum(payment_value)as total_payments from order_payments group by 1) p
on oi.order_id = p.order_id 
where ABS(p.total_payments - (oi.total_price+oi.total_freight)) >1
order by difference desc;











