/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions

  RULES:
   - DO NOT modify base MultimediaSolutions tables
   - All custom objects MUST live under schema: Reports
====================================================================*/
USE MultimediaSolutions;
GO


/*====================================================================
  0) PRE-FLIGHT CHECKS
====================================================================*/
IF DB_ID(N'MultimediaSolutions') IS NULL
BEGIN
    RAISERROR('MultimediaSolutions database not found. Install/restore MultimediaSolutions before running.', 16, 1);
    RETURN;
END
GO


/*====================================================================
  1) SCHEMA
====================================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Reports')
BEGIN
    EXEC(N'CREATE SCHEMA Reports AUTHORIZATION dbo;');
END
GO



/*====================================================================
  2) CLEANUP - Drop existing Sim objects  (safe reset for reruns)

  This section will contain the reports that we are going to generate.
====================================================================*/



/*====================================================================
  3) CREATION OF TABLES
====================================================================*/

/*Pay attention to the names of the tables and attributes */

CREATE TABLE Reports.NameOfMyTable
(
FieldExampleID      INT     NOT NULL

CONSTRAINT PK_Reports_FieldExampleID PRIMARY KEY  CLUSTERED (FieldExampleID)
);
GO

/*====================================================================
  3) INSERTS
====================================================================*/