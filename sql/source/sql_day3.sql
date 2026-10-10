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

select payment_type,sum(payment_value)as total_payment,count(*)
from order_payments
group by payment_type 
order by total_payment desc
limit 1;
 
--Q.4.How many reviews are there for each review_score (1 to 5)? What is the overall average score?
select count(*),
review_score ,
round (avg(review_score ),2) avg_score
from order_reviews
where review_score between 1 and 5
group by review_score 
order by review_score desc

