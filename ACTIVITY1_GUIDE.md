# Activity 1: Basic SQL Queries - Step-by-Step Guide

## 🎯 Activity Overview

In this activity, you'll use GitHub Copilot to create and execute basic SQL queries for the SmartShop Inventory System. You'll learn to:

1. Retrieve product details
2. Filter products by category and availability
3. Sort data for better readability
4. Use Copilot to generate and optimize queries

## 📋 Prerequisites

- [x] VS Code with SQLTools extensions installed
- [x] SmartShop database schema created
- [x] Sample data loaded

## 🚀 Step-by-Step Instructions

### Step 1: Set Up Your Database Connection

1. Open VS Code in your SmartShop project
2. Press `Ctrl+Shift+P` to open the Command Palette
3. Type "SQLTools: Add New Connection"
4. Select "SQLite"
5. Configure the connection:
   - **Name**: SmartShop Inventory
   - **Database File**: `./database/smartshop.db`
6. Click "Connect Now"

### Step 2: Initialize the Database

1. Open a new terminal in VS Code (`Ctrl+Shift+``)
2. Run the database setup:
   ```bash
   sqlite3 database/smartshop.db ".read database/setup_database.sql"
   ```
3. Verify the setup by checking table counts

### Step 3: Execute Basic Queries

Open the file `sql/queries/activity1_basic_queries.sql` and work through each query:

#### Query 1: Product Details
```sql
-- Retrieve ProductName, Category, Price, and StockLevel
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
```

**Expected Results**: List of all products with their category, price, and total stock across all stores.

#### Query 2: Filter by Category
```sql
-- Filter products in Electronics category
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
```

**Expected Results**: Only electronics products with their details.

#### Query 3: Low Stock Products
```sql
-- Find products with stock below minimum levels
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
```

**Expected Results**: Products that need restocking, sorted by urgency.

#### Query 4: Sort by Price (Ascending)
```sql
-- Display products sorted by price (low to high)
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
```

**Expected Results**: All products sorted from cheapest to most expensive.

### Step 4: Using Copilot for Query Enhancement

1. **Practice with Copilot**: 
   - Type comments describing what you want to query
   - Let Copilot suggest the SQL code
   - Review and modify the suggestions

2. **Example Copilot Prompts**:
   ```sql
   -- Find all products in the 'Clothing' category with price greater than $50
   
   -- Show products with stock level between 10 and 50 units
   
   -- Get the top 5 most expensive products with their suppliers
   ```

### Step 5: Verify Your Results

Run each query and verify:
- ✅ Product details are displayed correctly
- ✅ Category filtering works as expected
- ✅ Low stock alerts identify products needing restock
- ✅ Price sorting arranges products correctly
- ✅ All queries execute without errors

## 🔍 Expected Outcomes

By the end of Activity 1, you should have:

1. **7 working SQL queries** that retrieve and organize inventory data
2. **Understanding of JOINs** between products, categories, and inventory
3. **Experience with filtering and sorting** in SQL
4. **Practice using Copilot** to generate and refine queries
5. **Foundation queries** ready for extension in Activity 2

## 🎯 Success Criteria

- [ ] All queries execute successfully
- [ ] Results match expected data patterns
- [ ] Query logic is clear and well-commented
- [ ] Copilot was used effectively for query generation
- [ ] Files are saved in the correct directory structure

## 🔗 Next Steps

These basic queries will be extended in Activity 2 with:
- Advanced analytics and reporting
- Complex multi-table joins
- Aggregate functions and grouping
- Performance optimization techniques

## 💡 Tips for Success

1. **Test each query individually** before moving to the next
2. **Use Copilot comments** to describe your intent clearly
3. **Review query results** to ensure they make business sense
4. **Save your work frequently** in the appropriate files
5. **Document any custom queries** you create

---

**Ready to begin?** Start with Query 1 and work through each step systematically!
