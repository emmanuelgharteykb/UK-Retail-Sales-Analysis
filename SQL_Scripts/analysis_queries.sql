# Step 1: The Sanity Check
SELECT * FROM sales_data LIMIT 10;
-- Observation
-- 1. The format for the date was 11/06/2025 (Text)
-- 2. The dates needed to be fixed because they were just a string of characters to the computer
-- 3. Some of the prices had 1 decimal place and others 2 decimal places and that also had to be fixed

# Fixing the Dates
SELECT OrderDate, STR_TO_DATE(OrderDate, "%d/%m/%Y") AS Cleaned_Date
FROM sales_data
LIMIT 10;

# Fixing the Prices
SELECT
	ProductName,
    -- Forces 2 dp and rounds it
    ROUND(CAST(UnitPrice AS DECIMAL(10,2)), 2) AS Formatted_Price
FROM sales_data
LIMIT 10;

# Revenue Trend Query / Total Revenue per Month
SELECT
	DATE_FORMAT(STR_TO_DATE(OrderDate, "%d/%m/%Y"), "%Y-%m") AS Sales_Month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Monthly_Revenue
FROM sales_data
GROUP BY 1
ORDER BY 1;
-- Observation
-- 1. It was observed that December had the highest revenue

# Query 1: Total Revenue, Profit, and Margin
SELECT 
    ROUND(SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2))), 2) AS Total_Revenue,
    ROUND(SUM(Quantity * (CAST(UnitPrice AS DECIMAL(10,2)) - CAST(CostPrice AS DECIMAL(10,2)))), 2) AS Total_Profit,
    ROUND(
        (SUM(Quantity * (CAST(UnitPrice AS DECIMAL(10,2)) - CAST(CostPrice AS DECIMAL(10,2)))) / 
        SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2)))) * 100, 2) AS Profit_Margin_Pct
FROM sales_data;
-- Observation
-- 1. Total revenue = 166,552.16
-- 2. Total profit = 58,593.61
-- 3. Profit margin per category = 35.18%

# Query 2: Monthly Trend / The Pulse
SELECT 
    DATE_FORMAT(STR_TO_DATE(OrderDate, '%d/%m/%Y'), '%Y-%m') AS Month, 
    ROUND(SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2))), 2) AS Monthly_Revenue
FROM sales_data
GROUP BY 1
ORDER BY 1;
-- Observation
-- 1. This generates a table of monthly revenues, with December being the highest

# Query 3: Regional Performance
SELECT 
    Region, 
    ROUND(SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2))), 2) AS Revenue,
    ROUND(SUM(Quantity * (CAST(UnitPrice AS DECIMAL(10,2)) - CAST(CostPrice AS DECIMAL(10,2)))), 2) AS Profit
FROM sales_data
GROUP BY Region
ORDER BY Revenue DESC;
-- Observation
-- 1. This generates a table of the various regions with their respective revenue and profits made
-- 2. It was observed there were 5 regions

# Query 4: Top 10 Profitable Products
SELECT 
    ProductName, 
    ROUND(SUM(Quantity * (CAST(UnitPrice AS DECIMAL(10,2)) - CAST(CostPrice AS DECIMAL(10,2)))), 2) AS Product_Profit
FROM sales_data
GROUP BY ProductName
ORDER BY Product_Profit DESC
LIMIT 10;
-- Observation
-- 1. This generates a table of the top 10 products with their respective profits made

# MoM Growth Rate
WITH MonthlySales AS (
    -- Step 1: Get total revenue for each month
    SELECT 
        DATE_FORMAT(STR_TO_DATE(OrderDate, '%d/%m/%Y'), '%Y-%m') AS Sales_Month, 
        SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2))) AS Current_Month_Revenue
    FROM sales_data
    GROUP BY 1
)
SELECT 
    Sales_Month,
    ROUND(Current_Month_Revenue, 2) AS Revenue,
    -- Step 2: Grab the revenue from the previous row
    ROUND(LAG(Current_Month_Revenue) OVER (ORDER BY Sales_Month), 2) AS Previous_Month_Revenue,
    -- Step 3: Calculate the % difference
    ROUND(
        ((Current_Month_Revenue - LAG(Current_Month_Revenue) OVER (ORDER BY Sales_Month)) / 
        LAG(Current_Month_Revenue) OVER (ORDER BY Sales_Month)) * 100, 2) AS MoM_Growth_Percentage
FROM MonthlySales;
-- Observation
-- 1. It was observed that losses were made or there were some negative growth rate in certain months.

# Checking Which Customers Generate 80% Revenue
WITH CustomerRevenue AS (
    -- Step 1: Calculate total revenue per customer
    SELECT 
        CustomerID,
        SUM(Quantity * CAST(UnitPrice AS DECIMAL(10,2))) AS Total_Customer_Revenue
    FROM sales_data
    GROUP BY CustomerID
),
CumulativeRevenue AS (
    -- Step 2: Calculate running total and the overall grand total
    SELECT 
        CustomerID,
        Total_Customer_Revenue,
        SUM(Total_Customer_Revenue) OVER (ORDER BY Total_Customer_Revenue DESC) AS Running_Total,
        SUM(Total_Customer_Revenue) OVER () AS Grand_Total
    FROM CustomerRevenue
)
-- Step 3: Filter for customers who make up the first 80%
SELECT 
    CustomerID,
    ROUND(Total_Customer_Revenue, 2) AS Revenue,
    ROUND((Running_Total / Grand_Total) * 100, 2) AS Cumulative_Percentage
FROM CumulativeRevenue
WHERE (Running_Total - Total_Customer_Revenue) / Grand_Total < 0.80
ORDER BY Total_Customer_Revenue DESC;
