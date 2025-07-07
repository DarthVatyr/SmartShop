-- Activity 3: Index Optimization and Performance Improvements
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Strategic indexes and performance optimizations for Activity 2 queries

-- ========================================
-- STRATEGIC INDEX CREATION
-- ========================================

-- Enable performance analysis
PRAGMA query_optimizer = ON;
.timer ON

-- Index 1: Compound index for sales date and product queries
-- Optimizes queries that filter by date and join with products
CREATE INDEX IF NOT EXISTS idx_sales_date_product_store ON sales(sale_date, product_id, store_id);

-- Index 2: Compound index for purchase orders supplier analysis
-- Optimizes supplier performance queries with status filtering
CREATE INDEX IF NOT EXISTS idx_po_supplier_status_dates ON purchase_orders(supplier_id, delivery_status, expected_delivery_date, actual_delivery_date);

-- Index 3: Compound index for product category and supplier relationships
-- Optimizes multi-table JOINs involving products, categories, and suppliers
CREATE INDEX IF NOT EXISTS idx_products_category_supplier ON products(category_id, supplier_id);

-- Index 4: Index for inventory store and product combinations
-- Optimizes inventory consolidation queries
CREATE INDEX IF NOT EXISTS idx_inventory_store_product ON inventory(store_id, product_id);

-- Index 5: Index for sales aggregation queries
-- Optimizes GROUP BY operations on sales data
CREATE INDEX IF NOT EXISTS idx_sales_product_date ON sales(product_id, sale_date);

-- Index 6: Index for purchase order date range queries
-- Optimizes date-based filtering and sorting
CREATE INDEX IF NOT EXISTS idx_po_order_dates ON purchase_orders(order_date, expected_delivery_date);

-- ========================================
-- PERFORMANCE MONITORING
-- ========================================

-- Show all indexes to verify creation
SELECT 'CURRENT INDEXES' AS status;
.indexes

-- Analyze index effectiveness
ANALYZE;

-- Check database statistics
SELECT 'DATABASE STATISTICS' AS status;
SELECT 
    name AS table_name,
    tbl_name AS table_type,
    sql AS creation_sql
FROM sqlite_master 
WHERE type = 'index' 
AND name LIKE 'idx_%'
ORDER BY name;

-- ========================================
-- QUERY OPTIMIZATION RECOMMENDATIONS
-- ========================================

-- Recommendation 1: Use LIMIT for large result sets
SELECT 'OPTIMIZATION: Use LIMIT for large datasets' AS recommendation;
-- Example: Add LIMIT 100 to queries that might return many rows

-- Recommendation 2: Avoid SELECT * in production queries
SELECT 'OPTIMIZATION: Specify required columns only' AS recommendation;
-- Example: SELECT specific columns instead of SELECT *

-- Recommendation 3: Use EXISTS instead of IN for subqueries
SELECT 'OPTIMIZATION: Use EXISTS for better performance' AS recommendation;
-- Example: WHERE EXISTS (subquery) instead of WHERE column IN (subquery)

-- Recommendation 4: Filter data early in the query
SELECT 'OPTIMIZATION: Apply filters early' AS recommendation;
-- Example: Move WHERE conditions to reduce dataset size before JOINs

-- Recommendation 5: Use appropriate JOIN types
SELECT 'OPTIMIZATION: Use correct JOIN types' AS recommendation;
-- Example: Use INNER JOIN when you need matching records only

-- ========================================
-- PERFORMANCE TESTING FRAMEWORK
-- ========================================

-- Create a performance testing procedure
SELECT 'PERFORMANCE TESTING FRAMEWORK' AS framework_type;

-- Test 1: Compare query performance with and without indexes
.timer ON
SELECT 'Performance Test: Sales by Product (with indexes)' AS test_name;
SELECT 
    p.product_name,
    COUNT(s.sale_id) AS sales_count,
    SUM(s.total_amount) AS total_revenue
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC NULLS LAST;

-- Test 2: Complex JOIN performance
.timer ON
SELECT 'Performance Test: Complex Multi-table JOIN (with indexes)' AS test_name;
SELECT 
    p.product_name,
    c.category_name,
    sup.supplier_name,
    COUNT(s.sale_id) AS sales_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers sup ON p.supplier_id = sup.supplier_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, c.category_name, sup.supplier_name
ORDER BY sales_count DESC NULLS LAST;

-- Test 3: Supplier performance with optimized delay calculation
.timer ON
SELECT 'Performance Test: Supplier Performance (optimized)' AS test_name;
SELECT 
    sup.supplier_name,
    COUNT(po.po_id) AS total_orders,
    COUNT(CASE 
        WHEN po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS delayed_orders
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
ORDER BY delayed_orders ASC;

-- ========================================
-- VACUUM AND OPTIMIZATION
-- ========================================

-- Optimize database after index creation
VACUUM;

-- Update statistics for query optimizer
ANALYZE;

SELECT 'INDEX OPTIMIZATION COMPLETE' AS status;
SELECT 'Database optimized with strategic indexes' AS message;
SELECT 'Run performance comparison tests to measure improvements' AS next_step;
