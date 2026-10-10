--Q1.How many customers are there in each state? Show the top 5 states.

select * from customers;

select count (*) customer,
customer_state 
from customers 
group by  customer_state 
order by customer desc 
limit 5;

--Q2.How many distinct real customers (customer_unique_id) are there?

select count(distinct customer_unique_id)
from customers;

--Q3.Which payment_type is used most, and what is its total payment_value?

select * from order_payments;

select payment_type,sum(payment_value)as total_payment,count(*)
from order_payments
group by payment_type 
order by total_payment desc
limit 1;
 
select * from products
