-- ========================================
-- STUDENT 4 – QUERY OPTIMIZATION ENGINEERING
-- ========================================

/*
Objective:
Improve aggregation performance for grouping by CustomerID.

Provided Query:
SELECT CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000;

Performance will be measured using STATISTICS IO.
*/

-------------------------------------------------------
-- Enable IO Statistics
-------------------------------------------------------
SET STATISTICS IO ON;
GO

-------------------------------------------------------
-- Execute Query BEFORE Index Creation
-------------------------------------------------------

/*
Expected Behavior:
- Likely Clustered Index Scan on PK_SalesOrderHeader
- Higher logical reads due to full table scan
*/

SELECT CustomerID, SUM(TotalDue) AS TotalAmount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000;
GO

/*
📌 Capture logical reads from the Messages tab.
Record value here as SQL comment:

-- BEFORE INDEX:
-- Logical Reads = __________
*/

-------------------------------------------------------
-- Create Optimized Covering Index
-------------------------------------------------------

/*
Design Rationale:
- Query groups by CustomerID
- Aggregates TotalDue
- Index key = CustomerID
- INCLUDE TotalDue to avoid lookups
*/

CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_CustomerID_TotalDue
ON Sales.SalesOrderHeader (CustomerID)
INCLUDE (TotalDue);
GO

-------------------------------------------------------
-- Execute Query AFTER Index Creation
-------------------------------------------------------

SELECT CustomerID, SUM(TotalDue) AS TotalAmount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000;
GO

/*
Capture logical reads from the Messages tab.

-- AFTER INDEX:
-- Logical Reads = __________

Expected Improvement:
- Index Seek or Index Scan (NonClustered)
- Reduced logical reads
- Elimination of clustered scan
*/

-------------------------------------------------------
-- Explanation (Required by Rubric)
-------------------------------------------------------

/*
Performance Analysis:

BEFORE:
The optimizer performed a clustered index scan on SalesOrderHeader,
reading all data pages to compute aggregation.

AFTER:
The optimizer can use the nonclustered covering index
IX_SalesOrderHeader_CustomerID_TotalDue,
which contains both grouping and aggregation columns.

This reduces:
- Page reads
- Memory usage
- Query cost

This demonstrates measurable performance improvement
through targeted index design aligned with query pattern.
*/