-- Activity 2: Sample Data for Sales and Supplier Performance Analysis
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Sample data for testing advanced analytical queries

-- Insert sample sales data
INSERT INTO sales (product_id, store_id, sale_date, units_sold, unit_price) VALUES
-- Electronics sales
(1, 1, '2025-01-15', 2, 129.99), -- Wireless Headphones
(1, 2, '2025-01-16', 1, 129.99),
(1, 3, '2025-01-17', 3, 129.99),
(2, 1, '2025-01-15', 5, 24.99), -- Smartphone Case
(2, 2, '2025-01-16', 3, 24.99),
(2, 4, '2025-01-18', 4, 24.99),
(3, 1, '2025-01-20', 2, 49.99), -- Power Bank
(3, 3, '2025-01-21', 1, 49.99),
(4, 2, '2025-01-22', 1, 199.99), -- Smart Watch

-- Clothing sales
(5, 1, '2025-01-15', 10, 19.99), -- Cotton T-Shirt
(5, 2, '2025-01-16', 8, 19.99),
(5, 3, '2025-01-17', 12, 19.99),
(5, 4, '2025-01-18', 6, 19.99),
(6, 1, '2025-01-20', 4, 59.99), -- Denim Jeans
(6, 2, '2025-01-21', 3, 59.99),
(6, 3, '2025-01-22', 5, 59.99),
(7, 1, '2025-01-25', 2, 89.99), -- Winter Jacket
(7, 2, '2025-01-26', 1, 89.99),
(8, 3, '2025-01-27', 3, 79.99), -- Running Shoes

-- Home & Garden sales
(9, 1, '2025-01-28', 3, 34.99), -- Garden Hose
(9, 2, '2025-01-29', 2, 34.99),
(10, 1, '2025-01-30', 8, 12.99), -- Plant Fertilizer
(10, 3, '2025-01-31', 6, 12.99),
(11, 1, '2025-02-01', 15, 8.99), -- LED Light Bulb
(11, 2, '2025-02-02', 12, 8.99),
(11, 4, '2025-02-03', 10, 8.99),
(12, 2, '2025-02-04', 4, 49.99), -- Tool Set

-- Sports & Outdoors sales
(13, 1, '2025-02-05', 1, 149.99), -- Tennis Racket
(13, 3, '2025-02-06', 2, 149.99),
(14, 1, '2025-02-07', 6, 29.99), -- Basketball
(14, 2, '2025-02-08', 4, 29.99),
(15, 2, '2025-02-09', 1, 199.99), -- Camping Tent
(16, 1, '2025-02-10', 5, 24.99), -- Yoga Mat
(16, 3, '2025-02-11', 3, 24.99),

-- Books sales
(17, 1, '2025-02-12', 3, 39.99), -- Programming Guide
(17, 2, '2025-02-13', 2, 39.99),
(18, 1, '2025-02-14', 8, 14.99), -- Fiction Novel
(18, 3, '2025-02-15', 6, 14.99),
(19, 2, '2025-02-16', 4, 24.99), -- Cookbook

-- Health & Beauty sales
(20, 1, '2025-02-17', 12, 9.99), -- Shampoo
(20, 2, '2025-02-18', 10, 9.99),
(20, 4, '2025-02-19', 8, 9.99),
(21, 1, '2025-02-20', 6, 29.99), -- Face Cream
(21, 3, '2025-02-21', 4, 29.99),
(22, 1, '2025-02-22', 8, 19.99), -- Vitamin Supplements
(22, 2, '2025-02-23', 5, 19.99);

-- Insert sample purchase orders
INSERT INTO purchase_orders (supplier_id, product_id, store_id, order_date, expected_delivery_date, actual_delivery_date, ordered_quantity, delivered_quantity, unit_cost, delivery_status) VALUES
-- TechCorp Solutions orders
(1, 1, 1, '2025-01-01', '2025-01-10', '2025-01-12', 50, 50, 65.00, 'DELIVERED'), -- Delayed by 2 days
(1, 2, 1, '2025-01-05', '2025-01-15', '2025-01-15', 100, 100, 12.50, 'DELIVERED'), -- On time
(1, 3, 2, '2025-01-08', '2025-01-18', '2025-01-20', 75, 75, 25.00, 'DELIVERED'), -- Delayed by 2 days
(1, 4, 1, '2025-01-10', '2025-01-20', '2025-01-25', 30, 30, 100.00, 'DELIVERED'), -- Delayed by 5 days

-- Fashion Forward Inc orders
(2, 5, 1, '2025-01-03', '2025-01-13', '2025-01-13', 200, 200, 10.00, 'DELIVERED'), -- On time
(2, 6, 2, '2025-01-07', '2025-01-17', '2025-01-16', 150, 150, 30.00, 'DELIVERED'), -- 1 day early
(2, 7, 3, '2025-01-12', '2025-01-22', '2025-01-28', 100, 100, 45.00, 'DELIVERED'), -- Delayed by 6 days
(2, 8, 1, '2025-01-15', '2025-01-25', '2025-01-25', 120, 120, 40.00, 'DELIVERED'), -- On time

-- Home & Garden Supply Co orders
(3, 9, 1, '2025-01-02', '2025-01-12', '2025-01-15', 80, 80, 17.50, 'DELIVERED'), -- Delayed by 3 days
(3, 10, 2, '2025-01-06', '2025-01-16', '2025-01-16', 200, 200, 6.50, 'DELIVERED'), -- On time
(3, 11, 3, '2025-01-09', '2025-01-19', '2025-01-18', 300, 300, 4.50, 'DELIVERED'), -- 1 day early
(3, 12, 1, '2025-01-11', '2025-01-21', '2025-01-26', 100, 100, 25.00, 'DELIVERED'), -- Delayed by 5 days

-- Sports Excellence orders
(4, 13, 1, '2025-01-04', '2025-01-14', '2025-01-14', 50, 50, 75.00, 'DELIVERED'), -- On time
(4, 14, 2, '2025-01-08', '2025-01-18', '2025-01-22', 120, 120, 15.00, 'DELIVERED'), -- Delayed by 4 days
(4, 15, 3, '2025-01-13', '2025-01-23', '2025-01-30', 40, 40, 100.00, 'DELIVERED'), -- Delayed by 7 days
(4, 16, 1, '2025-01-16', '2025-01-26', '2025-01-24', 150, 150, 12.50, 'DELIVERED'), -- 2 days early

-- BookWorld Publishers orders
(5, 17, 1, '2025-01-05', '2025-01-15', '2025-01-15', 100, 100, 20.00, 'DELIVERED'), -- On time
(5, 18, 2, '2025-01-09', '2025-01-19', '2025-01-21', 250, 250, 7.50, 'DELIVERED'), -- Delayed by 2 days
(5, 19, 3, '2025-01-14', '2025-01-24', '2025-01-24', 120, 120, 12.50, 'DELIVERED'), -- On time

-- Beauty Plus orders
(6, 20, 1, '2025-01-06', '2025-01-16', '2025-01-20', 200, 200, 5.00, 'DELIVERED'), -- Delayed by 4 days
(6, 21, 2, '2025-01-10', '2025-01-20', '2025-01-27', 150, 150, 15.00, 'DELIVERED'), -- Delayed by 7 days
(6, 22, 3, '2025-01-17', '2025-01-27', '2025-01-25', 180, 180, 10.00, 'DELIVERED'), -- 2 days early

-- Some pending orders for current analysis
(1, 1, 3, '2025-02-01', '2025-02-10', NULL, 60, 0, 65.00, 'PENDING'),
(2, 5, 4, '2025-02-05', '2025-02-15', NULL, 100, 0, 10.00, 'PENDING'),
(3, 11, 2, '2025-02-08', '2025-02-18', NULL, 200, 0, 4.50, 'PENDING');

-- Update inventory levels based on deliveries (this would normally be done by triggers)
-- This simulates the inventory updates from the delivered purchase orders
UPDATE inventory SET stock_level = stock_level + 50 WHERE product_id = 1 AND store_id = 1;
UPDATE inventory SET stock_level = stock_level + 100 WHERE product_id = 2 AND store_id = 1;
UPDATE inventory SET stock_level = stock_level + 75 WHERE product_id = 3 AND store_id = 2;
