@echo off
REM SmartShop Query Runner Script
REM This script helps you run queries from the activity1_basic_queries.sql file

echo ========================================
echo SmartShop Inventory System Query Runner
echo ========================================
echo.

:menu
echo Please select a query to run:
echo.
echo 1. Query 1: Product Details
echo 2. Query 2: Electronics Category Filter
echo 3. Query 3: Low Stock Products
echo 4. Query 4: Products by Price (Ascending)
echo 5. Query 5: Products by Price (Descending)
echo 6. Query 6: Electronics with Low Stock
echo 7. Query 7: Stock Summary by Category
echo 8. Interactive SQLite3 Session
echo 9. Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto query1
if "%choice%"=="2" goto query2
if "%choice%"=="3" goto query3
if "%choice%"=="4" goto query4
if "%choice%"=="5" goto query5
if "%choice%"=="6" goto query6
if "%choice%"=="7" goto query7
if "%choice%"=="8" goto interactive
if "%choice%"=="9" goto exit
echo Invalid choice. Please try again.
goto menu

:query1
echo Running Query 1: Product Details...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS StockLevel FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE GROUP BY p.product_id, p.product_name, c.category_name, p.price ORDER BY p.product_name;"
pause
goto menu

:query2
echo Running Query 2: Electronics Category Filter...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS StockLevel, p.description AS Description FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE AND c.category_name = 'Electronics' GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.description ORDER BY p.product_name;"
pause
goto menu

:query3
echo Running Query 3: Low Stock Products...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS CurrentStock, p.min_stock_level AS MinStockLevel, (p.min_stock_level - COALESCE(SUM(i.stock_level), 0)) AS StockDeficit FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.min_stock_level HAVING COALESCE(SUM(i.stock_level), 0) < p.min_stock_level ORDER BY StockDeficit DESC;"
pause
goto menu

:query4
echo Running Query 4: Products by Price (Ascending)...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS StockLevel, p.sku AS SKU FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.sku ORDER BY p.price ASC;"
pause
goto menu

:query5
echo Running Query 5: Products by Price (Descending)...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS StockLevel, p.sku AS SKU FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.sku ORDER BY p.price DESC;"
pause
goto menu

:query6
echo Running Query 6: Electronics with Low Stock...
sqlite3 database/smartshop.db -header -column "SELECT p.product_name AS ProductName, c.category_name AS Category, p.price AS Price, COALESCE(SUM(i.stock_level), 0) AS CurrentStock, p.min_stock_level AS MinStockLevel FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN inventory i ON p.product_id = i.product_id WHERE p.is_active = TRUE AND c.category_name = 'Electronics' GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.min_stock_level HAVING COALESCE(SUM(i.stock_level), 0) < p.min_stock_level ORDER BY p.price ASC;"
pause
goto menu

:query7
echo Running Query 7: Stock Summary by Category...
sqlite3 database/smartshop.db -header -column "SELECT c.category_name AS Category, COUNT(DISTINCT p.product_id) AS ProductCount, COALESCE(SUM(i.stock_level), 0) AS TotalStock, ROUND(AVG(p.price), 2) AS AveragePrice, MIN(p.price) AS MinPrice, MAX(p.price) AS MaxPrice FROM categories c LEFT JOIN products p ON c.category_id = p.category_id AND p.is_active = TRUE LEFT JOIN inventory i ON p.product_id = i.product_id GROUP BY c.category_id, c.category_name ORDER BY TotalStock DESC;"
pause
goto menu

:interactive
echo Starting interactive SQLite3 session...
echo Type .help for help, .quit to exit
sqlite3 database/smartshop.db
goto menu

:exit
echo Thank you for using SmartShop Query Runner!
pause
