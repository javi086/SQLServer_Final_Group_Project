/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/
USE MultimediaSolutions;
GO;

CREATE TABLE Promotion (
    PromotionId INT IDENTITY(1,1),
    PromotionCode VARCHAR(20) NOT NULL,
    DiscountValue DECIMAL(5,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,

    CONSTRAINT PK_Promotion PRIMARY KEY CLUSTERED (PromotionId),
    CONSTRAINT UQ_PromoCode UNIQUE (PromotionCode),
    CONSTRAINT CK_Promo_Value CHECK (DiscountValue <= 50.00) -- This will help with our business rule
);