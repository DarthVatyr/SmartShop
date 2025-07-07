-- Activity 2: Quick Test Queries
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Simple test queries to verify Activity 2 setup and functionality

-- ========================================
-- DATA VERIFICATION TESTS
-- ========================================

-- Test 1: Verify all tables have data
SELECT 'Data Verification' AS test_name;
SELECT 'Sales' AS table_name, COUNT(*) AS records FROM sales
UNION ALL
SELECT 'Purchase_Orders', COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'Stores', COUNT(*) FROM stores;

-- Test 2: Sample data check
SELECT 'Sample Sales Data' AS test_name;
SELECT 
    s.sale_id,
    p.product_name,
    s.sale_date,
    s.units_sold,
    s.total_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
LIMIT 5;

-- ========================================
-- BASIC JOIN TESTS
-- ========================================

-- Test 3: Simple product-sales JOIN
SELECT 'Basic JOIN Test' AS test_name;
SELECT 
    p.product_name,
    COUNT(s.sale_id) AS sales_count,
    SUM(s.total_amount) AS total_revenue
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 5;

-- Test 4: Multi-table JOIN
SELECT 'Multi-table JOIN Test' AS test_name;
SELECT 
    p.product_name,
    c.category_name,
    st.store_name,
    s.sale_date,
    s.total_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN stores st ON s.store_id = st.store_id
ORDER BY s.total_amount DESC
LIMIT 5;

-- ========================================
-- AGGREGATE FUNCTION TESTS
-- ========================================

-- Test 5: Sales by category
SELECT 'Sales by Category Test' AS test_name;
SELECT 
    c.category_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.units_sold) AS total_units,
    SUM(s.total_amount) AS total_revenue,
    ROUND(AVG(s.total_amount), 2) AS avg_sale_amount
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC NULLS LAST;

-- Test 6: Store performance
SELECT 'Store Performance Test' AS test_name;
SELECT 
    st.store_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.total_amount) AS total_revenue,
    ROUND(AVG(s.total_amount), 2) AS avg_sale_amount,
    MAX(s.total_amount) AS largest_sale
FROM stores st
LEFT JOIN sales s ON st.store_id = s.store_id
GROUP BY st.store_id, st.store_name
ORDER BY total_revenue DESC NULLS LAST;

-- ========================================
-- SUPPLIER ANALYSIS TESTS
-- ========================================

-- Test 7: Supplier delivery performance
SELECT 'Supplier Performance Test' AS test_name;
SELECT 
    sup.supplier_name,
    COUNT(po.po_id) AS total_orders,
    SUM(po.delivered_quantity) AS total_delivered,
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date > po.expected_delivery_date 
        THEN 1 
    END) AS delayed_orders,
    COUNT(CASE 
        WHEN po.actual_delivery_date IS NOT NULL 
        AND po.actual_delivery_date <= po.expected_delivery_date 
        THEN 1 
    END) AS on_time_orders
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
ORDER BY delayed_orders ASC;

-- ========================================
-- DATE-BASED ANALYSIS TESTS
-- ========================================

-- Test 8: Sales trends by month
SELECT 'Monthly Sales Trends Test' AS test_name;
SELECT 
    strftime('%Y-%m', s.sale_date) AS sale_month,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.units_sold) AS total_units,
    SUM(s.total_amount) AS monthly_revenue
FROM sales s
GROUP BY strftime('%Y-%m', s.sale_date)
ORDER BY sale_month;

-- Test 9: Best selling products
SELECT 'Best Selling Products Test' AS test_name;
SELECT 
    p.product_name,
    c.category_name,
    SUM(s.units_sold) AS total_units_sold,
    COUNT(s.sale_id) AS number_of_sales,
    SUM(s.total_amount) AS total_revenue
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_units_sold DESC NULLS LAST
LIMIT 10;

-- ========================================
-- INVENTORY vs SALES CORRELATION
-- ========================================

-- Test 10: Products with high sales but low inventory
SELECT 'Inventory vs Sales Analysis' AS test_name;
SELECT 
    p.product_name,
    SUM(s.units_sold) AS total_sold,
    SUM(i.stock_level) AS current_stock,
    CASE 
        WHEN SUM(i.stock_level) > 0 THEN 
            ROUND(SUM(s.units_sold) * 100.0 / SUM(i.stock_level), 2)
        ELSE NULL 
    END AS sales_to_stock_ratio
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.units_sold) > 0
ORDER BY sales_to_stock_ratio DESC NULLS LAST
LIMIT 10;
