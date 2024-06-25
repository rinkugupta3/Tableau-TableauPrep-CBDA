use AdventureWorks2022
/*===============Lab1============*/
--Difference between count and count_big
use MyFirstDB
create Table EmployeeSalary
(
	EmployeeID int Identity (100,1),
	EmployeeName nvarchar (250),
	Department nvarchar (250),
	EmployeeGrade char (2),
	EmployeeAge int,
	Salary money
)

insert into EmployeeSalary
select 'John', 'Sales', 'L1', 25, $75000
Union All
select 'David', 'Technology', 'L2', 27, $80000
Union All
select 'Mary', 'Technology', 'L3', 29, $90000
Union All
select 'Alice', 'Marketing', 'L2', 26, $70000
Union All
select 'Frank', 'Sales', 'L1', 24, $70000
Union All
select 'Bob', 'Finance', 'L3', 28, $95000
Union All
select 'Robert', 'Technology', 'L4', 24, NULL

select * from EmployeeSalary

select max (salary) from EmployeeSalary
select min (salary) from EmployeeSalary
select max (salary) as 'Max Salary' , min (salary) as 'Min Salary' from EmployeeSalary

--case1  count
select count (salary) from EmployeeSalary
select count (salary) as SalaryCount, Count (EmployeeAge) as EmployeeAge from EmployeeSalary

--case2 count_big
select count_big (salary) from EmployeeSalary

/*===============Lab2===Aggregative Function=========*/
--case1 Standard devation (Stdev)
select stdev (salary) as StandardDev from EmployeeSalary

--case2 Standard devation of population (StdevP)

select stdevP (salary) as StandardDevOfPopulation from EmployeeSalary

/*===============Lab3===Group by operator=========*/
--can be used with Group By - RollUp, Cube, Grouping ID

--case1 cube --will give indiviual department total and will give grand total
select Department,Salary from EmployeeSalary 
Group By Department
---add agregative funtion
select Department, sum (Salary) as 'Total Salary Of Department' 
from EmployeeSalary 
Group By cube (Department)

--case2 rollup
--Example1
select Department, sum (Salary) as 'Total Salary Of Department' 
from EmployeeSalary 
Group By rollup (Department)
--Example2
select Department, sum (Salary) as 'Total Salary Of Department' 
from EmployeeSalary 
Group By rollup (Department, EmployeeGrade)
--Example3
select Department, sum (Salary) as 'Total Salary Of Department' 
from EmployeeSalary 
Group By rollup (EmployeeGrade,Department)

--case3 Grouping ID
Select Department, Sum(Salary), Grouping_ID(EmployeeGrade, Department)from EmployeeSalaryGroup By RollUp(EmployeeGrade, Department)--case4 Grouping Sets--Example1select Department,EmployeeGrade, Sum(Salary) from EmployeeSalaryGroup By GROUPING Sets ((EmployeeGrade,Department),())--case5 combine 'cube, rollup and grouping sets'Select Department, EmployeeGrade, Sum(Salary)from EmployeeSalaryGroup By Grouping Sets (cube (EmployeeGrade, Department)),Rollup (EmployeeGrade,Department)/*===============Lab4===Advanced Table Concepts=========*/--Making record as Unique (Count Total record, Is Identity property of table)--Avoid as Duplicate (Unique Key, Primary Key)--Not having as NULL (not null)--remove Inconsistent (Foregin Key)--To have Default (Defualt constraint)--Limit value range (check constraint)/*==========================================*/--case1 unique valuesUse MyFirstDBcreate Table StudentInfo3(	StudentID int,	StudentName nvarchar (250))Insert into StudentInfo3 (StudentID, StudentName)select 1,'John'Union Allselect 2, 'Bob'Union Allselect 3,'Alice'Union Allselect 4, 'Mary'select * from StudentInfo3Insert into StudentInfo3(StudentID, StudentName)Values(5, 'Frank')--Example1 count Total of record--run code all together from line 123 to 129select * from StudentInfo3Declare @Count intset @Count = (select count(StudentID) from StudentInfo3)set @Count = @Count + 1Insert into StudentInfo3(StudentID, StudentName)Values (@Count,'Roger')--insert another recordDeclare @Count intset @Count = (select count(StudentID) from StudentInfo3)set @Count = @Count + 1Insert into StudentInfo3(StudentID, StudentName)Values (@Count,'Mark')--Exmaple2 'Is Identity" propertyCreate Table StudentInfo4(	StudentId int identity (100,1),	StudentName nvarchar (250),	Cources nvarchar (250))select * from StudentInfo4Insert into StudentInfo4 (StudentName, Cources)values ('Alice', 'SQL')/*==========================================*/--case2 --Avoid Duplicate values (Unique Key, Primary Key)--Example1--Unique Key--Best practice is to give a prefix of UC_Name to unique keycreate Table Country(	CountyID char(3),	CountryName nvarchar (250),	Constraint UC_CountyID Unique (CountyID))select * from Countryinsert into Country (CountyID, CountryName)Values('USA', 'United States')--rerun again above query and will get error--Cannot insert duplicate key in object 'dbo.Country'. The duplicate key value is (USA).insert into Country (CountyID, CountryName)Values('CAN', 'Canada')insert into Country (CountyID, CountryName)Values('MEX', 'United States')update Country set CountryName = 'Mexico' where countyID='MEX'/*Syntax for altering and dropping unique constraints--Add UC for existing table-- Alter Table Country Add Constraint UC_CountryID Unique(CountryID)-- Drop the UC--Alter Table Country Drop Constraint UC_CountryID**Note - In drop remove everything after UC_CountryID*/--Example2---Primary Keycreate Table Country2(	CountryID char (3) Not Null,	CountryName nvarchar (250),	Constraint PK_CountryID Primary Key Clustered (CountryID))select * from Country2insert into Country2 (CountryID, CountryName)Values('MEX', 'Mexico')--rerun same query and will get an error--Cannot insert duplicate key in object 'dbo.Country2'. The duplicate key value is (MEX).
--The statement has been terminated.

insert into Country2 (CountryID, CountryName)Values('AUS', 'Australia')/*Syntax for Altering and Dropping constraintsALTER TABLE Country2 ADD CONSTRAINT PK_CountryIdPRIMARY KEY (CountryId)ALTER TABLE Country2 DROP CONSTRAINT PK_CountryId*/--Add PK--Alter Table Country2 Add Constraint PK_CountryID Primary Key Clustered(CountryID)--Drop PK--Alter Table Country2 Drop Constraint PK_CountryID/*==============================================*/--case3--Not having as NULL (not null)Create Table StudentInfo5(	StudentID int Not Null,	StudentName nvarchar(250),	Courses nvarchar(250))Select * from StudentInfo5--the following code will throw an error as StudentID is missingInsert into StudentInfo5(StudentName, Courses)Values('John', 'SQL')--Alter code as followsInsert into StudentInfo5(StudentID,StudentName, Courses)Values(100, 'John', 'SQL')/*==============================================*/--case4--Avoid Inconsistent values - use Foregin Key--referential integrityCreate Table States(	StateID int identity (1000, 1),	StateName nvarchar(250),	CountryID char(3) Not Null,	Primary Key(StateID), Constraint FK_CountryID Foreign Key(CountryID) References Country(CountryID))Insert into States(StateName, CountryID)Values('New York', 'USA')Select * from States--The following code will not workInsert into States(StateName, CountryID)Values('New Jersey', 'GBN')--Revise the code asInsert into States(StateName, CountryID)Values('New Jersey', 'USA')--Add FK to existing table--Alter Table States Add Foreign Key(CountryID) References Country(CountryID)--Drop FK--Alter Table States Drop Constraint FK_CountryID/*====================================================*//*=========Assignement====HomeWork============================*//*Assignement2*//*Use AdventureWorks:
 2. Using Production.ProductInventory, find:
 • Sum of the Quantity of groups of distinct LocationID and Shelf columns
 • Return LocationID, Shelf and sum of Quantity as CurrentInventory
 */
Use AdventureWorks2022Select * from [Production].[ProductInventory]SELECT LocationID, Shelf, SUM(Quantity) AS CurrentInventoryFROM Production.ProductInventoryGROUP BY CUBE (LocationID, Shelf)

 /*Assignement3*/
 /*
 3. Using Sales.SalesOrderHeader Table, find:
 • Sum of SubTotal column
 • Group the sum on distinct SalesPersonID and CustomerID
 • Roll up the results into subtotal and running total (grand total)
 • Return SalesPersonID, CustomerID and sum of SubTotal column
 */
 Select * from Sales.SalesOrderHeaderSELECT s.SalesPersonID,s.CustomerID,sum(SubTotal) AS 'Sum Sub Total'FROM Sales.SalesOrderHeader s GROUP BY ROLLUP (SalesPersonID,CustomerID)


/*Assignement4*/
 /*
 Use AdventureWorks:
 4. Using Production.ProductInventory Table, find:
 • Sum of the Quantity with SubTotal for each LocationID and Shelf columns
 • Group the result for all combination of distinct LocationID and Shelf columns
 • Roll up result into subtotal and running total
 • Return LocationID, Shelf and sum of Quantity as CurrentInventory
 */
 SELECT LocationID, Shelf, SUM(Quantity) AS CurrentInventoryFROM Production.ProductInventoryGROUP BY GROUPING SETS ( ROLLUP (LocationID, Shelf), CUBE (LocationID, Shelf))
 
 /*Assignement5*/
 /*
 5. Using Production.ProductInventory Table, find:
 • Total Quantity for each LocationID
 • Grand Total for all locations
 • Return LocationID, Shelf and total Quantity as InventoryTotal
 • Group results on LoactionID
 */
 SELECT LocationID, SUM(Quantity) AS InventoryTotalFROM Production.ProductInventoryGROUP BY GROUPING SETS ( LocationID, ())

 /*Assignement6*/
 /*
 6. Using Person.ContactType Table, find:
 • Contacts listed as Manager in all Departments
 • Return ContactTypeID and Name
 • Display result in Descending order
 */
 Select * from Person.ContactTypeSELECT ContactTypeID, Name FROM Person.ContactTypeWHERE Name LIKE '%Manager%' ORDER BY Name Desc

 /*Assignement7*/
 /*
 7. Using Person.Person Table, find:
 • Persons whose last names begin with a ‘S’
 • Display result as FirstName Ascending and then by LastName
 Descendin
 */
 SELECT LastName, FirstName FROM Person.Person  WHERE LastName LIKE 'S%'  ORDER BY FirstName Asc, LastName Desc