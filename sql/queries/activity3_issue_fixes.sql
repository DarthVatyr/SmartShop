-- Activity 3: Issue Detection and Resolution
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Identification and fixes for Activity 2 query issues

-- ========================================
-- CRITICAL ISSUE FIXES
-- ========================================

-- ISSUE 1: Missing columns in purchase_orders table
-- Problem: Activity 2 queries reference is_delayed and delay_days columns that don't exist
-- Solution: Calculate these values dynamically in queries

-- CORRECTED Query 5: Top-Performing Suppliers Based on Sales Volume
-- Original version had errors with non-existent columns
-- This version calculates delays dynamically

SELECT 
    sup.supplier_name AS SupplierName,
    sup.contact_person AS ContactPerson,
    sup.email AS SupplierEmail,
    COUNT(DISTINCT po.product_id) AS ProductsSupplied,
    SUM(po.delivered_quantity) AS TotalUnitsDelivered,
    SUM(po.total_cost) AS TotalPurchaseCost,
    AVG(po.unit_cost) AS AverageUnitCost,
    -- FIXED: Calculate delayed deliveries dynamically
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS DelayedDeliveries,
    -- FIXED: Calculate delay percentage dynamically
    ROUND(
        (COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) * 100.0 / COUNT(po.po_id)), 2
    ) AS DelayPercentage
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name, sup.contact_person, sup.email
ORDER BY SUM(po.delivered_quantity) DESC;

-- CORRECTED Query 6: Supplier Performance with Delay Analysis
-- Original version had errors with non-existent columns
-- This version properly calculates all delay metrics

SELECT 
    sup.supplier_name AS SupplierName,
    COUNT(po.po_id) AS TotalOrders,
    -- FIXED: Calculate delayed orders dynamically
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS DelayedOrders,
    -- FIXED: Calculate on-time orders dynamically
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date <= po.expected_delivery_date 
        THEN 1 
    END) AS OnTimeOrders,
    -- FIXED: Calculate average delay days dynamically
    ROUND(AVG(
        CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date)
            ELSE 0
        END
    ), 2) AS AverageDelayDays,
    -- FIXED: Calculate max delay days dynamically
    MAX(
        CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date)
            ELSE 0
        END
    ) AS MaxDelayDays,
    -- FIXED: Calculate delay percentage dynamically
    ROUND(
        (COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) * 100.0 / COUNT(po.po_id)), 2
    ) AS DelayPercentage,
    -- FIXED: Performance rating based on calculated delay percentage
    CASE 
        WHEN (COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) * 100.0 / COUNT(po.po_id)) <= 10 THEN 'EXCELLENT'
        WHEN (COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) * 100.0 / COUNT(po.po_id)) <= 25 THEN 'GOOD'
        WHEN (COUNT(CASE 
            WHEN po.actual_delivery_date IS NOT NULL 
            AND po.actual_delivery_date > po.expected_delivery_date 
            THEN 1 
        END) * 100.0 / COUNT(po.po_id)) <= 50 THEN 'FAIR'
        ELSE 'POOR'
    END AS PerformanceRating
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
ORDER BY DelayPercentage ASC, AverageDelayDays ASC;

-- ========================================
-- PERFORMANCE ISSUE IDENTIFICATION
-- ========================================

-- ISSUE 2: Inefficient WHERE clause placement
-- Problem: WHERE clause after LEFT JOIN can cause issues
-- Solution: Use proper JOIN conditions and filters

-- ISSUE 3: Missing indexes for common query patterns
-- Problem: Full table scans on frequently joined columns
-- Solution: Add strategic indexes (implemented in separate file)

-- ISSUE 4: Complex subqueries in Query 7
-- Problem: Multiple nested subqueries can be inefficient
-- Solution: Use CTEs for better performance and readability (optimized version coming)

-- ========================================
-- VALIDATION TESTS
-- ========================================

-- Test the corrected supplier performance query
SELECT 'VALIDATION: Corrected Supplier Performance Query' AS test_name;
-- This should now work without errors
SELECT 
    sup.supplier_name,
    COUNT(po.po_id) AS total_orders,
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS delayed_orders
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
LIMIT 5;

-- Test delay calculation
SELECT 'VALIDATION: Delay Calculation Test' AS test_name;
SELECT 
    po.po_id,
    po.expected_delivery_date,
    po.actual_delivery_date,
    julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date) AS delay_days,
    CASE 
        WHEN po.actual_delivery_date > po.expected_delivery_date THEN 'DELAYED'
        ELSE 'ON TIME'
    END AS delivery_status
FROM purchase_orders po
WHERE po.actual_delivery_date IS NOT NULL
LIMIT 10;
