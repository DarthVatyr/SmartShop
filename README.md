# SmartShop Inventory System

A comprehensive SQL-based inventory management system for retail operations, designed to manage inventory data across multiple stores with real-time insights into stock levels, sales trends, and supplier information.

## 📋 Project Overview

The SmartShop Inventory System is a database-driven solution that provides:

- **Real-time inventory tracking** across multiple store locations
- **Complex analytical queries** for business intelligence
- **Optimized database operations** for high performance and scalability
- **Comprehensive data relationships** between products, categories, suppliers, and stores

## 🏗️ Database Schema

The system includes the following main entities:

- **Categories** - Product categorization system
- **Suppliers** - Vendor and supplier information
- **Stores** - Multiple store locations
- **Products** - Product catalog with pricing and specifications
- **Inventory** - Stock levels per product per store
- **Stock Movements** - Audit trail for inventory changes

## 📁 Project Structure

```
SmartShop/
├── .github/
│   └── copilot-instructions.md    # Copilot customization instructions
├── sql/
│   ├── schema/
│   │   └── smartshop_schema.sql   # Database schema definitions
│   ├── queries/
│   │   └── activity1_basic_queries.sql  # Basic inventory queries
│   └── sample-data/
│       └── sample_data.sql        # Sample data for testing
├── database/
│   └── setup_database.sql         # Database initialization script
└── README.md                      # Project documentation
```

## 🚀 Getting Started

### Prerequisites

- **SQLite** (for development) or **PostgreSQL/MySQL** (for production)
- **VS Code** with database extensions
- **Git** for version control

### Database Setup

1. **Install SQLite** (if not already installed):
   ```bash
   # Windows (using chocolatey)
   choco install sqlite
   
   # Or download from https://sqlite.org/download.html
   ```

2. **Create and initialize the database**:
   ```bash
   # Navigate to the project directory
   cd database
   
   # Create the database and run setup
   sqlite3 smartshop.db ".read setup_database.sql"
   ```

3. **Verify the setup**:
   ```bash
   sqlite3 smartshop.db ".tables"
   ```

### VS Code Extensions

Install these recommended extensions for database management:

- **SQLTools** - Database management and query execution
- **SQLite Viewer** - View and edit SQLite databases
- **MySQL** - If using MySQL in production

## 📊 Activity 1: Basic Queries

The `activity1_basic_queries.sql` file contains the following queries:

1. **Product Details Query** - Retrieve ProductName, Category, Price, and StockLevel
2. **Category Filter Query** - Filter products by specific category
3. **Low Stock Query** - Identify products with stock below minimum levels
4. **Price Sorting Queries** - Sort products by price (ascending/descending)
5. **Combined Filters** - Multiple conditions with sorting
6. **Category Summary** - Stock level overview by category

### Running the Queries

1. Open the query file in VS Code
2. Use SQLTools to connect to your database
3. Select and execute individual queries
4. Analyze the results for inventory insights

## 🔧 Database Features

### Performance Optimizations

- **Indexes** on frequently queried columns
- **Foreign key constraints** for data integrity
- **Computed columns** for calculated values
- **Triggers** for automated timestamp updates

### Data Integrity

- **Check constraints** for valid data ranges
- **Unique constraints** for business rules
- **Foreign key relationships** between tables
- **Default values** for common fields

## 📈 Sample Data

The system includes realistic sample data:

- 8 product categories
- 6 suppliers
- 4 store locations
- 22 products with varied pricing
- Complete inventory records for all stores
- Stock movement history for audit trails

## 🎯 Learning Objectives

After completing this project, you will have:

- ✅ Written basic SQL queries using AI assistance
- ✅ Created filtered and sorted result sets
- ✅ Understood database relationships and JOINs
- ✅ Prepared foundation queries for advanced analytics
- ✅ Gained experience with real-world database scenarios

## 🔮 Future Activities

This project serves as the foundation for:

- **Activity 2**: Advanced analytical queries and reporting
- **Activity 3**: Performance optimization and scalability
- **Integration**: API development and web interface

## 📝 Notes

- All queries are written with SQLite compatibility
- Schema can be easily adapted for PostgreSQL or MySQL
- Sample data provides realistic scenarios for testing
- Queries include comments for learning and maintenance

## 🤝 Contributing

This project is designed for educational purposes. Feel free to:

- Add new queries and reports
- Optimize existing queries
- Extend the schema for new requirements
- Create additional sample data scenarios

---

**Author**: Database Engineer  
**Date**: July 6, 2025  
**Version**: 1.0.0
