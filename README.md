# # Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Dataset**: `SQL - Retail Sales Analysis_utf `

This project aims to analyze a dataset of retail sales, with the usage of a series of beginner-to-intermediate SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all columns for sales made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales 
	where category = 'Clothing'
	and quantity > 3
	and year(sale_date) = 2022
	and month(sale_date) = 11;
```

3. **Calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select count(*) 'Number of transactions', gender, category from retail_sales 
group by gender, category order by 1;
```

7. **(a) Calculate the average sale for each month. (b) Find out the best selling
--	month in each year**:
```sql
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
```

8. **Find the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Find the number of unique customers who purchased items from each category.**:
```sql
select count(distinct customer_id) distinct_customers, category 
from retail_sales 
group by category;
```

10. **Compute the number of total orders for each shift (Morning <12, Afternoon Between 12 & 18,
--	 Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusions

This project covers database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
