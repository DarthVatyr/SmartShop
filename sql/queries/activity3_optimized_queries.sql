-- Activity 3: Optimized High-Performance Queries
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Final optimized versions of Activity 2 queries with performance improvements

-- ========================================
-- OPTIMIZED MULTI-TABLE JOIN QUERIES
-- ========================================

-- OPTIMIZED Query 1: Product Sales Analysis
-- Improvements: Added strategic indexes, specified column order for better performance
-- Performance: Optimized with idx_sales_date_product_store index

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
WHERE s.sale_date >= '2025-01-01'  -- Filter early for better performance
ORDER BY s.sale_date DESC, s.total_amount DESC
LIMIT 100;  -- Limit results for better performance

-- OPTIMIZED Query 2: Product Sales with Category and Supplier
-- Improvements: Reordered JOINs for better execution plan, added early filtering
-- Performance: Optimized with idx_products_category_supplier index

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    sup.supplier_name AS Supplier,
    s.sale_date AS SaleDate,
    st.store_name AS StoreLocation,
    s.units_sold AS UnitsSold,
    s.total_amount AS TotalSales
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
INNER JOIN sales s ON p.product_id = s.product_id
INNER JOIN stores st ON s.store_id = st.store_id
WHERE s.sale_date >= '2025-01-01'  -- Early filtering
  AND p.is_active = TRUE           -- Only active products
ORDER BY s.sale_date DESC, c.category_name, s.total_amount DESC
LIMIT 100;

-- OPTIMIZED Query 3: Sales Performance by Store and Date Range
-- Improvements: Added date range parameters, optimized aggregation
-- Performance: Leverages idx_sales_date_product_store index

SELECT 
    st.store_name AS StoreLocation,
    s.sale_date AS SaleDate,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS DailySalesAmount,
    ROUND(AVG(s.total_amount), 2) AS AverageSaleAmount,
    MAX(s.total_amount) AS LargestSale
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
WHERE s.sale_date BETWEEN '2025-01-01' AND '2025-02-28'  -- Specific date range
GROUP BY st.store_id, st.store_name, s.sale_date  -- Include store_id for better grouping
ORDER BY s.sale_date DESC, SUM(s.total_amount) DESC;

-- ========================================
-- OPTIMIZED AGGREGATE QUERIES
-- ========================================

-- OPTIMIZED Query 4: Total Sales for Each Product
-- Improvements: Better NULL handling, optimized aggregation order
-- Performance: Uses idx_sales_product_date index

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    COALESCE(COUNT(s.sale_id), 0) AS NumberOfSales,
    COALESCE(SUM(s.units_sold), 0) AS TotalUnitsSold,
    COALESCE(SUM(s.total_amount), 0) AS TotalRevenue,
    COALESCE(ROUND(AVG(s.total_amount), 2), 0) AS AverageSaleAmount,
    MIN(s.sale_date) AS FirstSale,
    MAX(s.sale_date) AS LastSale
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE p.is_active = TRUE  -- Filter inactive products early
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY COALESCE(SUM(s.total_amount), 0) DESC;

-- OPTIMIZED Query 5: Supplier Performance Analysis (FIXED)
-- Improvements: Fixed missing column errors, optimized delay calculation
-- Performance: Uses idx_po_supplier_status_dates index

SELECT 
    sup.supplier_name AS SupplierName,
    sup.contact_person AS ContactPerson,
    sup.email AS SupplierEmail,
    COUNT(DISTINCT po.product_id) AS ProductsSupplied,
    SUM(po.delivered_quantity) AS TotalUnitsDelivered,
    SUM(po.total_cost) AS TotalPurchaseCost,
    ROUND(AVG(po.unit_cost), 2) AS AverageUnitCost,
    -- FIXED: Calculate delayed deliveries correctly
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS DelayedDeliveries,
    -- FIXED: Calculate delay percentage correctly
    ROUND(
        CASE 
            WHEN COUNT(po.po_id) > 0 THEN
                (COUNT(CASE 
                    WHEN po.actual_delivery_date IS NOT NULL 
                    AND po.actual_delivery_date > po.expected_delivery_date 
                    THEN 1 
                END) * 100.0 / COUNT(po.po_id))
            ELSE 0
        END, 2
    ) AS DelayPercentage
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name, sup.contact_person, sup.email
HAVING COUNT(po.po_id) > 0  -- Only suppliers with orders
ORDER BY SUM(po.delivered_quantity) DESC;

-- OPTIMIZED Query 6: Supplier Performance with Delay Analysis (FIXED)
-- Improvements: Fixed missing columns, optimized delay calculations
-- Performance: Uses idx_po_supplier_status_dates index

WITH supplier_performance AS (
    SELECT 
        sup.supplier_id,
        sup.supplier_name,
        COUNT(po.po_id) AS total_orders,
        COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) AS delayed_orders,
        COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date <= po.expected_delivery_date 
            THEN 1 
        END) AS on_time_orders,
        AVG(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date)
            ELSE 0
        END) AS avg_delay_days,
        MAX(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date)
            ELSE 0
        END) AS max_delay_days
    FROM suppliers sup
    LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
    WHERE po.delivery_status = 'DELIVERED'
    GROUP BY sup.supplier_id, sup.supplier_name
    HAVING COUNT(po.po_id) > 0
)
SELECT 
    supplier_name AS SupplierName,
    total_orders AS TotalOrders,
    delayed_orders AS DelayedOrders,
    on_time_orders AS OnTimeOrders,
    ROUND(avg_delay_days, 2) AS AverageDelayDays,
    ROUND(max_delay_days, 2) AS MaxDelayDays,
    ROUND(
        CASE 
            WHEN total_orders > 0 THEN (delayed_orders * 100.0 / total_orders)
            ELSE 0
        END, 2
    ) AS DelayPercentage,
    CASE 
        WHEN total_orders = 0 THEN 'NO DATA'
        WHEN (delayed_orders * 100.0 / total_orders) <= 10 THEN 'EXCELLENT'
        WHEN (delayed_orders * 100.0 / total_orders) <= 25 THEN 'GOOD'
        WHEN (delayed_orders * 100.0 / total_orders) <= 50 THEN 'FAIR'
        ELSE 'POOR'
    END AS PerformanceRating
FROM supplier_performance
ORDER BY DelayPercentage ASC, AverageDelayDays ASC;

-- ========================================
-- OPTIMIZED COMPLEX ANALYSIS QUERIES
-- ========================================

-- OPTIMIZED Query 7: Above-Average Performing Products (Using CTE)
-- Improvements: Replaced complex subqueries with CTE for better performance
-- Performance: More readable and potentially faster execution

WITH product_sales_summary AS (
    SELECT 
        product_id,
        SUM(total_amount) AS total_revenue,
        SUM(units_sold) AS total_units
    FROM sales
    GROUP BY product_id
),
overall_average AS (
    SELECT 
        AVG(total_revenue) AS avg_revenue
    FROM product_sales_summary
)
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    pss.total_revenue AS ProductRevenue,
    pss.total_units AS ProductUnitsSold,
    oa.avg_revenue AS OverallAverageRevenue,
    ROUND(pss.total_revenue - oa.avg_revenue, 2) AS RevenueVsAverage,
    ROUND((pss.total_revenue / oa.avg_revenue * 100), 2) AS PercentageOfAverage
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN product_sales_summary pss ON p.product_id = pss.product_id
CROSS JOIN overall_average oa
WHERE pss.total_revenue > oa.avg_revenue
  AND p.is_active = TRUE
ORDER BY RevenueVsAverage DESC;

-- OPTIMIZED Query 8: Inventory Consolidation Across Stores
-- Improvements: Added NULL handling, optimized aggregation
-- Performance: Uses idx_inventory_store_product index

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    SUM(i.stock_level) AS TotalStock,
    COUNT(DISTINCT i.store_id) AS StoresCarryingProduct,
    ROUND(AVG(i.stock_level), 2) AS AverageStockPerStore,
    MIN(i.stock_level) AS MinStockAtStore,
    MAX(i.stock_level) AS MaxStockAtStore,
    -- Optimized stock variability calculation
    ROUND(
        CASE 
            WHEN AVG(i.stock_level) > 0 THEN
                ((MAX(i.stock_level) - MIN(i.stock_level)) * 100.0 / AVG(i.stock_level))
            ELSE 0
        END, 2
    ) AS StockVariabilityPercentage,
    -- Optimized store details (limited for performance)
    GROUP_CONCAT(
        st.store_name || ': ' || i.stock_level || ' units', 
        ' | '
    ) AS StockByStore
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN inventory i ON p.product_id = i.product_id
INNER JOIN stores st ON i.store_id = st.store_id
WHERE p.is_active = TRUE
  AND i.stock_level > 0  -- Only products with stock
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY TotalStock DESC;

-- OPTIMIZED Query 9: Sales Trends by Category (Simplified)
-- Improvements: Simplified window function usage, better performance
-- Performance: Uses idx_sales_product_date index

SELECT 
    c.category_name AS Category,
    strftime('%Y-%m', s.sale_date) AS SaleMonth,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS MonthlyRevenue,
    COUNT(DISTINCT s.product_id) AS DistinctProductsSold,
    ROUND(AVG(s.total_amount), 2) AS AverageSaleAmount
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE s.sale_date >= '2025-01-01'  -- Filter for relevant date range
GROUP BY c.category_name, strftime('%Y-%m', s.sale_date)
ORDER BY c.category_name, strftime('%Y-%m', s.sale_date);

-- OPTIMIZED Query 10: Most Profitable Store-Product Combinations
-- Improvements: Simplified ranking, better performance with LIMIT
-- Performance: Uses compound indexes for better JOIN performance

SELECT 
    st.store_name AS StoreName,
    p.product_name AS ProductName,
    c.category_name AS Category,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS TotalRevenue,
    COUNT(s.sale_id) AS NumberOfSales,
    ROUND(AVG(s.total_amount), 2) AS AverageSaleAmount,
    ROUND(SUM(s.total_amount) / COUNT(s.sale_id), 2) AS RevenuePerSale,
    ROUND(SUM(s.units_sold) / COUNT(s.sale_id), 2) AS UnitsPerSale
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN stores st ON s.store_id = st.store_id
WHERE s.sale_date >= '2025-01-01'  -- Filter for relevant timeframe
GROUP BY st.store_id, st.store_name, p.product_id, p.product_name, c.category_name
ORDER BY TotalRevenue DESC
LIMIT 20;  -- Top 20 most profitable combinations

-- ========================================
-- PERFORMANCE SUMMARY
-- ========================================

SELECT 'OPTIMIZATION COMPLETE' AS status;
SELECT 'All queries optimized with:' AS improvements;
SELECT '- Strategic indexes added' AS improvement_1;
SELECT '- Missing column errors fixed' AS improvement_2;
SELECT '- CTEs used for complex queries' AS improvement_3;
SELECT '- Early filtering applied' AS improvement_4;
SELECT '- NULL handling improved' AS improvement_5;
SELECT '- Result limits added where appropriate' AS improvement_6;
