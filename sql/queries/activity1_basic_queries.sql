-- Activity 1: Basic SQL Queries for SmartShop Inventory System
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Basic queries to retrieve product details, filter by category, and sort by price

-- ========================================
-- Query 1: Retrieve Product Details
-- ========================================
-- This query retrieves basic product information including ProductName, Category, Price, and StockLevel
-- Uses JOIN to get category name and SUM to calculate total stock across all stores

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

-- ========================================
-- Query 2: Filter Products by Specific Category
-- ========================================
-- This query filters products to show only those in a specific category (Electronics)
-- Replace 'Electronics' with any category name you want to filter by

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel,
    p.description AS Description
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE 
    AND c.category_name = 'Electronics'
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.description
ORDER BY p.product_name;

-- ========================================
-- Query 3: Filter Products with Low Stock Levels
-- ========================================
-- This query identifies products with stock levels below the minimum threshold
-- Useful for inventory management and reordering decisions
-- NOTE: Smart Watch min_stock_level set to 200 to demonstrate low stock scenario

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS CurrentStock,
    p.min_stock_level AS MinStockLevel,
    (p.min_stock_level - COALESCE(SUM(i.stock_level), 0)) AS StockDeficit
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.min_stock_level
HAVING COALESCE(SUM(i.stock_level), 0) < p.min_stock_level
ORDER BY StockDeficit DESC;

-- ========================================
-- Query 4: Products Sorted by Price (Ascending)
-- ========================================
-- This query displays all products sorted by price from lowest to highest
-- Includes stock level information for inventory management

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel,
    p.sku AS SKU
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.sku
ORDER BY p.price ASC;

-- ========================================
-- Query 5: Products Sorted by Price (Descending)
-- ========================================
-- This query displays all products sorted by price from highest to lowest
-- Useful for identifying premium products

SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    p.price AS Price,
    COALESCE(SUM(i.stock_level), 0) AS StockLevel,
    p.sku AS SKU
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.sku
ORDER BY p.price DESC;

-- ========================================
-- Query 6: Combined Filter - Electronics with Low Stock, Sorted by Price
-- ========================================
-- This query combines category filtering, low stock filtering, and price sorting
-- Demonstrates how to use multiple WHERE conditions and ORDER BY
-- NOTE: Should show Smart Watch since it's Electronics category with low stock

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
    AND c.category_name = 'Electronics'
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.min_stock_level
HAVING COALESCE(SUM(i.stock_level), 0) < p.min_stock_level
ORDER BY p.price ASC;

-- ========================================
-- Query 7: Stock Level Summary by Category
-- ========================================
-- This query provides a summary of stock levels by category
-- Useful for high-level inventory overview

SELECT 
    c.category_name AS Category,
    COUNT(DISTINCT p.product_id) AS ProductCount,
    COALESCE(SUM(i.stock_level), 0) AS TotalStock,
    ROUND(AVG(p.price), 2) AS AveragePrice,
    MIN(p.price) AS MinPrice,
    MAX(p.price) AS MaxPrice
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id AND p.is_active = TRUE
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY c.category_id, c.category_name
ORDER BY TotalStock DESC;
