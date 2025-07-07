-- Activity 3: Performance Analysis and Issue Identification
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Analyze Activity 2 queries for performance issues and errors

-- Enable performance analysis
PRAGMA query_optimizer = ON;
.timer ON
.eqp ON
.headers ON
.mode column

-- ========================================
-- ISSUE IDENTIFICATION ANALYSIS
-- ========================================

-- Check 1: Identify queries that reference non-existent columns
-- Problem: Activity 2 queries reference is_delayed and delay_days columns that don't exist
SELECT 'SCHEMA ANALYSIS' AS analysis_type;
.schema purchase_orders

-- Check 2: Look for missing indexes on frequently joined columns
SELECT 'INDEX ANALYSIS' AS analysis_type;
.indexes

-- Check 3: Analyze table sizes to understand performance impact
SELECT 'TABLE SIZE ANALYSIS' AS analysis_type;
SELECT 
    'sales' AS table_name,
    COUNT(*) AS record_count,
    'High JOIN frequency' AS usage_pattern
FROM sales
UNION ALL
SELECT 
    'purchase_orders' AS table_name,
    COUNT(*) AS record_count,
    'Complex aggregations' AS usage_pattern
FROM purchase_orders
UNION ALL
SELECT 
    'products' AS table_name,
    COUNT(*) AS record_count,
    'Central to most JOINs' AS usage_pattern
FROM products;

-- ========================================
-- PERFORMANCE BASELINE TESTS
-- ========================================

-- Test 1: Basic JOIN performance (Query 1 from Activity 2)
SELECT 'BASELINE TEST 1: Simple Product Sales JOIN' AS test_name;
.timer ON
EXPLAIN QUERY PLAN
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

-- Test 2: Complex multi-table JOIN (Query 2 from Activity 2)
SELECT 'BASELINE TEST 2: Complex Multi-table JOIN' AS test_name;
.timer ON
EXPLAIN QUERY PLAN
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

-- Test 3: Aggregation with GROUP BY (Query 4 from Activity 2)
SELECT 'BASELINE TEST 3: Aggregation Performance' AS test_name;
.timer ON
EXPLAIN QUERY PLAN
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

-- ========================================
-- IDENTIFIED ISSUES FROM ACTIVITY 2
-- ========================================

-- Issue 1: Missing columns in purchase_orders table
SELECT 'ISSUE 1: Missing columns in purchase_orders' AS issue_type;
-- The queries reference is_delayed and delay_days columns that don't exist
-- These need to be calculated in the queries or added to the schema

-- Issue 2: Inefficient supplier performance query
SELECT 'ISSUE 2: Inefficient supplier performance calculation' AS issue_type;
-- Original Query 5 and 6 try to use non-existent columns
-- Need to calculate delays dynamically

-- Issue 3: Complex subquery in Query 7
SELECT 'ISSUE 3: Complex nested subqueries' AS issue_type;
-- The above-average performance query uses multiple subqueries
-- Could potentially be optimized with CTEs

-- Issue 4: Missing indexes for common query patterns
SELECT 'ISSUE 4: Missing strategic indexes' AS issue_type;
-- Common JOIN patterns not optimized with compound indexes

-- ========================================
-- PERFORMANCE RECOMMENDATIONS
-- ========================================

SELECT 'PERFORMANCE RECOMMENDATIONS' AS recommendation_type;
SELECT 
    'Add compound indexes' AS recommendation,
    'CREATE INDEX idx_sales_date_product ON sales(sale_date, product_id)' AS implementation;

SELECT 
    'Fix missing column references' AS recommendation,
    'Calculate delay fields dynamically in queries' AS implementation;

SELECT 
    'Optimize complex subqueries' AS recommendation,
    'Use CTEs for better readability and potential performance' AS implementation;

SELECT 
    'Add missing indexes for JOINs' AS recommendation,
    'CREATE INDEX idx_products_category_supplier ON products(category_id, supplier_id)' AS implementation;
