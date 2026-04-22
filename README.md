# Project: Digital media subscription and user billing.

## Business case summary.
Multimedia Solutions is a Canadian-based media distributor undergoing a strategic digital transformation to support its rapid expansion into international markets, including the US, Mexico, India, Russia, and China.

## Schema overview.
* TBD

## Team members & roles.
1. (ROLE - TBD): Sheree Drummond - n01730490
    * Description: 
2. (ROLE - TBD): Suhani Mehta - n01750525
   Description:
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

4. (ROLE - TBD): Thompson Osei - n01714324
    * Description: 
5. (ROLE - TBD): Kyle Chau - n10004894
    * Description: 
6. (ROLE - TBD): Javier Santana - n01753766
    * Description:
7. (ROLE - TBD): Tandin Phurba - n01654961
    * Description:

## Instructions to run scripts.
* TBD

## Github usernames.
1. Sheree Drummond (Github username)
2. Suhani Mehta (Suhanimeh)
3. Thompson Osei (Github username)
4. Kyle Chau (Github username)
5. Javier Santana (Github username)
6. Tandin Phurba (gurrrrrbu)



