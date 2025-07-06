-- Database Setup Script for SmartShop Inventory System
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Complete setup script to create and populate the database

-- This script will:
-- 1. Create all tables with proper relationships
-- 2. Insert sample data
-- 3. Create indexes for performance
-- 4. Set up triggers for automated tasks

-- Enable foreign key constraints (SQLite specific)
PRAGMA foreign_keys = ON;

-- Show execution progress
.echo ON
.headers ON
.mode column

-- Create the database schema
.read sql/schema/smartshop_schema.sql

-- Insert sample data
.read sql/sample-data/sample_data.sql

-- Verify the setup
SELECT 'Database setup completed successfully!' AS Status;

-- Show summary statistics
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
    'Stock_Movements' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM stock_movements;
