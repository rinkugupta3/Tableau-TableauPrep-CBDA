/*==================Week7=====================================*/
/*==================Stored Procedure (SQL automation)=========*/
/*==================================================*/--STORED PROCEDURES--SP stored in Obeject Explorer folder>>>>Programmability>>>>Stored Procedures--Use following code if you do not have the Country tableUse MyFirstDBCreate Table Country(	CountryID char(3),	CountryName nvarchar(50),	Constraint UC_CountryID Unique(CountryID))Select * from Country-- **use this code in case Country table does not existInsert into Country(CountryID, CountryName)values ('USA', 'United States')--Now re-run the insert into ...values.--Next, let's insert another recordInsert into Country(CountryID, CountryName)values ('CAN', 'Canada')INSERT INTO Country(CountryId,CountryName)VALUES('MEX','Mexico')INSERT INTO Country(CountryId,CountryName)VALUES('AUS','Australia')Select * from Country--Lab 1 --SP without ParametersUse MyFirstDBSelect * from CountrySelect countryid, countryname from Country/*=========================*//*=======SP stored in Obeject Explorer folder>>>>Programmability>>>>Stored Procedures=====*/--Create the SPCreate Procedure ListCountries As	Begin		Set NoCount On --will NOT retun count and will stop DONE_IN_PROC		Select countryid, countryname from Country	End--Execute the SPExecute ListCountriesorExec ListCountries/*When SET NOCOUNT is ON, the count is not returned. Run query quick as no row/column are count.When SET NOCOUNT is OFF, the count is returned. SET NOCOUNT ON prevents the sending of DONE_IN_PROC messages to the client for each statement in a stored procedure. For stored procedures that may contain several statements not returning much data, or for procedures that contain Transact-SQL loops, setting SET NOCOUNT to ON can provide a significant performance boost, because network traffic is greatly reduced.*//*========================================================*/--Lab 2 - SP with parameters--Create a new tableCreate Table StudentSP(StudentID int Identity (100,1),StudentName nvarchar(250),City nvarchar (250),Age int)Select * from StudentSP--Create the SP--@ mean is variable or parameterCreate Procedure InsertStudents@StudentName nvarchar (250), @City nvarchar (250), @Age intAs	Begin		Set NoCount On		Insert into StudentSP (StudentName, City, Age)		Values (@StudentName, @City, @Age)	Endselect * from StudentSP--Execute the SP with parametersExecute InsertStudents 'Mary','Edision', 16orExec InsertStudents--Insert antoher recordExec InsertStudents 'Bob','Woodbridge', 17--missing parameter and code will fail due to insufficient paramtersExec InsertStudents 'Frank','Newark'Exec InsertStudents 'Frank'/*========================================================*/--Lab 3 - SP with optional parameters--Create the SPCreate Procedure OptionalParametersSP@StudentName nvarchar (250), @City nvarchar (250) = 'N/A', --optional@Age int = 0 --optionalAs	Begin		Set NoCount On		Insert into StudentSP (StudentName, City, Age)		Values (@StudentName, @City, @Age)	End--Execute th SPExecute OptionalParametersSPExecute OptionalParametersSP 'Frank'select * from StudentSP/*==============================================*/--Lab 4 - Advantage of SPs--1) Reduceing the number of round trips--2) Have better performance--3) Have increased security--Create the SPCreate Procedure GetAllInfoAs	Begin		select * from StudentSP		select * from Country		select * from Employee		select * from Department	End--Execute the SPExecute GetAllInfo/*=========================================*/--Lab 5 - Encrpted Stored Procedure--View the SP codesp_helptext OptionalParametersSPsp_helptext ListCountries--Create the SPCreate Procedure GetEmployesswith EncryptionAs	Begin	Set NoCount On	Select EmployeeId, EmployeeName, City from Employee	End--Execute the SPExecute GetEmployesssp_helptext GetEmployess---Message will be 'The text for object 'GetEmployess' is encrypted'/*================Dynamic SP==Run all lines Together===========================*/--Lab 6 - Dynamic SPUse MyFirstDBCreate Table BookInfo(ISBN int,BookName nvarchar(50) NOT NULL,BookGenre nvarchar(50) NOT NULL,BookCost int NOT NULL)--Add some values into itINSERT INTO BookInfoVALUES(123, 'Book1', 'Genre1', 50),(234, 'Book2', 'Genre2', 60),(345, 'Book3', 'Genre3', 70),(456, 'Book4', 'Genre4', 80),(567, 'Book5', 'Genre5', 90)Select * from BookInfo--Next, run a dynamic query--store catche in browser for small time --Below lines are equal to SP lines--Run all below 3 lines togetherDeclare @SQL_Query nvarchar (250)Set @SQL_Query = N'Select ISBN,BookName,BookGenre,BookCost from BookInfo where BookCost > 60'Exec sp_executesql @SQL_Query--create another dynamic queryDeclare @SQL_Query2 nvarchar (250)Set @SQL_Query2 = N'Select ISBN,BookName,BookGenre,BookCost from BookInfo where BookCost > 70'Exec sp_executesql @SQL_Query2/*=============================================*/--Lab 7 - Passing Parameters in Dynamic query--run all below lines togetherDeclare @Condition nvarchar(250)Declare @Sql_Query3 nvarchar(250)Declare @Params nvarchar(250)Set @Condition = 'Where BookCost > @LowerCost And BookCost < @HigherCost'Set @Sql_Query3 = N'Select ISBN, BookName, BookGenre, BookCost from BookInfo ' + @ConditionSet @Params = '@LowerCost int, @HigherCost int'Exec sp_executesql @Sql_Query3, @Params, @LowerCost = 50, @HigherCost = 90--end running code here/*#############################################################################*//*==================================================*/
/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

/*======== Conditional statements =========*/

-- Pseudo Code
/*
If --- In
(What is the condition)
Begin
	What to do
End
*/
-- CONTROL FLOW STATEMENTS

--LAB 10 - IF

If Datename(WEEKDAY, GETDATE()) In
('Saturday', 'Sunday')
Begin
	Select 'Weekend' As Response
End

/*==================================================*/

--LAB 11 - IF ... ELSE Condition
/*
If something is true,
then do something
if something is not avaiable,
then try something else
*/

If Datename(WEEKDAY, GETDATE()) In
('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
	Begin
		Select 'Working Weekdays' As Response
	End
Else
	Begin
		Select 'Weekend' As Response
	End

--LAB 12 -- IF ... ELSE IF Condition
/*
If something is true,
then do something
if something is not avaiable,
else if try alternate option 1
else if try alternate option 2
else if try alternate option 3
else - deafult option
*/
If Datename(WEEKDAY, GETDATE()) In
('Monday', 'Tuesday')
	Begin
		Select 'Early Working Week' As Response
	End
Else If Datename(WEEKDAY, GETDATE()) In
('Wednesday')
	Begin
		Select 'Mid Working Week' As Response
	End
Else if Datename(WEEKDAY, GETDATE()) In
('Thursday', 'Friday')
	Begin
		Select 'Later Working Week' As Response
	End
Else
	Begin
		Select 'Weekend' As Response
	End

/*==================================================*/

--LAB 13 - WHILE LOOP

Declare @counter int
Set @counter = 0
While @counter < 5
	Begin
		Set @counter = @counter + 1
		Print 'The @counter number is ' + cast(@counter as char)
	End

/*==================================================*/

--LAB 14 - BREAK STATEMENT

Declare @counter2 int = 0
While @counter2 <= 5
	Begin
		Set @counter2 = @counter2 + 1
			If @counter2 = 3
			break
		Print 'The @counter2 number is ' + cast(@counter2 as char)
	End

--LAB 15 --> CONTINUE STATEMENT

Declare @counter3 int = 0
While @counter3 <= 5
	Begin
		Set @counter3 = @counter3 + 1
			If @counter3 = 3
			continue
		Print 'The @counter3 number is ' + cast(@counter3 as char)
	End

--Lab 16 --> GO TO (label)

--use sparingly
-- infinite loop

Declare @counter4 int = 2
While @counter4 <= 5
	Begin
		Select @counter4
			Set @counter4 = @counter4 + 1
			If @counter4 = 3 GoTo Choice_One
			If @counter4 = 4 GoTo Choice_Two
			If @counter4 = 5 GoTo Choice_Three
			End
Choice_One:
	Select 'Printing from Choice_One '
	GoTo Choice_One
Choice_Two:
	Select 'Printing from Choice_Two '
	GoTo Choice_Two
Choice_Three:
	Select 'Printing from Choice_Three '
	GoTo Choice_Three

/*==================================================*/

--LAB 17 --> CASE STATEMENT

--Example 1

Declare @ProductID int = 2
Select
Case @ProductID
	When 1 then 'Apples'
	When 2 then 'Bananas'
	When 3 then 'Orange'
	Else 'No such product exists'
End

--Exmaple2
Use MyFirstDB
Create Table RevenueTable
(
	ProductId int,
	SalesQuarter int,
	Revenue int
)

Create Table RevenueReportingTable
(
	ProductId int,
	SalesQuarter nvarchar (50),
	Revenue int
)
Insert into RevenueTable
values
(1001, 1, 50000),
(1001, 2, 52000),
(1001, 3, 54000),
(1001, 4, 52000)

Select * from RevenueTable

--Copy values from RevenueTable into the Revenue Reporting Table

Insert into RevenueReportingTable(ProductID, SalesQuarter, Revenue)
Select ProductID,
	Case
		When SalesQuarter = 1 Then 'Quarter1'
		When SalesQuarter = 2 Then 'Quarter2'
		When SalesQuarter = 3 Then 'Quarter3'
		When SalesQuarter = 4 Then 'Quarter4'
	End As SalesQuarter, Revenue
From RevenueTable

Select * from RevenueReportingTable
Select * from RevenueTable

/*================SPECIAL CONDITIONS ============*/
/*================cron job=======================*/

-- LAB 18 --> WAIT FOR
--For sysadmin work
--A particular time
-- Help to run SP overnight -- cron job

Execute GetEmployess
Begin
	WaitFor Time '18:15'
End

/*==================================================*/
/*================cron job=======================*/

-- LAB 19 --> WAITFOR DELAY
--For sysadmin work
--A delayed start
--Help to reterive data after below minutes or seconds --cron job

Begin
	WaitFor Delay '0:00:45'
	Execute GetAllInfo
End

/*#############################################################################*//*=================Assignements=================================*/
/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
/*Use AdventureWorks:1. Using Person.Person, HumanResources.Employee, Person.Address and Person.BusinessEntityAddress Tables find: - Employee's full name and city - Sort the result by LastName followed by FirstName(Hint: First Inner join on Person.Person and HumanResources.Employee tables, second Inner Join on Person.Address and Person.BusinessEntityAddress tables)*/SELECT concat(RTRIM(psn.FirstName),' ', LTRIM(psn.LastName)) AS Name, aid.City  FROM Person.Person AS psn  INNER JOIN HumanResources.Employee e ON psn.BusinessEntityID = e.BusinessEntityID   INNER JOIN     (SELECT bea.BusinessEntityID, a.City       FROM Person.Address AS a      INNER JOIN Person.BusinessEntityAddress AS bea      ON a.AddressID = bea.AddressID) AS aid  ON psn.BusinessEntityID = aid.BusinessEntityID  ORDER BY psn.LastName, psn.FirstName/*==================================*//*Use AdventureWorks:2. Using Person.Address and Person.StateProvince Tables, return: - Mailing address for companies outside the United States  - In a city where name starts with Lo(Hint: Use a simple Join)*/SELECT AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode    FROM Person.Address AS a  JOIN Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID  WHERE CountryRegionCode NOT IN ('US')  AND City LIKE 'Pa%' --You can try above example using 'Ot%' for Ottawa, 'Pa%' for Paris, etc./*==================================*//*Use AdventureWorks:3. Using Sales.SalesOrderHeader, and Sales.SalesOrderDetails Tables return orders having - TotalDue is greater than 1000 (or) - OrderQty is more than 100 (or) - UnitPriceDiscount is less than $500(Hint: Use Inner Join to join the tables)*/SELECT *  FROM Sales.SalesOrderHeader AS soh  INNER JOIN Sales.SalesOrderDetail AS sod     ON soh.SalesOrderID = sod.SalesOrderID   WHERE soh.TotalDue > 1000AND (sod.OrderQty > 100 OR sod.UnitPriceDiscount < 500.00)/*==================================*//*Use AdventureWorks:4. Using Production.Product Table: Concatenate the Name, Color and ProductNumber columns(Hint: Use CONCAT function)*/--Compare with Production.Product--Select Name, Color, ProductNumber from Production.ProductSELECT CONCAT( Name,',', ' Color:',Color,',',' Product Number: ', ProductNumber ) AS QueryResult, ColorFROM Production.Product/*==================================*//*Use AdventureWorks:5. Using Production.Product Table: Concatenate the Name, Color and ProductNumber columns and a new line character(Hint: Use CONCAT_WS function)*/SELECT CONCAT_WS( ' - ', Name, ProductNumber, Color) AS ConcatResultFROM Production.Product--Note - CONCAT_WS indicates concatenate with separator/*==================================*//*Use AdventureWorks:6. Using Production.Product Table: Return the seven left most characters of each Product’s name(Hint: Use LEFT function)*/SELECT LEFT(Name, 7)   FROM Production.Product  ORDER BY ProductID/*==================================*//*Use AdventureWorks:7. Using Sales.vIndividualCustomer Table: - Return the number of characters  of LastName - FirstName and Lastname of all people in Canada(Hint: Use LEN function)*/SELECT Len(LastName) AS LastNameLength, FirstName, LastName   FROM Sales.vIndividualCustomer WHERE CountryRegionName = 'Canada'