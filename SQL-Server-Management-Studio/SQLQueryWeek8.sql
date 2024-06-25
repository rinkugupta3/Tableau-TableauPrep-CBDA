/*========================Week8======================*/
/*========Database Security==========================*/
/*========System Admin===============================*/
/*=======vulnerability----how weak is=tenable.com===============*/
/*====Mitigate---- reducing risk of loss=======*/
/*=====remediate and revaluate========*/

/*=======================Security Jobs===========================*/
/*
Distinguised Engineer
Pricipal ServerNow Engineer

CAI Traid
Confidentially
Intergrity
Avaiability
800-53 A
800-53 - GRC
Cyber security framework (CSF)
AES-256
PII - personally identiable information PII ; PHI
PCI - DSS (credit card)

Dark Web
Data at rest - TDE (AES-256) provided by RDBMS
Data in transit - need to be encrypted with AES-256 (HTTP) ; hash
Data in use
*/
/*==================================================*/

/*
 Security concepts
 Role Based Access Control
 • Server role
 • Database role
 • Application role
 Steps to create a role
 • Create the role
 • Grant appropriate permission for the role
 • User mapping (add people/users to the role
*/
/*====
CIA Triad - Data Security
	Confidentiality (privacy) 
	Integrity (can't make change) 
	Availability (always avaiable)
TCS -  PMP
	Time
	Cost 
	Scope
PII - personally indetifiable information 
PHI - used in medical
Data at rest - TDE (AES-256) provided by RDMS
Data in transit - need to be encrypted with AES-256 (HTTPS) ; hash data-compare data
Data in use - 
OWASP - owasp.org -cyber security - OWASP top ten vulnerability
https://owasp.org/www-project-top-ten/
nist.gov
https://www.nist.gov/cyberframework/csf-11-archive
https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5-draft.pdf


SQL injection - 
	
Defense in Depth

=====*/

--Week 8 Assignment Solutions
--Assignment 1
/*
Use AdventureWorks:
1. Using Sales.vStoreWithContacts, and Sales.vStoreWithAddresses Tables find:
 - Distinct Length of FirstName, LastName 
 For CountryRegionName ‘Canada’
(Hint: Use Inner Join)
*/

Use AdventureWorks2022
SELECT DISTINCT LEN(FirstName) AS FirstNameLength, FirstName, LastName   
FROM Sales.vStoreWithContacts  AS c  
INNER JOIN Sales.vStoreWithAddresses AS a   
    ON c.BusinessEntityID = a.BusinessEntityID   
WHERE CountryRegionName = 'Canada'

/*========================*/
/*========================*/

--Assignment 2
/*
Use AdventureWorks:
2. Using Person.BusinessEntityAddress, Person.Address, 
and Person.EmailAddress Tables, return:
 - Email id’s of Employees and group it by City
 - Top 25 rows
(Hint: Use Inner Join on Person.BusinessEntityAddress, 
Person.Address and another Inner Join on Person.Address, 
and Person.EmailAddress Tables)
*/

SELECT Top 25 City, STRING_AGG(cast(EmailAddress as nvarchar(max)), ';') AS emails 
FROM Person.BusinessEntityAddress AS bea  
INNER JOIN Person.Address AS a ON bea.AddressID = a.AddressID
INNER JOIN Person.EmailAddress AS ea 
ON bea.BusinessEntityID = ea.BusinessEntityID 
GROUP BY City

/*========================*/
--Assignment 3
/*
Use AdventureWorks:
3. Using Person.Person, and Sales.SalesPerson Tables return:
 - SalesPersons who have a 5 in the first digit of their SalesYTD
 - Convert SalesYTD column to an int and then to a char (25) datatype
 - Display Firstname, Lastname, SalesYTD and BusinessEntityID in the result-set
(Hint: Use Join on both tables, then cast SalesYTD first as int and then as char)
*/

SELECT p.FirstName, p.LastName, sp.SalesYTD, sp.BusinessEntityID  
FROM Person.Person AS p   
JOIN Sales.SalesPerson AS sp   
    ON p.BusinessEntityID = sp.BusinessEntityID  
WHERE CAST(CAST(sp.SalesYTD AS INT) AS char(20)) LIKE '5%'

/*========================*/

--Assignment 4
/*
Use AdventureWorks:
4. Using Person.Person Table, return:
 - First Names in reverse for people with a BusinessEntityID less than 10
(Hint: Use Reverse)
*/

SELECT FirstName, REVERSE(FirstName) AS ReversedFirstName  
FROM Person.Person  
WHERE BusinessEntityID < 10 
ORDER BY FirstName

/*========================*/
--Assignment 5
/*
Write a SQL query to remove the spaces from the beginning of a string.
*/

SELECT  '     Welcome to SQL class' as "Original Text",
LTRIM('     Welcome to SQL class') as "Trimmed Text(space removed using LTrim)"

/*========================*/
--Assignment 6
/*
Use AdventureWorks:
6. Using Production.Product Table, return:
- Name, Color and ProductNumber
- Select data from Color and ProductNumber columns with non-null value
(Hint: Use Coalesce function)
*/

SELECT Name, Color, ProductNumber, COALESCE(Color, ProductNumber) AS FirstNotNullNumber   
FROM Production.Product; 
--Compare it with
SELECT Name, Color, ProductNumber  
FROM Production.Product 

/*========================*/

--Assignment 7
/*
Use AdventureWorks:
7. Using Sales.SalesOrderDetail Table, return:
- number of products that were ordered in sales orders 54254 and 54257
(Hint: Use Count, Over, Partition By)
Over - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?f1url=%3FappId%3DDev15IDEF1%26l%3DEN-US%26k%3Dk(OVER_TSQL)%3Bk(sql13.swb.tsqlresults.f1)%3Bk(sql13.swb.tsqlquery.f1)%3Bk(MiscellaneousFilesProject)%3Bk(DevLang-TSQL)%26rd%3Dtrue&view=sql-server-ver16
Partition - https://learn.microsoft.com/en-us/sql/t-sql/statements/create-partition-function-transact-sql?f1url=%3FappId%3DDev15IDEF1%26l%3DEN-US%26k%3Dk(PARTITION_TSQL)%3Bk(sql13.swb.tsqlresults.f1)%3Bk(sql13.swb.tsqlquery.f1)%3Bk(MiscellaneousFilesProject)%3Bk(DevLang-TSQL)%26rd%3Dtrue&view=sql-server-ver16
*/

SELECT DISTINCT COUNT(ProductID) OVER(PARTITION BY SalesOrderID) AS SoldProductCount  
    ,SalesOrderID
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID IN (54254,54257)

/*========================*/
/*
Use AdventureWorks:
8. Use Sales.SalesPerson Table, return 
- Sales average by year, for all sales territories where TerritoryID is null or less than 4
- BusinessEntityID, TerritoryID, SalesYear, SalesYTD, average SalesYTD as SalesAvg, 
and total SalesYTD as SalesTotal (Hint: Use built-in functions datepart, cast, avg and sum)
*/
SELECT BusinessEntityID, TerritoryID   
   ,DATEPART(year,ModifiedDate) AS YearOfSales  
   ,cast(SalesYTD as NVARCHAR(25)) AS SalesYTD  
   ,AVG(SalesYTD) OVER (ORDER BY DATEPART(year,ModifiedDate)) AS SalesAvg  
   ,SUM(SalesYTD) OVER (ORDER BY DATEPART(year,ModifiedDate)) AS TotalSales  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 4  
ORDER BY YearOfSales
/*===============================*/