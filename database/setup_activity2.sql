-- Activity 2 Database Setup Script
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Setup script to extend the database with sales and purchase order tables

-- This script will:
-- 1. Add new tables for sales tracking and supplier performance
-- 2. Insert sample data for testing advanced queries
-- 3. Create additional indexes for performance
-- 4. Set up triggers for data integrity

-- Enable foreign key constraints (SQLite specific)
PRAGMA foreign_keys = ON;

-- Show execution progress
.echo ON
.headers ON
.mode column

-- Create extended schema for Activity 2
.read sql/schema/activity2_extended_schema.sql

-- Insert sample data for Activity 2
.read sql/sample-data/activity2_sample_data.sql

-- Verify the setup
SELECT 'Activity 2 setup completed successfully!' AS Status;

-- Show updated table counts
SELECT 
    'Categories' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM categories
UNION ALL
SELECT 
    'Suppliers' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM suppliers
UNION ALL
SELECT 
    'Stores' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM stores
UNION ALL
SELECT 
    'Products' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM products
UNION ALL
SELECT 
    'Inventory' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM inventory
UNION ALL
SELECT 
    'Sales' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM sales
UNION ALL
SELECT 
    'Purchase_Orders' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM purchase_orders;
