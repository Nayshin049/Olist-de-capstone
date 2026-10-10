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
order by review_score desc;

--Q.5.Sellers by state: which states have more than 50 sellers?

select count(*) as sellers_count,
seller_state
from sellers 
group by seller_state
having count(*)> 50 
order by sellers_count desc;

--Q.6.Average price and freight per order item, rounded to 2 decimals.

select order_id,
round (avg(price),2) avg_price,
round (avg(freight_value),2) avg_freight
from order_items
group by order_id;
