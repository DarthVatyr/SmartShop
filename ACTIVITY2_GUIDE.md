# Activity 2: Advanced Analytical Queries - Step-by-Step Guide

## 🎯 Activity Overview

In Activity 2, you'll create complex SQL queries using multi-table JOINs, subqueries, and aggregate functions to meet SmartShop's advanced analytical requirements:

- **Sales trend analysis** by joining product and sales data
- **Supplier performance reports** using aggregate functions
- **Consolidated inventory reporting** across multiple stores
- **Complex business intelligence** queries

## 📋 Prerequisites

- [x] Activity 1 completed
- [x] Basic database schema and data loaded
- [x] SQLite3 and VS Code ready

## 🚀 Step-by-Step Instructions

### Step 1: Extend the Database Schema

First, let's add the new tables needed for Activity 2:

1. **Run the Activity 2 setup**:
   ```bash
   sqlite3 database/smartshop.db ".read database/setup_activity2.sql"
   ```

2. **Verify new tables were created**:
   ```sql
   .tables
   ```

You should now see these additional tables:
- `sales` - Product sales by date and store
- `purchase_orders` - Supplier deliveries and performance tracking

### Step 2: Understand the New Schema

The extended schema includes:

#### Sales Table
- **Tracks**: Product sales by date, store, units sold, and pricing
- **Purpose**: Analyze sales trends and performance
- **Key Fields**: `sale_date`, `units_sold`, `unit_price`, `total_amount`

#### Purchase Orders Table
- **Tracks**: Supplier deliveries, delays, and performance metrics
- **Purpose**: Evaluate supplier reliability and costs
- **Key Fields**: `expected_delivery_date`, `actual_delivery_date`, `is_delayed`, `delay_days`

### Step 3: Execute Advanced Queries

Open `sql/queries/activity2_advanced_queries.sql` and work through these query categories:

#### Part 1: Multi-Table JOIN Queries

**Query 1: Product Sales Analysis**
```sql
-- Joins Products, Sales, and Stores tables
SELECT 
    p.product_name AS ProductName,
    s.sale_date AS SaleDate,
    st.store_name AS StoreLocation,
    s.units_sold AS UnitsSold
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN stores st ON s.store_id = st.store_id
ORDER BY s.sale_date DESC;
```

**Expected Results**: Sales data showing which products sold when and where.

**Query 2: Extended Sales with Category and Supplier**
```sql
-- Adds category and supplier information
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    sup.supplier_name AS Supplier,
    s.sale_date AS SaleDate,
    st.store_name AS StoreLocation,
    s.units_sold AS UnitsSold,
    s.total_amount AS TotalSales
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
INNER JOIN stores st ON s.store_id = st.store_id
ORDER BY s.total_amount DESC;
```

**Expected Results**: Complete sales picture with product, category, and supplier context.

#### Part 2: Aggregate Functions and Analysis

**Query 4: Total Sales for Each Product**
```sql
-- Uses SUM, COUNT, AVG aggregate functions
SELECT 
    p.product_name AS ProductName,
    c.category_name AS Category,
    COUNT(s.sale_id) AS NumberOfSales,
    SUM(s.units_sold) AS TotalUnitsSold,
    SUM(s.total_amount) AS TotalRevenue,
    AVG(s.total_amount) AS AverageSaleAmount
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY SUM(s.total_amount) DESC NULLS LAST;
```

**Expected Results**: Sales performance ranking by product.

**Query 5: Supplier Performance Analysis**
```sql
-- Analyzes supplier delivery performance
SELECT 
    sup.supplier_name AS SupplierName,
    COUNT(DISTINCT po.product_id) AS ProductsSupplied,
    SUM(po.delivered_quantity) AS TotalUnitsDelivered,
    COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) AS DelayedDeliveries,
    ROUND(
        (COUNT(CASE WHEN po.is_delayed = 1 THEN 1 END) * 100.0 / COUNT(po.po_id)), 2
    ) AS DelayPercentage
FROM suppliers sup
LEFT JOIN purchase_orders po ON sup.supplier_id = po.supplier_id
WHERE po.delivery_status = 'DELIVERED'
GROUP BY sup.supplier_id, sup.supplier_name
ORDER BY DelayPercentage ASC;
```

**Expected Results**: Supplier rankings by delivery performance.

#### Part 3: Subqueries and Complex Analysis

**Query 7: Above-Average Performing Products**
```sql
-- Uses subquery to find products performing better than average
SELECT 
    p.product_name AS ProductName,
    product_sales.total_revenue AS ProductRevenue,
    overall_avg.avg_revenue AS OverallAverageRevenue
FROM products p
INNER JOIN (
    SELECT 
        product_id,
        SUM(total_amount) AS total_revenue
    FROM sales
    GROUP BY product_id
) product_sales ON p.product_id = product_sales.product_id
CROSS JOIN (
    SELECT 
        AVG(product_totals.total_revenue) AS avg_revenue
    FROM (
        SELECT 
            product_id,
            SUM(total_amount) AS total_revenue
        FROM sales
        GROUP BY product_id
    ) product_totals
) overall_avg
WHERE product_sales.total_revenue > overall_avg.avg_revenue
ORDER BY product_sales.total_revenue DESC;
```

**Expected Results**: Products that outperform the average sales.

### Step 4: Using GitHub Copilot for Query Enhancement

1. **Practice with Copilot**:
   - Type comments describing advanced analytical needs
   - Let Copilot suggest complex queries
   - Review and modify for your specific requirements

2. **Example Copilot Prompts**:
   ```sql
   -- Find the most profitable product-store combinations
   
   -- Calculate month-over-month sales growth by category
   
   -- Identify suppliers with consistently late deliveries
   
   -- Show inventory turnover rates by product and store
   ```

### Step 5: Verify Your Results

Run each query and verify:
- ✅ Multi-table JOINs return expected combined data
- ✅ Aggregate functions provide meaningful summaries
- ✅ Subqueries filter and compare data correctly
- ✅ Date-based analysis shows trends over time
- ✅ All queries execute without errors

## 🔍 Expected Learning Outcomes

By the end of Activity 2, you should have:

1. **Advanced JOIN expertise** - Multi-table relationships and complex data combinations
2. **Aggregate function mastery** - SUM, COUNT, AVG, MIN, MAX for business analysis
3. **Subquery skills** - Nested queries for complex filtering and comparisons
4. **Business intelligence** - Real-world analytical query patterns
5. **Performance awareness** - Understanding of query complexity and optimization needs

## 🎯 Success Criteria

- [ ] All 10 advanced queries execute successfully
- [ ] Results demonstrate understanding of business relationships
- [ ] Queries show proper use of JOINs, aggregates, and subqueries
- [ ] Copilot was used effectively for query enhancement
- [ ] Files are saved and documented properly

## 🔗 Next Steps

These advanced queries will be optimized in Activity 3 with:
- Performance analysis and improvement
- Index optimization strategies
- Query execution plan analysis
- Scalability considerations

## 💡 Tips for Success

1. **Start simple** - Test basic JOINs before adding complexity
2. **Use sample data** - Verify results make business sense
3. **Comment your queries** - Explain the business purpose
4. **Test incrementally** - Build complex queries step by step
5. **Use Copilot effectively** - Describe the analytical need clearly

---

**Ready to begin?** Start by running the Activity 2 setup script, then work through the queries systematically!
