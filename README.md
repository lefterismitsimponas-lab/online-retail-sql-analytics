# online-retail-sql-analytics
SQL-based data cleaning, customer segmentation, and behavior analytics on an E-commerce retail dataset.

### 📈 Business Impact
- **Inventory Control:** Identifies high-volume vs. high-yield products to reduce storage costs.
- **Seasonality Insights:** Uncovers monthly trendsetters for targeted marketing campaigns.
- **Retention Mapping:** Segments VIP and repeat buyers for loyalty program positioning.


## Project Overview
This project is an end-to-end SQL analysis using a raw e-commerce dataset (2010-2011). The main goal was to take a noisy, unrefined transactional dataset, clean it thoroughly by removing system errors and cancellations, and then run business intelligence queries to understand product trends and customer loyalty.

I used SQLite for this project because of its simplicity and lightweight setup.

## Skills and Techniques Used
- Data Cleaning: Applied pattern matching (GLOB) to filter out non-product stock codes, handled null values, and removed transactional noise.
- Advanced SQL: Used Common Table Expressions (CTEs) and Window Functions (ROW_NUMBER) to solve complex analytical questions.
- Aggregations: Heavy use of SUM, COUNT DISTINCT, and date manipulation (strftime).

## Project Workflow

### 1. Data Cleaning
The raw data contained several issues like missing customer IDs, system tests, and cancelled orders. I created a new permanent table called `clean_online_retail` using specific filters:
- Kept only valid product codes (using regex/glob patterns for numeric codes and specific gift card prefixes).
- Excluded cancelled transactions (Invoice numbers starting with 'C').
- Removed records with missing Customer IDs to ensure data accountability.
- Filtered out negative quantities and free samples (UnitPrice > 0).

### 2. Product Analysis
- Top Products: I split the top-performing products into two categories: top 5 by total quantity sold and top 5 by total revenue generated. Both queries look dynamically at the last 6 months of the dataset.
- Monthly Best-Sellers: To find the top product for each month, I wrote a query using a CTE and the ROW_NUMBER() function. This ranks products by revenue within each calendar month and returns only the number one item.

### 3. Customer Loyalty & Segmentation
- High-Value Customers: Identified the top 10 buyers based on their total spending.
- Order Frequency: Filtered the dataset to find power users who completed more than 50 separate orders, which helps isolate the most loyal customer segment.

## Key Takeaways
- Separating high-volume products from high-revenue products helps optimize inventory decisions.
- Tracking the best-seller of each month makes it easy to see seasonal shifts in customer behavior.
- The loyalty queries provide clean lists of Customer IDs that could be directly used by a marketing team for loyalty rewards.

## How to use this repository
The repository contains the main SQL script. You can run the queries sequentially in any SQLite environment. The first step will generate the cleaned table, and the subsequent queries will output the analytical results.

