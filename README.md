# Project: Digital media subscription and user billing.

## Business case summary.
Multimedia Solutions is a Canadian-based media distributor undergoing a strategic digital transformation to support its rapid expansion into international markets, including the US, Mexico, India, Russia, and China.

## Schema overview.
The MultimediaSolutions database is designed using a normalized relational structure to support global digital media transactions and reporting.

The system includes the following core entities:
- Customer: Stores customer information, account status, and regional data
- Employee: Represents support staff and maintains hierarchical relationships
- Order_Info: Stores high-level order transaction details
- Order_Details: Stores item-level order breakdowns
- Country: Maintains country and currency information
- Promotion: Stores promotional offers with discount constraints
- Exchange_Rate: Tracks currency conversion rates for global reporting

These entities are connected using primary and foreign key relationships to ensure referential integrity and support business workflows such as order processing, promotion application, and financial reporting.

## Team members & roles.
1. (Database Design, Security & Workflow Testing): Sheree Drummond - n01730490
    * Description: Assisted with the overall database architecture by designing the Entity Relationship Diagram (ERD) and contributing to the structure and data flow of the MultimediaSolutions system. Ensured data consistency, referential integrity, and efficient query performance through proper database design. Implemented and validated role-based security using SQL Server to enforce appropriate access restrictions. Developed and executed structured testing scripts to simulate real-world workflows, validate business rules, and confirm system reliability and access control.

2. (ROLE - TBD): Suhani Mehta - n01750525
  * Description:

3. (User Manual, Seed Data, Testing & Evaluation): Kyle Chau - n10004894
    * Description: Created a user-friendly startup guide for setting up and using the MultimediaSolutions database. This included step-by-step instructions for database creation, initialization, and verification using SQL Server Management Studio. Developed and documented seed data to populate the database for testing purposes. Performed testing and evaluation of all database components, including tables, views, and stored procedures, by executing validation queries and confirming expected outputs. Ensured proper functionality by identifying and resolving errors during script execution.

 4. (ROLE - TBD): Thompson Osei - n01714324
    * Description: 

5. (ROLE - TBD): Javier Santana - n01753766
    * Description:
    * Tables & Schema
        Reports
        * Country
        * Exchange
        * Promotion

* Procedures
  * exchange_Rate_Control.sql (Duplicate)
  * sp_apply_seasonal_promotion.sql
  * sp_update_exchange_rate.sql
  * trg_check_promotion_limit.sql

* Views
  * v_executive_global_sales.sql

* General
  * Overlay_Design.sql
  * Business case
  * Readme

* Index
  * idx_promotion_code_lookup
  * idx_exchange_rate_currencies

* Others
  *  Users
  * Security

6. (Reporting, Data Analysis & Validation): Tandin Phurba - n01654961

◦ Description: Designed and implemented advanced reporting features for the MultimediaSolutions database by developing stored procedures and views to transform transactional data into meaningful business insights. Created a monthly country sales reporting procedure that aggregates order data, calculates total sales, and converts all values into CAD using dynamic exchange rate logic. Developed a detailed order-level analytical view to provide deeper visibility into customer activity, country distribution, and currency conversion results. Implemented data validation through CHECK constraints to enforce positive exchange rates and maintain data integrity. Ensured accuracy and reliability of outputs by testing queries, resolving join and duplication issues, and validating results against expected business scenarios.

   # Database Design
-  Customer Table
Stores customer personal and subscription details
Includes email, address, city, country, and account status
Linked to Employee table via SupportRepId
Constraints:
Primary Key: CustomerId
UNIQUE constraint on Email
CHECK constraint for AccountStatus (Active, Suspended, Cancelled)
-  Employee Table
Stores employee and support staff information
Includes job details, department, and work information
Self-referencing relationship using ReportsTo (manager structure)
Maintains organizational hierarchy

  # Stored Procedures
- sp_GetCustomersDynamic
Retrieves customers using dynamic filters
Filters based on City and Account Status
Uses dynamic SQL (sp_executesql)
Supports flexible query execution
-  sp_UpdateCustomerStatusDynamic
Dynamically updates customer account status
Uses parameterized dynamic SQL
Ensures secure and flexible updates
  -  sp_DisplayCustomers
Uses cursor-based processing
Iterates through all customers
Displays:
Full Name
Email
Account Status
-  sp_CustomersByEmployee
Uses nested cursors
Displays employees and their assigned customers
Shows relationship between support staff and customers
  - sp_SuspendInactiveCustomers
Identifies customers without assigned support representatives
Automatically updates their status to "Suspended"
Uses cursor-based update logic

# Indexing & Performance Optimization
-  Clustered Index
Applied on: (customer_id, order_date DESC)
Improves performance of:
Customer order history queries
Recent transaction retrieval
-  Non-Clustered Primary Key
Applied on: order_id
Ensures fast record lookup while maintaining clustering flexibility
 - Filtered Index
Applied on: promotion_id IS NOT NULL
Improves performance by indexing only promotional records
Reduces unnecessary storage usage

# Key SQL Concepts Used
- Stored Procedures (5+ implemented)
- Dynamic SQL using sp_executesql
- Cursors (single and nested)
- Foreign key relationships
- Constraints (PK, FK, UNIQUE, CHECK)
- Clustered and Non-clustered indexing
- Filtered indexing for optimization
  
# Business Logic Implemented
- Customer management (view, filter, update)
- Employee-customer relationship mapping
- Account status control and suspension rules
- Dynamic data retrieval based on conditions
- Performance-optimized order processing


## Instructions to run scripts.

Instructions to Run the Script
1. Prerequisites
Microsoft SQL Server Management Studio (SSMS): Version 18.0 or higher is recommended.

Base Database: The MultimediaSolutions database must be restored and available on your local or server instance before proceeding.

2. Execution Steps
  1. Open SSMS: Connect to the SQL Server instance where MultimediaSolutions is hosted.

  2. Load the Script: Open the Overlay_Design.sql file (File > Open > File).

  3. Verify Target Database: Ensure the script is set to use the correct database. While the script contains a USE MultimediaSolutions; command, it is best practice to verify the dropdown menu in the SSMS toolbar.

  4. Execute: Click the Execute button or press F5.

  5. Confirm Success: Check the Messages tab at the bottom. You should see "MultimediaSolutions Overlay Applied Successfully.".

## Github usernames.
1. Sheree Drummond (Luvsher)
2. Suhani Mehta (Suhanimeh)
3. Thompson Osei (KDespite)
4. Kyle Chau (kchau210-svg)
5. Javier Santana (javi086)
6. Tandin Phurba (gurrrrrbu)



