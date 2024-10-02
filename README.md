# sql_f_project

This SQL script is a comprehensive analysis of sales data from a coffee shop, covering various metrics such as total sales, orders, and quantities sold by different time periods, locations, and product categories. Here's a breakdown of the different sections:

**Date and Time Date Formatting:**

The script first coverts transaction_date and transaction_time to the correct formats (DATE and TIME respectively) for accurate querying.

**Sales And Orders Analysis:**

The script calculates total sales, orders, and quantities sold for specific months.
MoM (Month-over-Month) Growth for both total sales and orders is computed to track perfomance.


KPI Analysis (Sales, Orders, Quantity):
Key performance indicators such as MoM growth percentages are calculated for sales, orders, and quantities sold.
Sales Breakdown by Date, Time, and Weekdays/Weekends:
Daily sales and quantities are analyzed for specific dates.
Sales by weekdays and weekends are distinguished using dayofweek().
Store Location Sales Analysis:
The script analyzes total sales grouped by store locations for May.
Sales Comparison Against Averages:
Average sales are calculated for May, and daily sales are compared to identify days as "Above Average" or "Below Average."
Product Category Analysis:
Sales for specific product categories (e.g., coffee) are analyzed to identify the top-selling product types.
Hourly and Day of Week Sales:
Sales by hour of the day and specific days of the week (e.g., Sunday) are examined to find peak times.
This detailed breakdown can be used for insights on performance trends, peak sales times, and top-selling products.
