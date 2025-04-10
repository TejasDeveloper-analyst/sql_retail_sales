-- SQL Retail Sales Analysis

CREATE DATABASE retail_sales;

SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) 
FROM retail_sales

-- Data Cleaning and Schema Standardization

ALTER TABLE sales
MODIFY COLUMN sale_date DATE;

ALTER TABLE sales
MODIFY COLUMN sale_time TIME;

ALTER TABLE sales
CHANGE COLUMN `ï»¿transactions_id` transactions_id INT;

ALTER TABLE sales
ADD PRIMARY KEY (transactions_id);

ALTER TABLE sales
MODIFY COLUMN gender VARCHAR(15);

ALTER TABLE sales
MODIFY COLUMN price_pe_unit FLOAT;

ALTER TABLE sales
MODIFY COLUMN cogs FLOAT;

ALTER TABLE sales
MODIFY COLUMN total_sales FLOAT;

SELECT * 
FROM retail_sales.sales
Where 
      transactions_id IS NULL
      OR sale_date IS NULL
      OR sale_time IS NULL
      OR customer_id IS NULL
      OR gender IS NULL
      OR age IS NULL
      OR category IS NULL
      OR quantiy IS NULL
      OR price_per_unit IS NULL
      OR cogs IS NULL
      OR total_sale IS NULL;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM sales
WHERE (transactions_id IS NULL OR TRIM(transactions_id) = '')
  AND (sale_date IS NULL OR TRIM(sale_date) = '')
  AND (sale_time IS NULL OR TRIM(sale_time) = '')
  AND (customer_id IS NULL OR TRIM(customer_id) = '')
  AND (gender IS NULL OR TRIM(gender) = '')
  AND (age IS NULL OR TRIM(age) = '')
  AND (category IS NULL OR TRIM(category) = '')
  AND (quantiy IS NULL OR TRIM(quantiy) = '')
  AND (price_per_unit IS NULL OR TRIM(price_per_unit) = '')
  AND (cogs IS NULL OR TRIM(cogs) = '')
  AND (total_sale IS NULL OR TRIM(total_sale) = '');

SET SQL_SAFE_UPDATES = 1;

-- Data Exploration

-- How many sales we have?
SELECT Count(*) as Total_Sale From Sales;

-- How many Unique Customer we have?
SELECT Count(DISTINCT customer_id)AS UniqueCustomerCount From Sales;

-- What are the Unique Category we have?
SELECT DISTINCT category AS UniqueCategory From Sales;

-- Total revenue from all sales
SELECT SUM(total_sale) AS TotalRevenue FROM Sales;


-- Average customer age
SELECT AVG(age) AS AverageCustomerAge FROM Sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales. 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).
-- Q.11 Compare the total revenue generated in 2022 and 2023. Which year performed better in terms of sales.
-- Q.12 Compare the number of transactions made in each month of 2022 and 2023. Identify any seasonal patterns or shifts in customer behavior.
-- Q.13 Compare the average quantity sold per category between 2022 and 2023. Which category saw the most improvement or decline.
-- Q.14 Retrieve and compare all high-value orders (total_sale > 500) made by female customers in 2022 and 2023. Analyze if there's growth in premium purchases.
-- Q.15 Compare the top-selling categories by total sales in 2024 and 2025. Determine if the leading product category changed between the two years.


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT * 
FROM Sales
Where sale_date = '2022-11-05';

-- Q2. Retrieve all 'Clothing' transactions with quantity > 3 in November 2022.
SELECT *
FROM Sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
SUM(total_sale) AS net_sales,
COUNT(*) as total_orders
FROM Sales
GROUP BY category;

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)AS avg_age,
category
FROM sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM sales
WHERE total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,
gender,
COUNT(*) AS total_transaction
FROM sales
GROUP BY category,gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
WITH monthly_sales AS (
SELECT YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
ROUND(AVG(total_sale), 2) AS avg_monthly_sale,
SUM(total_sale) AS total_sales
FROM Sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_sales AS (
SELECT *,
RANK() OVER (PARTITION BY year ORDER BY total_sales DESC) AS sales_rank
FROM monthly_sales
)
SELECT year,
month,
avg_monthly_sale,
total_sales,
CASE WHEN sales_rank = 1 THEN 'Yes' ELSE 'No' END AS best_selling_month
FROM ranked_sales
ORDER BY year, month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id,
SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
count(DISTINCT customer_id)
FROM sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT CASE 
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift,
COUNT(*) AS order_count
FROM Sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');

-- Q.11 Compare the total revenue generated in 2022 and 2023. Which year performed better in terms of sales.
SELECT YEAR(sale_date) AS year,
ROUND(SUM(total_sale), 2) AS total_revenue
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date)
ORDER BY year;

--Q.12 Compare the number of transactions made in each month of 2022 and 2023. Identify any seasonal patterns or shifts in customer behavior.
SELECT YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
COUNT(*) AS transaction_count
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;

--Q.13 Compare the average quantity sold per category between 2022 and 2023. Which category saw the most improvement or decline.
SELECT category,
YEAR(sale_date) AS year,
ROUND(AVG(quantity), 2) AS avg_quantity
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY category, YEAR(sale_date)
ORDER BY category, year;

--Q.14 Retrieve and compare all high-value orders (total_sale > 500) made by female customers in 2022 and 2023. Analyze if there's growth in premium purchases.
SELECT *
FROM Sales
WHERE gender = 'Female'
  AND total_sale > 500
  AND YEAR(sale_date) IN (2022, 2023)
ORDER BY YEAR(sale_date), sale_date;

--Q.15 Compare the top-selling categories by total sales in 2024 and 2025. Determine if the leading product category changed between the two years.
SELECT YEAR(sale_date) AS year,
category,
SUM(total_sale) AS total_sales
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date), category
ORDER BY year, total_sales DESC;

-- End of Project













