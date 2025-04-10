# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales;
```

### 2. Data Cleaning and Schema Standardization

- **Schema Correction**: Standardized column names and types for readability and consistency.
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Safe Update Mode Handling**: Temporarily disabled SQL_SAFE_UPDATES to allow for deletion of blank rows, then re-enabled it for safety.

```sql

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM sales
Where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT *
FROM Sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, 
SUM(total_sale) AS net_sales,
COUNT(*) as total_orders
FROM Sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),2)AS avg_age,
category
FROM sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM sales
WHERE total_sale >1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,
gender,
COUNT(*) AS total_transaction
FROM sales
GROUP BY category,gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id,
SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
count(DISTINCT customer_id)
FROM sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT CASE 
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift,
COUNT(*) AS order_count
FROM Sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');
```

11. **Compare the total revenue generated in 2022 and 2023. Which year performed better in terms of sales**:
```sql
SELECT YEAR(sale_date) AS year,
ROUND(SUM(total_sale), 2) AS total_revenue
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date)
ORDER BY year;
```

12. **Compare the number of transactions made in each month of 2022 and 2023. Identify any seasonal patterns or shifts in customer behavior**:
```sql
SELECT YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
COUNT(*) AS transaction_count
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;
```

13. **Compare the average quantity sold per category between 2022 and 2023. Which category saw the most improvement or decline**:
```sql
SELECT category,
YEAR(sale_date) AS year,
ROUND(AVG(quantity), 2) AS avg_quantity
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY category, YEAR(sale_date)
ORDER BY category, year;
```

14. **Retrieve and compare all high-value orders (total_sale > 500) made by female customers in 2022 and 2023. Analyze if there's growth in premium purchases**:
```sql
SELECT *
FROM Sales
WHERE gender = 'Female'
  AND total_sale > 500
  AND YEAR(sale_date) IN (2022, 2023)
ORDER BY YEAR(sale_date), sale_date;
```

15. **Compare the top-selling categories by total sales in 2024 and 2025. Determine if the leading product category changed between the two years**:
```sql
SELECT YEAR(sale_date) AS year,
category,
SUM(total_sale) AS total_sales
FROM Sales
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY YEAR(sale_date), category
ORDER BY year, total_sales DESC;
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

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Tejas

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Connected

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/tejas-data-analyst/)
- **Gmail**: [For inquiries or collaboration opportunities, contact me](tejas.analyst.11304@gmail.com)

Thank you for your support, and I look forward to connecting with you!
