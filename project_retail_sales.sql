create database retail_sales_analysis;
use retail_sales_analysis

-- CREATE Table
create table retail_sales(
	transactions_id INT primary KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(30),
	age INT,
	category VARCHAR(30),
	quantiy int,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT);

show variables like 'secure_file_priv';

-- ROWS COUNT check
select count(*) from retail_sales;


-- NULL values check
select * from retail_sales 
where 
	transactions_id is null
	or sale_date is null 
	or sale_time is null 
	or gender is null 
	or customer_id is null 
	or age is null
	or category is null 
	or quantity is null 
	or price_per_unit is null 
	or cogs is null
	or total_sale is null;

-- DELETE null values
delete from retail_sales
where 
	transactions_id is null
	or sale_date is null 
	or sale_time is null 
	or gender is null 
	or customer_id is null 
	or age is null
	or category is null 
	or quantity is null 
	or price_per_unit is null 
	or cogs is null
	or total_sale is null;

-- Data Exploration

-- How many sales we have?
select COUNT(*) as total_sales from retail_sales;

-- How many unique customers we have?

select COUNT(distinct customer_id) as total_customers from retail_sales;

-- Which categories?

select distinct category as total_categories from retail_sales;


-- Data Analysis & Business Key Problems and Answers
/*	1. Retrieve all columns for sales made on '2022-11-05
	2. Retrieve all transactions where the category is 'Clothing'
	and the quantity sold is more than 3 in the month of Nov-2022
	3. Calculate the total sales (total_sale) for each category.
	4. Find the average age of customers who purchased items from
	the 'Beauty' category.
	5. Find all transactions where the total_sale
	 is greater than 1000.
	6. find the total number of transactions (transaction_id) made by
	each gender in each category.
	7. Calculate the average sale for each month. Find out best selling
	month in each year.
	8.  Find the top 5 customers based on the highest total sales
	9. Find the number of unique customers who purchased items from each category.
	10. create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17,
	 Evening >17)
*/

-- Q.1 Retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 3 in the month of Nov-2022
select * from retail_sales 
	where category = 'Clothing'
	and quantity > 3
	and year(sale_date) = 2022
	and month(sale_date) = 11;
	
-- Q.3 Calculate the amount of total sales (total_sale) for each category
select sum(total_sale) 'Total sales by category', category from retail_sales
group by category;

-- Q.4 Find the average age of customers who purchased items from
-- 	the 'Beauty' category.
select round(avg(age)) 'Average customer age', category from retail_sales 
where category = 'Beauty';

-- Q.5 Find all transactions where the total_sale
--  is greater than 1000

select * from retail_sales
where total_sale > 1000;

-- Q.6 Find the total number of transactions made by
--	each gender in each category.
select count(*) 'Number of transactions', gender, category from retail_sales 
group by gender, category;

-- Q.7 (a) Calculate the average sale for each month. (b) Find out the best selling
--	month in each year.

-- (a)
select round(avg(total_sale),2) 'Average sale amount',  concat(month(sale_date),'-', year(sale_date)) month_sale
from retail_sales 
group by  month_sale
order by 1;

-- (b)
select  years, months best_months, sum_of_sales
from (
select sum(total_sale) sum_of_sales, year(sale_date) years, month(sale_date) months,
rank() over(partition by year(sale_date) order by sum(total_sale) desc) ranking
from retail_sales 
group by 2,3
) t 
where ranking = 1;

-- Q.8 Find the top 5 customers based on the highest total sales 
select 
customer_id, 
sum(total_sale) total_amount_by_customer
from retail_sales 
group by customer_id
order by 2 desc
limit 5;

-- Q.9 Find the number of unique customers who purchased items from each category.
select count(distinct customer_id) distinct_customers, category 
from retail_sales 
group by category;

-- Q.10 Compute the number of total orders for each shift (Morning <12, Afternoon Between 12 & 18,
--	 Evening >17)
with hourly_sale 
as 
(
select *,
	case
		when hour(sale_time) < 12 then 'Morning'
		when hour(sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
		end shift
	from retail_sales
)
select count(*) total_orders, shift from hourly_sale
group by shift;












































