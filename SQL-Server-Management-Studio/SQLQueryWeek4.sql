/*==============Week4==========*/
/*=========Lab1========*/
--IN operator
--specify multiple values in a WHERE clause
use AdventureWorks2022
select * from Person.CountryRegion
select count (*) from Person.CountryRegion
select * from Person.CountryRegion where CountryRegionCode in ('US','CA', 'IN')

/*========Lab2========*/
--AND, OR, and NOT operatos
select * from Person.Address
select * from Person.Address where city ='seattle'
--case1--AND
select * from Person.Address where city ='seattle' and AddressID = 96
--case2--OR
select * from Person.Address where city ='seattle' or AddressID = 96
--case3--NOT
--will get data without city 'seattle'
select * from Person.Address where NOT city ='seattle'

---Case4---Not and Not Equal
select * from [HumanResources].[Department]
select * from [HumanResources].[Department] where NOT (DepartmentID like 5)

--Case5--Alternative way 1
select * from [HumanResources].[Department] where DepartmentID NOT like 5

--Case6---Atlernate way 2
select * from [HumanResources].[Department] where NOT (DepartmentID BETWEEN 5 AND 15)

--Case7---Atlernate way 3
select * from [HumanResources].[Department] where DepartmentID NOT BETWEEN 5 AND 15

--Case8---Combine AND, OR, NOT
select * from Person.Address where city ='seattle' AND NOT AddressID= 97

/*============Lab3================*/
--UNION and UNION ALL
select * from [Person].[BusinessEntity]

select * from [Person].[BusinessEntityContact]
---Union
--will remove duplicate values
select BusinessEntityID from [Person].[BusinessEntity]
Union
select BusinessEntityID from [Person].[BusinessEntityContact] 

--Union All
--Will NOT remove duplicate values
select BusinessEntityID from [Person].[BusinessEntity]
Union All
select BusinessEntityID from [Person].[BusinessEntityContact] 

--INTERSECT
--Intersect returns the common records of both the tables.
select BusinessEntityID from [Person].[BusinessEntity]
INTERSECT
select BusinessEntityID from [Person].[BusinessEntityContact]

/*============Lab4================*/
--ORDER BY
--Sorting data

--Case1--Order by
select * from [HumanResources].[Department]
select * from [HumanResources].[Department] order by DepartmentID
select * from [HumanResources].[Department] order by Name

--Case2--Order by ascending
--default
select * from [HumanResources].[Department] order by DepartmentID asc

--Case3---Order by descending
select * from [HumanResources].[Department] order by DepartmentID desc

-Case4--combination
select * from [HumanResources].[Department] order by DepartmentID desc, Name asc

/*============Lab5================*/
--TOP and TOP %
--Top data in the row which is first data
--Top% top performing person in the table (top student)
select * from [Sales].[SalesPerson]
select Top 5 SalesYTD,BusinessEntityID from [Sales].[SalesPerson]
select Top 5 * from [Sales].[SalesPerson]
--will display TOP 5 data
select Top 10 Percent SalesYTD,BusinessEntityID from [Sales].[SalesPerson]
--will display Top 10%

/*============Lab6================*/
--DISTINCT
--will remove repeating column
select * from [Person].[StateProvince]
select DISTINCT TerritoryID from [Person].[StateProvince]

/*============Lab7================*/
--count
--case1
--will display result...will take time becuase of *
select count (*) from [Person].[StateProvince]
--case2
select count (Distinct TerritoryID) from [Person].[StateProvince]
--case3
--will display result quickly
select count (1) from [Person].[StateProvince]
--case4
--count show up as a clumn header and is visiable in pink
select DISTINCT TerritoryID as count from [Person].[StateProvince]
--Best practice 
select DISTINCT TerritoryID as [count] from [Person].[StateProvince]

/*============Lab8================*/
--Group by, Max, Min
--Group by always use agegrate funtion as "sum"
select * from [Sales].[SalesOrderDetail]
select * from [Sales].[SalesOrderDetail] group by SalesOrderID
--Error Column 'Sales.SalesOrderDetail.SalesOrderDetailID' is invalid in the select list because 
--it is not contained in either an aggregate function or the GROUP BY clause.

select SalesOrderID, sum (linetotal)from [Sales].[SalesOrderDetail] group by SalesOrderID
select SalesOrderID, sum (linetotal)as SalesSubTotal from [Sales].[SalesOrderDetail] 
group by SalesOrderID
order by SalesOrderId

/*============Lab9================*/
--Having
--later addition to SQL

select * from [Sales].[SalesOrderDetail]

--code below fail with error syntax error
select SalesOrderID, sum (linetotal)as SalesSubTotal from [Sales].[SalesOrderDetail] 
group by SalesOrderID
where Sum (lineTotal) > 10000
order by SalesOrderId

--replace with having instead of where
select SalesOrderID, sum (linetotal)as SalesSubTotal from [Sales].[SalesOrderDetail] 
group by SalesOrderID
having Sum (lineTotal) > 10000
order by SalesOrderId

/*============Lab10================*/
--Null and Not Null
--Null field with NO value (not required field)
--eg in website some field are not required.

select * from sales.salesperson where salesquota is null

--NOT Null field require to input value (required field)
select * from sales.salesperson where salesquota is not null

/*============Lab11================*/
--Alias
--Rename column name
--Case1 - Alias For column
select FirstName, LastName from [Person].[Person]
select FirstName, LastName As 'Family Name' from [Person].[Person]

--Case2 - Alias For Table
--P - Alias
select P.FirstName, P.LastName as 'Family Name' from [Person].[Person] P

select P.FirstName as 'Given Name', 
P.LastName as 'Family Name' from [Person].[Person] P
/*============Lab12================*/
--Max and Min Funtions

select * from [HumanResources].[EmployeePayHistory]
select Rate from [HumanResources].[EmployeePayHistory]
select max (Rate) from [HumanResources].[EmployeePayHistory]

select min (Rate) from [HumanResources].[EmployeePayHistory]

select ModifiedDate from [HumanResources].[EmployeePayHistory]
select max (ModifiedDate) as latestrecord from [HumanResources].[EmployeePayHistory]

select min (ModifiedDate) as oldestrecord from [HumanResources].[EmployeePayHistory]

/*============Lab13================*/
--Exists and Not Exists
use MyFirstDB

--If record exists

select * from Students

--case1
--insert value to table

insert into students (studentid, studentname,studentaddress,studentemail)
select 108, 'Hello1', '220 S Laurel Ave Middletown NJ 07748', 'hellostudent1@mail.com'
union all
select 109, 'Hello2', '320 S Laurel Ave Middletown NJ 07748', 'hellostudent2@mail.com'
union all
select 110, 'Hello3', '420 S Laurel Ave Middletown NJ 07748', 'hellostudent3@mail.com'

if Exists (select StudentName from Students where studentname='Student7')
Begin
select * from Students where studentname='Student7'
End

--case2---if record doesn't exist
--insert value to the table

if NOT Exists (select StudentName from Students where studentname='Student11')
Begin
insert into students (studentid, studentname,studentaddress,studentemail)
values (111,'Student11', '550 S Laurel Ave Middletown NJ 07748', 'hellostudent4@mail.com')
End

Else
Begin
select 'Student11 is already enrolled in the class'
End
/*=============Need to test again======*/
/*==================================*/--LAB 13 - Exists and Not ExistsUse MyFirstDB--If ExistsSelect * from Students-- Case 1--insert values into tableInsert into Students(StudentID, StudentName, StudentAddress, StudentEmail)Select 106, 'Student6', 'Street6', 'Email6@gmail.com'Union AllSelect 107, 'Student7', 'Street7', 'Email7@gmail.com'Union AllSelect 108, 'Student8', 'Street8', 'Email8@gmail.com'If Exists(Select StudentName from Students Where StudentName='Student5')Begin	Select * from Students Where StudentName='Student5'End-- Case 2 - if record doesn't existIf Not Exists(Select StudentName from Students Where StudentName='Student9')Begin	Insert into Students(StudentID, StudentName, StudentAddress, StudentEmail)	Values(109, 'Student9', 'Street9', 'Email9@gmail.com')EndElseBegin	Select 'Student9 is already enrolled in the class' As 'Confirmation Message'EndSelect * from Students/*======Lab14======*/--Escape Sequenceselect 'Hi, my name is Paul Brien'---code will failselect 'Hi, my name's Paul O'Brien'--need to use escape sequence and add another invited commaselect 'Hi, my name''s Paul O''Brien'/*==============Assignement1============*/--Use Person.Person Table and write a query to--case 1 Return all rows of columns FirstName, LastName and PersonTypeuse AdventureWorks2022select * from [Person].[Person]select firstname, lastname, PersonType from [Person].[Person]--case2 Sort by LastNameselect firstname, lastname, PersonType from [Person].[Person] order by lastname desc--case3 Use alias of ‘Role’ to PersonTypeselect firstname, lastname, PersonType as [Role] from [Person].[Person] order by lastname desc/*================Assignement2=============*/--Use Sales.SalesOrderHeaderTable and write a query to--case1 Return all rows of columns SalesOrderID, CustomerID, OrderDate, 
-- PurchaseOrderNumber, and SubTotal

select * from [Sales].[SalesOrderHeader]
select SalesOrderID,CustomerID,OrderDate, PurchaseOrderNumber, SubTotal from [Sales].[SalesOrderHeader]

--case2 Calculate TaxPercent (TaxPercent = TaxAmt * 100)
select SalesOrderID,CustomerID,OrderDate,PurchaseOrderNumber,SubTotal, 
(TaxAmt*100)/SubTotal as TaxPercent
from [Sales].[SalesOrderHeader]

--case3  Order By SubTotal Descending
select SalesOrderID,CustomerID,OrderDate,PurchaseOrderNumber,SubTotal
from [Sales].[SalesOrderHeader]
 order by SubTotal desc

/*=====================Assignement3================*/
--Use HumanResources.EmployeeTable and
--case1 Find Distinct JobTitles and arrange it in Descending order

select * from [HumanResources].[Employee]
select distinct JobTitle from [HumanResources].[Employee] 
order by JobTitle desc

/*=====================Assignement4================*/
-- Use Sales.SalesOrderHeader Table and write a query to
--case1 Return CustomerID, SalesPersonID, Average and Sum of SubTotal
select * from [Sales].[SalesOrderHeader]

select CustomerID,SalesPersonID,SubTotal, 
Avg(SubTotal), Sum(SubTotal) 
from [Sales].[SalesOrderHeader]

--case2  Find Average and SubTotal for every Customer
select CustomerID,SalesPersonID,
Avg(SubTotal) As AverageSubTotal, 
Sum(SubTotal) As SubSubTotal
from [Sales].[SalesOrderHeader]
Group by CustomerId,SalesPersonID

--case3 Group Result By CustomerID, and SalesPersonID and
select CustomerID,SalesPersonID,
Avg(SubTotal) As AverageSubTotal, 
Sum(SubTotal) As SubSubTotal
from [Sales].[SalesOrderHeader]
Group by CustomerId,SalesPersonID

--case4 Sort by SalespersonID in Descending order
select CustomerID,SalesPersonID,
Avg(SubTotal) As AverageSubTotal, 
Sum(SubTotal) As SubSubTotal
from [Sales].[SalesOrderHeader]
Group by CustomerId,SalesPersonID
order by SalesPersonID desc

/*=====================Assignement5================*/
--Use Production.ProductInventoryTable and write a query to:
--case1 Return inventory(quantity) of each ProductID in shelves B, D or J
--Filter results for inventory over 250
--Sort by ProductID in Descending order

select * from [Production].[ProductInventory]

select ProductID, sum(Quantity) 
As Inventory from [Production].[ProductInventory] 
where Shelf in ('B', 'D', 'J')
Group By ProductID
Having Sum(Quantity) > 250
order by ProductID desc


