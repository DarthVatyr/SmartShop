-- Activity 2: Extended Schema for Sales and Supplier Performance Analysis
-- Author: Database Engineer
-- Date: July 6, 2025
-- Description: Additional tables to support advanced analytical queries

-- Sales table to track product sales by date and store
CREATE TABLE IF NOT EXISTS sales (
    sale_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    sale_date DATE NOT NULL,
    units_sold INTEGER NOT NULL CHECK (units_sold > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    total_amount DECIMAL(10, 2) GENERATED ALWAYS AS (units_sold * unit_price) STORED,
    sale_time TIME DEFAULT (strftime('%H:%M:%S', 'now')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Purchase Orders table to track supplier deliveries and performance
CREATE TABLE IF NOT EXISTS purchase_orders (
    po_id INTEGER PRIMARY KEY AUTOINCREMENT,
    supplier_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE,
    ordered_quantity INTEGER NOT NULL CHECK (ordered_quantity > 0),
    delivered_quantity INTEGER DEFAULT 0 CHECK (delivered_quantity >= 0),
    unit_cost DECIMAL(10, 2) NOT NULL CHECK (unit_cost > 0),
    total_cost DECIMAL(10, 2) GENERATED ALWAYS AS (delivered_quantity * unit_cost) STORED,
    delivery_status VARCHAR(20) DEFAULT 'PENDING' CHECK (delivery_status IN ('PENDING', 'DELIVERED', 'PARTIAL', 'CANCELLED')),
    -- Note: is_delayed and delay_days will be calculated in queries rather than stored columns
    -- to avoid non-deterministic function issues in SQLite
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Indexes for performance optimization
CREATE INDEX IF NOT EXISTS idx_sales_date ON sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_sales_product ON sales(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_store ON sales(store_id);
CREATE INDEX IF NOT EXISTS idx_sales_date_store ON sales(sale_date, store_id);

CREATE INDEX IF NOT EXISTS idx_po_supplier ON purchase_orders(supplier_id);
CREATE INDEX IF NOT EXISTS idx_po_product ON purchase_orders(product_id);
CREATE INDEX IF NOT EXISTS idx_po_store ON purchase_orders(store_id);
CREATE INDEX IF NOT EXISTS idx_po_delivery_date ON purchase_orders(expected_delivery_date);
CREATE INDEX IF NOT EXISTS idx_po_status ON purchase_orders(delivery_status);

-- Triggers for automated updates
CREATE TRIGGER IF NOT EXISTS update_sales_timestamp 
    AFTER UPDATE ON sales
    FOR EACH ROW
    BEGIN
        UPDATE sales SET created_at = CURRENT_TIMESTAMP WHERE sale_id = NEW.sale_id;
    END;

CREATE TRIGGER IF NOT EXISTS update_po_timestamp 
    AFTER UPDATE ON purchase_orders
    FOR EACH ROW
    BEGIN
        UPDATE purchase_orders SET created_at = CURRENT_TIMESTAMP WHERE po_id = NEW.po_id;
    END;
