/*===================Week6=======================*/

/*========Deafult=========================*/
--Lab1
--Default Constraints
--case 1 - Give Dfault values
use MyFirstDB
select * from StudentInfo

Alter Table StudentInfo Add IsActive bit Default 1

insert into StudentInfo (StudentID, StudentName)
values (3,'Frank')

--case2 - Give deafult Time

Alter Table StudentInfo Add EnrollmentStartDate Datetime Default GetDate()

insert into StudentInfo (StudentID, StudentName)
values (4,'Mary')

--case3 - Give identifier (unique id)
Alter Table StudentInfo Add UniqueSessionID UniqueIdentifier Default NewID()

insert into StudentInfo (StudentID, StudentName)
values (5,'Bob')

insert into StudentInfo (StudentID, StudentName)
values (6,'Robert')

/*============Limit Value Range===*/
--security check 
--California online privacy act (COPA) 
--Check Constraint
--Lab2

use MyFirstDB

create Table StudentInfo6
(
	StudentID int Identity (100,1),
	StudentName nvarchar (250),
	Age int
	Constraint Check_Age Check(Age > 13)

)

select * from StudentInfo6

Insert into StudentInfo6 (StudentName, Age)
values ('John',14)

--insert another record with age less then 14
Insert into StudentInfo6 (StudentName, Age)
values ('Bob',10)


/*============SubQueries============*/
--Lab3
--case 1 --> Classic sub query (IN operator)

use AdventureWorks2022
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory

select StartDate, EndDate, DepartmentID from HumanResources.EmployeeDepartmentHistory
where DepartmentID IN
(
select DepartmentID from HumanResources.Department
)

--case2 -->STUFF
/*
The Stuff() function deletes a part of a string and
then inserts another part into the string, starting at a specified position
*/
--Stuff Example1
--inline query
--when website is down and display message

select STUFF ('Hello Student',6,1,' SQL ') As Greating
--or
--will remove first character from student with '2'
select STUFF ('Hello Student',6,2,' SQL ') As Greating

--STUFF example2
--Just to replace one character
 select STUFF ('Hello Student',6,1,' SQL ') As WelcomeMessage
 or
 select STUFF ('Hello Student',6,1,' SQL ') As 'Welcome New Student'

 ---case3 --> Subquery with XML
 --create TEMP table
 --run all together create (declare), insert, select statements
 --data inflight

 Declare @T Table
 (
	Instructor nvarchar (250),
	Courses nvarchar (250)
 )
 Insert into @T values
 ('Mark', 'SQL'),
  ('Mark', 'C#'),
   ('Mark', 'ASP.NET'),
    ('Bob', 'PMP'),
	 ('Bob', 'CISSP')

select * from @T

select Instructor,courses = STUFF
(
	(
		select ', ' + Courses
		From @T As T2
		where T1.Instructor = T2.Instructor 
		order by courses
		For Xml Path ('')
	)
	, 1, 1, ''
)

From @T As T1 Group By Instructor
order by Instructor

--case4 --> PATINDEX (partern index)
/*PATINDEX definition - The PATINDEX function is used to get the first occurrence of a pattern from a string/expression. The function returns an integer value of where the pattern exists in the string if found otherwise it returns 0Parameterspattern - this is an expression like wildcards or other operators to find.expression - the string or expression we want to look for an occurrence.*/

use MyFirstDB
select * from Students

select STUFF (StudentEmail, PATINDEX ('%@%', StudentEmail), 1, '&') from Students
or
select STUFF (StudentEmail, PATINDEX ('%@%', StudentEmail), 1, '$') from Students

--Case --> CHARINDEX -- used for data masking
select StudentEmail, 
STUFF (StudentEmail, 1, CHARINDEX ('@', StudentEmail)-1, Replicate('*', Charindex('@', StudentEmail)-1))
As 'Masked Student Email'
from Students

/*==============JOINs=================*/
--Create Table Department--https://towardsdatascience.com/merging-tables-using-sql-a2e60ff687e9Use MyFirstDBCreate Table Department(	DepartmentId int Identity(1, 1) Not Null,	DepartmentName nvarchar(100))Insert into Department(DepartmentName)	Select 'Sales'Union All	Select 'Marketing'Union All	Select 'Technology'Union All	Select 'Finance'Union All	Select 'Operations'Select * from Department

--Create Table EmployeeNewUse MyFirstDBCreate Table EmployeeNew(	EmployeeId int Identity(1, 1) Not Null,	EmployeeName nvarchar(100) Not Null,	DepartmentId int,	ManagerId int)Insert into EmployeeNew(EmployeeName,[DepartmentId],[ManagerId])Select 'Employee 1', 1, NULLUnion AllSelect 'Employee 2', 1, NULLUnion AllSelect 'Employee 3', 2, NULLUnion AllSelect 'Employee 4', 2, 1Union AllSelect 'Employee 5', 2, 1Union AllSelect 'Employee 6', 3, 2Union AllSelect 'Employee 7', 3, 2Union AllSelect 'Employee 8', 4, 3Union AllSelect 'Employee 9', NULL, 3Union AllSelect 'Employee 10', NULL, 3Select * from EmployeeNewSelect * from Department/*===========Lab4====Inner Join=====*//*INNER JOIN - Returns records that have matching values in both tables*/select E.EmployeeID, E.EmployeeName, E.DepartmentId,D.DepartmentName from EmployeeNew Einner join Department DOn E.DepartmentId = D.DepartmentId/*========Lab5====Left Join===========*//*Return all records from the left table, and matching records from the right tableOn the right table, the matching data is returned in addition to NULL values where a record exists in the left table, but not in the right table*/select E.EmployeeID, E.EmployeeName, E.DepartmentId,D.DepartmentName from EmployeeNew Eleft outer join Department DOn E.DepartmentId = D.DepartmentId/*========Lab6====Right Join===========*//*Return all records from the right table, and the matched records from the left tableOn the left table, the matching data is returned in addition to NULL values where a record exists in the right table but not in the left table*/Select E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew ERight Outer JoinDepartment DOn E.DepartmentId = D.DepartmentId/*===========================*/--LAB 7 - Full Outer Join/*Returns all records when there is a match in either the left or right tablesCan be considered as a mix of inner, right and left outer joins*/Select E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew EFull Outer JoinDepartment DOn E.DepartmentId = D.DepartmentId/*===========================*/--LAB 8 - Cross Join/*Returns all records when there is a match in either the left or right tablesCan be considered as a mix of inner, right and left outer joins*/Select E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew ECross JoinDepartment D-- 5 * 10 = 50 rows--LAB 9 - Self JoinSelect E.EmployeeId, E.EmployeeName, E.DepartmentId, E.ManagerId, D.EmployeeName As ManagerName from EmployeeNew EJoinEmployeeNew DOn E.ManagerId = D.EmployeeId/*===========================*/--Special Cases (exclusion)--LAB 10 - Left Outer Join with exclusionSelect E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew ELeft Outer JoinDepartment DOn E.DepartmentId = D.DepartmentIdWhere E.DepartmentId Is Null/*===========================*/--interview--LAB 11 - Right Outer Join with exclusionSelect E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew ERight Outer JoinDepartment DOn E.DepartmentId = D.DepartmentIdWhere E.DepartmentId Is Null/*===========================*/--LAB 12 - Full Outer Join with exclusionSelect E.EmployeeId, E.EmployeeName, E.DepartmentId, D.DepartmentName from EmployeeNew EFull Outer JoinDepartment DOn E.DepartmentId = D.DepartmentIdWhere E.DepartmentId Is NullOr D.DepartmentId Is Null--Solutions to Week 6 Assignment
/*Assignment 1Use AdventureWorks for the following problem:Use Person.BusinessEntityContact, Person.Person and Person.ContactType tables and write a query to (Hint:Use Inner Join)- Return BusinessEntityID, LastName, and FirstName columns- Provide a list of 'Purchasing Manager’ contacts- Sort the result set by LastName, and FirstName ASC*/use AdventureWorks2022Select pp.BusinessEntityID, LastName, FirstName    From Person.BusinessEntityContact As pbec         Inner Join Person.ContactType As pct            On pct.ContactTypeID = pbec.ContactTypeID        Inner Join Person.Person As pp            On pp.BusinessEntityID = pbec.PersonID    Where pct.Name = 'Purchasing Manager'    Order By LastName, FirstName/*============================================*//*Assignment 2Use AdventureWorks for the following problem:Use Person.BusinessEntityContact, and Person.ContactType tables and write a query to (Hint:Use Inner Join)- Return ContactTypeID, ContactTypeName and BusinessEntityContact- Count the number of contacts for each Type and Name- Filter the output for those who have 75 or more contacts*/Select pct.ContactTypeID, pct.Name As ContactTypeName, COUNT(*) As 'Contact Availability'    From Person.BusinessEntityContact As pbec        Inner Join Person.ContactType As pct            On pct.ContactTypeID = pbec.ContactTypeID    Group By pct.ContactTypeID, pct.Name	Having COUNT(*) >= 75    Order By COUNT(*)/*==================================================*//*Assignment 3Use AdventureWorks for the following problem:Use Production.Product table and write a query to (Hint:Union All)- Return Name, Color and ListPrice- Generate a list of all products that are Black or Silver in color.- Sort the result set by the ListPrice columnNote: When name of a column is similar to a reserved keyword, then you can enclose the name of the column in square braces as seen below for [Name]*/--See above noteSelect Name, Color, ListPrice  From Production.Product  Where Color = 'Black'  Union All  Select [Name], Color, ListPrice  From Production.Product  Where Color = 'Silver'  Order By ListPrice Desc/*==================================================*//*Assignment 4Use AdventureWorks for the following problem:Use Production.Product and Sales.SalesOrderDetail tables and write a query to (Hint:Use Left Outer Join)- Return the Product Name and SalesOrderID- Return both ordered and unordered products in the inventory*/Select pp.Name, sod.SalesOrderID  From Production.Product As pp  Left Outer Join Sales.SalesOrderDetail As sod  On pp.ProductID = sod.ProductID  Order By pp.Name Asc/*==================================================*//*Assignment 5Use AdventureWorks for the following problem:Use Sales.SalesTerritory and Sales.SalesPerson tables and write a query to (Hint:Use Right Outer Join)- Return TerritoryName and BusinessEntityID- Generate a list of all SalesPeople irrespective of assigned territory*/Select st.Name As SalesTerritoryName, sp.BusinessEntityID  From Sales.SalesTerritory As st   Right Outer Join Sales.SalesPerson As sp  On st.TerritoryID = sp.TerritoryID