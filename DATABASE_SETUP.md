# SmartShop Database Setup Instructions

## Option 1: Install SQLite3 (Recommended)

### Windows Installation

1. **Download SQLite3**:
   - Go to https://sqlite.org/download.html
   - Download "sqlite-tools-win32-x86-3450100.zip" or similar
   - Extract to a folder (e.g., `C:\sqlite`)

2. **Add to PATH**:
   - Press `Win + X`, select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - In "System variables", find "Path" and click "Edit"
   - Click "New" and add the SQLite folder path (e.g., `C:\sqlite`)
   - Click "OK" to save

3. **Verify Installation**:
   ```powershell
   sqlite3 --version
   ```

4. **Initialize Database**:
   ```powershell
   cd database
   sqlite3 smartshop.db ".read setup_database.sql"
   ```

## Option 2: Use VS Code SQLite Extension

1. **Install SQLite Extension** (already installed):
   - SQLite3 Editor by yy0931

2. **Create Database**:
   - Right-click in the `database` folder
   - Select "New File"
   - Name it `smartshop.db`

3. **Open Database**:
   - Right-click on `smartshop.db`
   - Select "Open Database"

4. **Execute Schema**:
   - Open `sql/schema/smartshop_schema.sql`
   - Copy all content
   - In SQLite3 Editor, paste and execute

5. **Execute Sample Data**:
   - Open `sql/sample-data/sample_data.sql`
   - Copy all content
   - In SQLite3 Editor, paste and execute

## Option 3: Use SQLTools Extension

1. **Add Connection**:
   - Press `Ctrl+Shift+P`
   - Type "SQLTools: Add New Connection"
   - Select "SQLite"
   - Configure:
     - Name: SmartShop
     - Database File: `./database/smartshop.db`

2. **Execute Scripts**:
   - Right-click on the connection
   - Select "New SQL File"
   - Copy and paste schema and data scripts
   - Execute line by line

## Verification

After setup, verify your database with this query:
```sql
SELECT 
    'Categories' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM categories
UNION ALL
SELECT 
    'Products' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM products
UNION ALL
SELECT 
    'Inventory' AS Table_Name, 
    COUNT(*) AS Record_Count 
FROM inventory;
```

Expected results:
- Categories: 8 records
- Products: 22 records  
- Inventory: 88 records

## Next Steps

Once your database is set up, you can:
1. Open `sql/queries/activity1_basic_queries.sql`
2. Execute each query using your preferred method
3. Follow the `ACTIVITY1_GUIDE.md` for detailed instructions

## Troubleshooting

- **SQLite3 not found**: Follow Option 1 or use Option 2/3
- **Permission errors**: Run VS Code as administrator
- **File path issues**: Use forward slashes in paths
- **Extension issues**: Reload VS Code after installation
