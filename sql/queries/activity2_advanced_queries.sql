-- Activity 2: Advanced Analytical Queries for SmartShop Inventory System
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Complex multi-table JOIN queries, subqueries, and aggregate functions for business intelligence

-- ========================================
-- PART 1: Multi-Table JOIN Queries
-- ========================================

-- Query 1: Product Sales Analysis - JOIN Products, Sales, and Stores
-- This query displays ProductName, SaleDate, StoreLocation, and UnitsSold
-- Uses multiple JOINs to combine data from different tables

SELECT 
    p.product_name AS ProductName,
    s.sale_date AS SaleDate,
    st.store_name AS StoreLocation,
    s.units_sold AS UnitsSold,
    s.unit_price AS UnitPrice,
    s.total_amount AS TotalSales
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN stores st ON s.store_id = st.store_id
ORDER BY s.sale_date DESC, s.total_amount DESC;

-- Query 2: Product Sales with Category and Supplier Information
-- Extended JOIN to include category and supplier details
-- Useful for understanding which suppliers and categories are performing best

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    sup.supplier_name AS Supplier,
    s.sale_date AS SaleDate,
    st.store_name AS StoreLocation,
    s.units_sold AS UnitsSold,
    s.total_amount AS TotalSales
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
INNER JOIN stores st ON s.store_id = st.store_id
ORDER BY s.sale_date DESC, c.category_name, s.total_amount DESC;

-- Query 3: Sales Performance by Store and Date Range
-- Shows sales performance across different stores within a specific date range
-- Includes running totals and daily summaries

SELECT 
    st.store_name AS StoreLocation,
    s.sale_date AS SaleDate,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS DailySalesAmount,
    AVG(s.total_amount) AS AverageSaleAmount,
    MAX(s.total_amount) AS LargestSale
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
WHERE s.sale_date BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY st.store_name, s.sale_date
ORDER BY s.sale_date DESC, SUM(s.total_amount) DESC;

-- ========================================
-- PART 2: Aggregate Functions and Analysis
-- ========================================

-- Query 4: Total Sales for Each Product
-- Uses SUM aggregate function to calculate total sales per product
-- Includes units sold and revenue metrics

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS TotalRevenue,
    AVG(s.total_amount) AS AverageSaleAmount,
    MIN(s.sale_date) AS FirstSale,
    MAX(s.sale_date) AS LastSale
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY SUM(s.total_amount) DESC NULLS LAST;

-- Query 5: Top-Performing Suppliers Based on Sales Volume
-- Analyzes supplier performance based on delivered stock and sales performance
-- Combines purchase orders and sales data

SELECT 
    sup.supplier_name AS SupplierName,
    sup.contact_person AS ContactPerson,
    sup.email AS SupplierEmail,
    COUNT(DISTINCT po.product_id) AS ProductsSupplied,
    SUM(po.delivered_quantity) AS TotalUnitsDelivered,
    SUM(po.total_cost) AS TotalPurchaseCost,
    AVG(po.unit_cost) AS AverageUnitCost,
    COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) AS DelayedDeliveries,
    ROUND(
        (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)), 2
    ) AS DelayPercentage
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name, sup.contact_person, sup.email
ORDER BY SUM(po.delivered_quantity) DESC;

-- Query 6: Supplier Performance with Delay Analysis
-- Identifies suppliers with the most delayed deliveries
-- Uses conditional aggregation and date calculations

SELECT 
    sup.supplier_name AS SupplierName,
    COUNT(po.po_id) AS TotalOrders,
    COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) AS DelayedOrders,
    COUNT(CASE WHEN po.is_delayed = 0 THEN 1 END) AS OnTimeOrders,
    ROUND(AVG(po.delay_days), 2) AS AverageDelayDays,
    MAX(po.delay_days) AS MaxDelayDays,
    ROUND(
        (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)), 2
    ) AS DelayPercentage,
    CASE 
        WHEN (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)) <= 10 THEN 'EXCELLENT'
        WHEN (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)) <= 25 THEN 'GOOD'
        WHEN (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)) <= 50 THEN 'FAIR'
        ELSE 'POOR'
    END AS PerformanceRating
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
ORDER BY DelayPercentage ASC, AverageDelayDays ASC;

-- ========================================
-- PART 3: Subqueries and Complex Analysis
-- ========================================

-- Query 7: Products with Above-Average Sales Performance
-- Uses subquery to find products performing better than average
-- Compares individual product sales to overall average

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    product_sales.total_revenue AS ProductRevenue,
    product_sales.total_units AS ProductUnitsSold,
    overall_avg.avg_revenue AS OverallAverageRevenue,
    ROUND(
        (product_sales.total_revenue - overall_avg.avg_revenue), 2
    ) AS RevenueVsAverage,
    ROUND(
        (product_sales.total_revenue / overall_avg.avg_revenue * 100), 2
    ) AS PercentageOfAverage
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN (
    -- Subquery: Calculate total sales per product
    SELECT 
        product_id,
        SUM(total_amount) AS total_revenue,
        SUM(units_sold) AS total_units
    FROM sales
    GROUP BY product_id
) product_sales ON p.product_id = product_sales.product_id
CROSS JOIN (
    -- Subquery: Calculate overall average revenue per product
    SELECT 
        AVG(product_totals.total_revenue) AS avg_revenue
    FROM (
        SELECT 
            product_id,
            SUM(total_amount) AS total_revenue
        FROM sales
        GROUP BY product_id
    ) product_totals
) overall_avg
WHERE product_sales.total_revenue > overall_avg.avg_revenue
ORDER BY RevenueVsAverage DESC;

-- Query 8: Inventory Consolidation Across Stores
-- Combines inventory data from multiple stores for consolidated reporting
-- Shows total stock, average stock per store, and stock distribution

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    SUM(i.stock_level) AS TotalStock,
    COUNT(DISTINCT i.store_id) AS StoresCarryingProduct,
    ROUND(AVG(i.stock_level), 2) AS AverageStockPerStore,
    MIN(i.stock_level) AS MinStockAtStore,
    MAX(i.stock_level) AS MaxStockAtStore,
    -- Stock distribution analysis
    ROUND(
        (MAX(i.stock_level) - MIN(i.stock_level)) * 100.0 / NULLIF(AVG(i.stock_level), 0), 2
    ) AS StockVariabilityPercentage,
    -- Store details with stock levels
    GROUP_CONCAT(
        st.store_name || ': ' || i.stock_level || ' units', 
        ' | '
    ) AS StockByStore
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN inventory i ON p.product_id = i.product_id
INNER JOIN stores st ON i.store_id = st.store_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY TotalStock DESC;

-- Query 9: Sales Trends by Category and Time Period
-- Advanced time-based analysis with monthly trends
-- Uses date functions and window functions for trend analysis

SELECT 
    c.category_name AS Category,
    strftime('%Y-%m', s.sale_date) AS SaleMonth,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS MonthlyRevenue,
    COUNT(DISTINCT s.product_id) AS DistinctProductsSold,
    ROUND(AVG(s.total_amount), 2) AS AverageSaleAmount,
    -- Compare with previous month using window function
    LAG(SUM(s.total_amount), 1) OVER (
        PARTITION BY c.category_name 
        ORDER BY strftime('%Y-%m', s.sale_date)
    ) AS PreviousMonthRevenue,
    -- Calculate month-over-month growth
    CASE 
        WHEN LAG(SUM(s.total_amount), 1) OVER (
            PARTITION BY c.category_name 
            ORDER BY strftime('%Y-%m', s.sale_date)
        ) IS NOT NULL THEN
            ROUND(
                (SUM(s.total_amount) - LAG(SUM(s.total_amount), 1) OVER (
                    PARTITION BY c.category_name 
                    ORDER BY strftime('%Y-%m', s.sale_date)
                )) * 100.0 / LAG(SUM(s.total_amount), 1) OVER (
                    PARTITION BY c.category_name 
                    ORDER BY strftime('%Y-%m', s.sale_date)
                ), 2
            )
        ELSE NULL
    END AS MonthOverMonthGrowthPercent
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, strftime('%Y-%m', s.sale_date)
ORDER BY c.category_name, strftime('%Y-%m', s.sale_date);

-- Query 10: Most Profitable Store-Product Combinations
-- Identifies the most profitable combinations of stores and products
-- Uses complex aggregation and ranking

SELECT 
    st.store_name AS StoreName,
    p.product_name AS ProductName,
    c.category_name AS Category,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS TotalRevenue,
    COUNT(s.sale_id) AS NumberOfSales,
    ROUND(AVG(s.total_amount), 2) AS AverageSaleAmount,
    -- Calculate profitability metrics
    ROUND(SUM(s.total_amount) / COUNT(s.sale_id), 2) AS RevenuePerSale,
    ROUND(SUM(s.units_sold) / COUNT(s.sale_id), 2) AS UnitsPerSale,
    -- Rank by total revenue
    RANK() OVER (ORDER BY SUM(s.total_amount) DESC) AS RevenueRank,
    -- Rank within store
    RANK() OVER (
        PARTITION BY st.store_name 
        ORDER BY SUM(s.total_amount) DESC
    ) AS StoreRank,
    -- Rank within category
    RANK() OVER (
        PARTITION BY c.category_name 
        ORDER BY SUM(s.total_amount) DESC
    ) AS CategoryRank
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name, p.product_name, c.category_name
ORDER BY TotalRevenue DESC
LIMIT 20;
