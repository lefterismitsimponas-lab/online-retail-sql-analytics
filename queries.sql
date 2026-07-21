-- ==========================================
-- E-COMMERCE RETAIL DATA CLEANING & ANALYTICS
-- ==========================================

-- 1. DATA CLEANING
-- Creating a permanent clean dataset by filtering out internal noise, 
-- cancellations, and missing customer/product information.
CREATE TABLE clean_online_retail AS
SELECT * 
FROM online_retail 
WHERE (StockCode GLOB 'gift*'  
   OR StockCode GLOB 'DCGS*'  
   OR StockCode GLOB '[0-9]*') 
   AND InvoiceNo NOT GLOB 'C*' -- Exclude formal cancellations
   AND CustomerID IS NOT NULL  -- Exclude anonymous transactions
   AND Quantity > 0            -- Exclude stock corrections / negative quantities
   AND UnitPrice > 0           -- Exclude free samples or system errors
   AND Description IS NOT NULL;

-- 2. Top 5 Products by Quantity Sold
-- Summing the total quantity sold for each product over the last 6 months of the dataset.
SELECT Description, SUM(Quantity) AS Total_Quantity
FROM clean_online_retail
WHERE InvoiceDate >= DATE((SELECT MAX(InvoiceDate) FROM clean_online_retail), '-6 months')
GROUP BY Description 
ORDER BY Total_Quantity DESC 
LIMIT 5;

-- 3. Top 5 Products by Revenue Generated
-- Calculating total revenue (Quantity * UnitPrice) for each product over the last 6 months of the dataset.
SELECT Description,SUM(Quantity * UnitPrice) AS Total_Revenue
FROM clean_online_retail
WHERE InvoiceDate >= DATE((SELECT MAX(InvoiceDate) FROM clean_online_retail), '-6 months')
GROUP BY Description 
ORDER BY Total_Revenue DESC 
LIMIT 5;

--4. BestSeller for each month.
-- Identifies the top-performing product (highest revenue) for each calendar month.
WITH MonthlyProductRevenue AS (
    SELECT 
        strftime('%Y-%m', InvoiceDate) AS Order_Month,
        Description AS Product_Description,
        SUM(Quantity * UnitPrice) AS Total_Product_Revenue,
        -- Assigns a rank to each product within the same month based on revenue
        ROW_NUMBER() OVER (
            PARTITION BY strftime('%Y-%m', InvoiceDate) 
            ORDER BY SUM(Quantity * UnitPrice) DESC
        ) AS Revenue_Rank
    FROM clean_online_retail
    GROUP BY Order_Month,Product_Description
)
-- Selects only the #1 top-selling product for each month
SELECT Order_Month, Product_Description AS Best_Seller,
    ROUND(Total_Product_Revenue, 2) AS Monthly_Revenue
FROM MonthlyProductRevenue
WHERE Revenue_Rank = 1
ORDER BY Order_Month ASC;

-- 5. CUSTOMER SEGMENTATION (VIP Clients)
-- Identifying the Top 10 customers with the highest total spend on valid products.

SELECT CustomerID, SUM(Quantity) AS Total_quantity ,SUM(Quantity*UnitPrice) AS Total_spent 
FROM clean_online_retail 
GROUP BY CustomerID 
ORDER BY Total_spent DESC
LIMIT 10


-- 6. REPEAT BUYERS ANALYSIS (Loyalty Metrics)
-- Finding super-loyal customers who have made more than 50 distinct orders.
   
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Total_Orders 
FROM clean_online_retail
GROUP BY CustomerID 
HAVING Total_Orders > 50
ORDER BY Total_Orders DESC;
