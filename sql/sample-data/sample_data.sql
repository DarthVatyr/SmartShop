-- Sample Data for SmartShop Inventory System
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Sample data for testing and development

-- Insert Categories
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Apparel and fashion items'),
('Home & Garden', 'Home improvement and gardening supplies'),
('Sports & Outdoors', 'Sports equipment and outdoor gear'),
('Books', 'Books and educational materials'),
('Health & Beauty', 'Personal care and health products'),
('Toys & Games', 'Children toys and games'),
('Automotive', 'Car parts and accessories');

-- Insert Suppliers
INSERT INTO suppliers (supplier_name, contact_person, email, phone, address, city, state, zip_code) VALUES
('TechCorp Solutions', 'John Smith', 'john.smith@techcorp.com', '555-0101', '123 Tech Ave', 'San Jose', 'CA', '95110'),
('Fashion Forward Inc', 'Sarah Johnson', 'sarah.j@fashionforward.com', '555-0102', '456 Style Blvd', 'New York', 'NY', '10001'),
('Home & Garden Supply Co', 'Mike Brown', 'mike.brown@homegardenco.com', '555-0103', '789 Garden Lane', 'Portland', 'OR', '97201'),
('Sports Excellence', 'Lisa Davis', 'lisa.davis@sportsexcellence.com', '555-0104', '321 Athletic St', 'Denver', 'CO', '80202'),
('BookWorld Publishers', 'David Wilson', 'david.wilson@bookworld.com', '555-0105', '654 Literature Ave', 'Chicago', 'IL', '60601'),
('Beauty Plus', 'Emma Garcia', 'emma.garcia@beautyplus.com', '555-0106', '987 Cosmetic Dr', 'Los Angeles', 'CA', '90210');

-- Insert Stores
INSERT INTO stores (store_name, store_code, manager_name, phone, address, city, state, zip_code) VALUES
('SmartShop Downtown', 'SS001', 'Robert Taylor', '555-1001', '100 Main St', 'Springfield', 'IL', '62701'),
('SmartShop Mall Plaza', 'SS002', 'Jennifer Anderson', '555-1002', '200 Mall Way', 'Springfield', 'IL', '62702'),
('SmartShop Westside', 'SS003', 'Michael Clark', '555-1003', '300 West Ave', 'Springfield', 'IL', '62703'),
('SmartShop Eastpoint', 'SS004', 'Jessica Martinez', '555-1004', '400 East Blvd', 'Springfield', 'IL', '62704');

-- Insert Products
INSERT INTO products (product_name, sku, barcode, category_id, supplier_id, description, price, cost, min_stock_level, max_stock_level) VALUES
-- Electronics
('Wireless Bluetooth Headphones', 'ELE001', '1234567890123', 1, 1, 'Premium wireless headphones with noise cancellation', 129.99, 65.00, 10, 100),
('Smartphone Case', 'ELE002', '1234567890124', 1, 1, 'Protective case for smartphones', 24.99, 12.50, 20, 200),
('Portable Power Bank', 'ELE003', '1234567890125', 1, 1, '10000mAh portable charger', 49.99, 25.00, 15, 150),
('Smart Watch', 'ELE004', '1234567890126', 1, 1, 'Fitness tracking smartwatch', 199.99, 100.00, 8, 80),

-- Clothing
('Cotton T-Shirt', 'CLO001', '2234567890123', 2, 2, 'Comfortable cotton t-shirt', 19.99, 10.00, 50, 500),
('Denim Jeans', 'CLO002', '2234567890124', 2, 2, 'Classic blue denim jeans', 59.99, 30.00, 30, 300),
('Winter Jacket', 'CLO003', '2234567890125', 2, 2, 'Warm winter jacket', 89.99, 45.00, 20, 200),
('Running Shoes', 'CLO004', '2234567890126', 2, 2, 'Comfortable running shoes', 79.99, 40.00, 25, 250),

-- Home & Garden
('Garden Hose', 'HG001', '3234567890123', 3, 3, '50ft flexible garden hose', 34.99, 17.50, 15, 150),
('Plant Fertilizer', 'HG002', '3234567890124', 3, 3, 'All-purpose plant fertilizer', 12.99, 6.50, 40, 400),
('LED Light Bulb', 'HG003', '3234567890125', 3, 3, 'Energy efficient LED bulb', 8.99, 4.50, 60, 600),
('Tool Set', 'HG004', '3234567890126', 3, 3, 'Basic home repair tool set', 49.99, 25.00, 20, 200),

-- Sports & Outdoors
('Tennis Racket', 'SPO001', '4234567890123', 4, 4, 'Professional tennis racket', 149.99, 75.00, 10, 100),
('Basketball', 'SPO002', '4234567890124', 4, 4, 'Official size basketball', 29.99, 15.00, 25, 250),
('Camping Tent', 'SPO003', '4234567890125', 4, 4, '4-person camping tent', 199.99, 100.00, 8, 80),
('Yoga Mat', 'SPO004', '4234567890126', 4, 4, 'Non-slip yoga mat', 24.99, 12.50, 30, 300),

-- Books
('Programming Guide', 'BOO001', '5234567890123', 5, 5, 'Complete programming guide', 39.99, 20.00, 20, 200),
('Fiction Novel', 'BOO002', '5234567890124', 5, 5, 'Bestselling fiction novel', 14.99, 7.50, 50, 500),
('Cookbook', 'BOO003', '5234567890125', 5, 5, 'Healthy cooking recipes', 24.99, 12.50, 25, 250),

-- Health & Beauty
('Shampoo', 'HB001', '6234567890123', 6, 6, 'Moisturizing shampoo', 9.99, 5.00, 40, 400),
('Face Cream', 'HB002', '6234567890124', 6, 6, 'Anti-aging face cream', 29.99, 15.00, 25, 250),
('Vitamin Supplements', 'HB003', '6234567890125', 6, 6, 'Daily vitamin supplements', 19.99, 10.00, 30, 300);

-- Insert Initial Inventory for each store
INSERT INTO inventory (product_id, store_id, stock_level, reserved_stock) VALUES
-- Store 1 (Downtown)
(1, 1, 45, 5), (2, 1, 120, 10), (3, 1, 80, 5), (4, 1, 35, 3),
(5, 1, 200, 20), (6, 1, 150, 15), (7, 1, 75, 8), (8, 1, 90, 10),
(9, 1, 60, 5), (10, 1, 180, 20), (11, 1, 250, 25), (12, 1, 85, 10),
(13, 1, 42, 4), (14, 1, 95, 8), (15, 1, 32, 3), (16, 1, 120, 12),
(17, 1, 85, 8), (18, 1, 220, 22), (19, 1, 110, 10), (20, 1, 160, 15),
(21, 1, 95, 8), (22, 1, 180, 18);

-- Store 2 (Mall Plaza)
INSERT INTO inventory (product_id, store_id, stock_level, reserved_stock) VALUES
(1, 2, 38, 3), (2, 2, 95, 8), (3, 2, 65, 4), (4, 2, 28, 2),
(5, 2, 180, 18), (6, 2, 125, 12), (7, 2, 62, 6), (8, 2, 75, 8),
(9, 2, 48, 4), (10, 2, 155, 15), (11, 2, 200, 20), (12, 2, 72, 8),
(13, 2, 35, 3), (14, 2, 82, 7), (15, 2, 28, 2), (16, 2, 105, 10),
(17, 2, 72, 7), (18, 2, 195, 19), (19, 2, 95, 9), (20, 2, 140, 14),
(21, 2, 82, 8), (22, 2, 155, 15);

-- Store 3 (Westside)
INSERT INTO inventory (product_id, store_id, stock_level, reserved_stock) VALUES
(1, 3, 52, 4), (2, 3, 140, 12), (3, 3, 95, 6), (4, 3, 42, 4),
(5, 3, 240, 24), (6, 3, 175, 18), (7, 3, 88, 9), (8, 3, 105, 11),
(9, 3, 72, 6), (10, 3, 210, 21), (11, 3, 295, 30), (12, 3, 98, 10),
(13, 3, 48, 4), (14, 3, 110, 10), (15, 3, 38, 3), (16, 3, 135, 13),
(17, 3, 95, 9), (18, 3, 245, 25), (19, 3, 125, 12), (20, 3, 185, 18),
(21, 3, 110, 10), (22, 3, 205, 20);

-- Store 4 (Eastpoint)
INSERT INTO inventory (product_id, store_id, stock_level, reserved_stock) VALUES
(1, 4, 25, 2), (2, 4, 65, 5), (3, 4, 42, 3), (4, 4, 18, 1),
(5, 4, 145, 14), (6, 4, 95, 9), (7, 4, 48, 4), (8, 4, 62, 6),
(9, 4, 35, 3), (10, 4, 125, 12), (11, 4, 185, 18), (12, 4, 58, 5),
(13, 4, 28, 2), (14, 4, 68, 6), (15, 4, 22, 2), (16, 4, 85, 8),
(17, 4, 62, 6), (18, 4, 165, 16), (19, 4, 82, 8), (20, 4, 125, 12),
(21, 4, 75, 7), (22, 4, 138, 13);

-- Insert some stock movements for audit trail
INSERT INTO stock_movements (product_id, store_id, movement_type, quantity, reference_number, notes, created_by) VALUES
(1, 1, 'IN', 50, 'PO-001', 'Initial stock delivery', 'System'),
(2, 1, 'IN', 130, 'PO-002', 'Initial stock delivery', 'System'),
(3, 1, 'IN', 85, 'PO-003', 'Initial stock delivery', 'System'),
(1, 2, 'IN', 41, 'PO-004', 'Initial stock delivery', 'System'),
(2, 2, 'IN', 103, 'PO-005', 'Initial stock delivery', 'System'),
(5, 1, 'OUT', 20, 'SO-001', 'Sales order fulfillment', 'Staff'),
(6, 1, 'OUT', 15, 'SO-002', 'Sales order fulfillment', 'Staff'),
(1, 3, 'TRANSFER', 5, 'TF-001', 'Transfer from store 1', 'Manager'),
(1, 1, 'TRANSFER', -5, 'TF-001', 'Transfer to store 3', 'Manager');
