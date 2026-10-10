select *
from orders
limit 10 ;

select order_id,order_status as status
from orders limit 10;

select distinct order_status from orders;

select order_id,order_status as status
from orders 
where order_status = 'delivered';

select order_id,order_status as status
from orders 
where order_status <> 'canceled';

select distinct customer_state from customers;

select customer_id,customer_city from customers 
where customer_state in ('SP','SC','MG');

select * from order_items
where price between 10 and 50

--order by one cloumn 
select  order_id,product_id,price 
from order_items 
order by price desc;

--order by two column
select  price + freight_value as total_paid,
order_id 
from order_items 
order by total_paid , order_id;

select count(*),
order_status
from orders 
group by order_status ;

select count(*),
customer_state 
from customers c 
where c.customer_state <> 'SP'
group by customer_state 

select seller_id,
count(*)item_id
from order_items 
group by seller_id 
having count(*)>100;

select *
from order_items

select countcustomer_id 
from customers