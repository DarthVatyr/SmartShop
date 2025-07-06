-- Quick Query Runner for Terminal
-- Copy and paste these queries one at a time in your SQLite session
-- First run: sqlite3 database/smartshop.db
-- Then run: .headers on
-- Then run: .mode column

-- QUERY 1: Product Details
-- Copy from here to semicolon and paste in SQLite prompt
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price
ORDER BY p.product_name;

-- QUERY 2: Electronics Only
-- Copy from here to semicolon and paste in SQLite prompt
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE 
    AND c.category_name = 'Electronics'
GROUP BY p.product_id, p.product_name, c.category_name, p.price
ORDER BY p.product_name;

-- QUERY 3: Low Stock Products
-- Copy from here to semicolon and paste in SQLite prompt
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS CurrentStock,
    p.min_stock_level AS MinStockLevel
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.min_stock_level
HAVING COALESCE(SUM(i.stock_level), 0) < p.min_stock_level
ORDER BY (p.min_stock_level - COALESCE(SUM(i.stock_level), 0)) DESC;

-- QUERY 4: Products by Price (Ascending)
-- Copy from here to semicolon and paste in SQLite prompt
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price
ORDER BY p.price ASC;

-- QUERY 5: Stock Summary by Category
-- Copy from here to semicolon and paste in SQLite prompt
SELECT 
    c.category_name AS Category,
    COUNT(DISTINCT p.product_id) AS ProductCount,
    COALESCE(SUM(i.stock_level), 0) AS TotalStock,
    ROUND(AVG(p.price), 2) AS AveragePrice
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id AND p.is_active = TRUE
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY c.category_id, c.category_name
ORDER BY TotalStock DESC;
