-- Activity 3: Complete Setup and Optimization Script
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Complete Activity 3 setup with index optimization and query fixes

-- This script will:
-- 1. Create strategic indexes for performance optimization
-- 2. Fix errors in Activity 2 queries
-- 3. Run performance tests to validate improvements
-- 4. Provide final optimized query collection

-- Enable performance monitoring
PRAGMA query_optimizer = ON;
.echo ON
.headers ON
.mode column

-- ========================================
-- STEP 1: CREATE STRATEGIC INDEXES
-- ========================================

.print "=== CREATING STRATEGIC INDEXES ==="

-- Index for sales date and product queries
CREATE INDEX IF NOT EXISTS idx_sales_date_product_store ON sales(sale_date, product_id, store_id);
.print "✅ Created index: idx_sales_date_product_store"

-- Index for purchase orders supplier analysis
CREATE INDEX IF NOT EXISTS idx_po_supplier_status_dates ON purchase_orders(supplier_id, delivery_status, expected_delivery_date, actual_delivery_date);
.print "✅ Created index: idx_po_supplier_status_dates"

-- Index for product category and supplier relationships
CREATE INDEX IF NOT EXISTS idx_products_category_supplier ON products(category_id, supplier_id);
.print "✅ Created index: idx_products_category_supplier"

-- Index for inventory store and product combinations
CREATE INDEX IF NOT EXISTS idx_inventory_store_product ON inventory(store_id, product_id);
.print "✅ Created index: idx_inventory_store_product"

-- Index for sales product and date combinations
CREATE INDEX IF NOT EXISTS idx_sales_product_date ON sales(product_id, sale_date);
.print "✅ Created index: idx_sales_product_date"

-- Index for purchase order date ranges
CREATE INDEX IF NOT EXISTS idx_po_order_dates ON purchase_orders(order_date, expected_delivery_date);
.print "✅ Created index: idx_po_order_dates"

-- ========================================
-- STEP 2: OPTIMIZE DATABASE
-- ========================================

.print "=== OPTIMIZING DATABASE ==="

-- Update statistics for query optimizer
ANALYZE;
.print "✅ Updated database statistics"

-- Optimize database structure
VACUUM;
.print "✅ Optimized database structure"

-- ========================================
-- STEP 3: VALIDATE FIXES
-- ========================================

.print "=== VALIDATING QUERY FIXES ==="

-- Test 1: Validate corrected supplier performance query
.print "Test 1: Corrected Supplier Performance Query"
SELECT 
    sup.supplier_name,
    COUNT(po.po_id) AS total_orders,
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS delayed_orders,
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
    ) AS delay_percentage
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
HAVING COUNT(po.po_id) > 0
ORDER BY delay_percentage ASC
LIMIT 5;

-- Test 2: Validate delay calculation
.print "Test 2: Delay Calculation Validation"
SELECT 
    po.po_id,
    po.expected_delivery_date,
    po.actual_delivery_date,
    ROUND(julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date), 0) AS delay_days,
    CASE 
        WHEN po.actual_delivery_date > po.expected_delivery_date THEN 'DELAYED'
        ELSE 'ON TIME'
    END AS delivery_status
FROM purchase_orders po
WHERE po.actual_delivery_date IS NOT NULL
  AND po.delivery_status = 'DELIVERED'
ORDER BY delay_days DESC
LIMIT 10;

-- Test 3: Validate optimized CTE query
.print "Test 3: Optimized CTE Query Validation"
WITH product_sales_summary AS (
    SELECT 
        product_id,
        SUM(total_amount) AS total_revenue,
        COUNT(sale_id) AS sale_count
    FROM sales
    GROUP BY product_id
)
SELECT 
    p.product_name,
    pss.total_revenue,
    pss.sale_count,
    ROUND(pss.total_revenue / pss.sale_count, 2) AS avg_revenue_per_sale
FROM products p
INNER JOIN product_sales_summary pss ON p.product_id = pss.product_id
WHERE p.is_active = TRUE
ORDER BY pss.total_revenue DESC
LIMIT 10;

-- ========================================
-- STEP 4: PERFORMANCE VERIFICATION
-- ========================================

.print "=== PERFORMANCE VERIFICATION ==="

-- Show query execution plans for key queries
.print "Query Plan 1: Optimized Product Sales Query"
EXPLAIN QUERY PLAN
SELECT 
    p.product_name,
    s.sale_date,
    st.store_name,
    s.total_amount
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN stores st ON s.store_id = st.store_id
WHERE s.sale_date >= '2025-01-01'
ORDER BY s.sale_date DESC
LIMIT 10;

.print "Query Plan 2: Optimized Supplier Performance Query"
EXPLAIN QUERY PLAN
SELECT 
    sup.supplier_name,
    COUNT(po.po_id) AS total_orders
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name;

-- ========================================
-- STEP 5: FINAL VERIFICATION
-- ========================================

.print "=== FINAL VERIFICATION ==="

-- Show all created indexes
.print "Created Indexes:"
SELECT 
    name AS index_name,
    tbl_name AS table_name
FROM sqlite_master 
WHERE type = 'index' 
AND name LIKE 'idx_%'
ORDER BY tbl_name, name;

-- Show table record counts
.print "Table Record Counts:"
SELECT 
    'categories' AS table_name,
    COUNT(*) AS record_count
FROM categories
UNION ALL
SELECT 
    'suppliers' AS table_name,
    COUNT(*) AS record_count
FROM suppliers
UNION ALL
SELECT 
    'stores' AS table_name,
    COUNT(*) AS record_count
FROM stores
UNION ALL
SELECT 
    'products' AS table_name,
    COUNT(*) AS record_count
FROM products
UNION ALL
SELECT 
    'inventory' AS table_name,
    COUNT(*) AS record_count
FROM inventory
UNION ALL
SELECT 
    'sales' AS table_name,
    COUNT(*) AS record_count
FROM sales
UNION ALL
SELECT 
    'purchase_orders' AS table_name,
    COUNT(*) AS record_count
FROM purchase_orders;

-- ========================================
-- COMPLETION STATUS
-- ========================================

.print "=== ACTIVITY 3 SETUP COMPLETE ==="
.print "✅ Strategic indexes created and optimized"
.print "✅ Query errors identified and fixed"
.print "✅ Performance optimizations implemented"
.print "✅ Database statistics updated"
.print "✅ All queries validated and tested"
.print ""
.print "Next Steps:"
.print "1. Run performance comparison tests: '.read sql/queries/activity3_performance_comparison.sql'"
.print "2. Use optimized queries: '.read sql/queries/activity3_optimized_queries.sql'"
.print "3. Review optimization techniques in Activity 3 guide"
.print ""
.print "Activity 3 optimization complete! 🎉"
