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


-- 2. CUSTOMER SEGMENTATION (VIP Clients)
-- Identifying the Top 10 customers with the highest total spend on valid products.
SELECT CustomerID, SUM(Quantity) AS Total_quantity ,SUM(Quantity*UnitPrice) AS Total_spent 
FROM clean_online_retail 
GROUP BY CustomerID 
ORDER BY Total_spent DESC
LIMIT 10


-- 3. REPEAT BUYERS ANALYSIS (Loyalty Metrics)
-- Finding super-loyal customers who have made more than 50 distinct orders.
SELECT 
    CustomerID, 
    COUNT(DISTINCT InvoiceNo) AS Total_Orders 
FROM clean_retail_transactions
GROUP BY CustomerID 
HAVING Total_Orders > 50
ORDER BY Total_Orders DESC;
