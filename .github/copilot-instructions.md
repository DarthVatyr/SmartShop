# SmartShop Inventory System - Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Context
This is a SQL database project for the SmartShop Inventory System - a retail inventory management system.

## Key Requirements
- Focus on SQL query development and database design
- Target database: SQLite for development, scalable to PostgreSQL/MySQL for production
- Main entities: Products, Categories, Suppliers, Stores, Inventory
- Emphasize query optimization and performance
- Follow SQL best practices and naming conventions

## Database Schema Guidelines
- Use snake_case for table and column names
- Include proper indexes for performance
- Use foreign keys for referential integrity
- Add appropriate constraints and validations

## Query Guidelines
- Write readable, well-commented SQL queries
- Use CTEs (Common Table Expressions) for complex queries
- Include proper error handling where applicable
- Optimize for performance with appropriate indexes and query structure

## File Organization
- `/sql/schema/` - Database schema definitions
- `/sql/queries/` - Business logic queries
- `/sql/sample-data/` - Sample data for testing
- `/database/` - Database files and connection configurations
