/*======================Week10================*/
/*=========Import Export================*/
/*===========EXCEPTION HANDLING=================*/

--LAB 1
--Example 1
--Divide by zero exception
--First type select 5/0
Select 5/0
--Then wrap it in a try catch
Begin Try
	Select 5/0
End Try
Begin Catch
	Select
		@@ERROR As Error,
		ERROR_NUMBER() As ErrorNumber,
		ERROR_SEVERITY() As ErrorSeverity,
		ERROR_STATE() As Errorstate,
		ERROR_PROCEDURE() As ErrorProcedure,
		ERROR_LINE() As ErrorLine,
		ERROR_MESSAGE() As Errormessage
End Catch

--Example 2
--Step 1 - Type this block
Declare @name nvarchar(50)
Declare @comp numeric (8,2)
	Set @name = 'John'
	Set @comp = 100000
		Print @name + 'Compensation is ' + @comp
		--End type block
--Now enclose it in a try catch
--Variable @name has been replaced by @name2; likewise @comp2
Begin Try
	Declare @name2 nvarchar(50)
	Declare @comp2 numeric (8,2)
		Set @name2 = 'John'
		Set @comp2 = 100000
			Print @name2 + 'Compensation is ' + @comp2
End Try
	Begin Catch
		Select
		@@ERROR As Error,
		ERROR_NUMBER() As ErrorNumber,
		ERROR_SEVERITY() As ErrorSeverity,
		ERROR_STATE() As Errorstate,
		ERROR_PROCEDURE() As ErrorProcedure,
		ERROR_LINE() As ErrorLine,
		ERROR_MESSAGE() As Errormessage
	End Catch

-- General Info
Select * from sys.messages
Select * from sys.messages where language_id=1033

--Case 3 - Filter data while Importing files in SQL Server
--Select * from ProductsTest
--Testing where clause
--make sure you use an existing table as desination
--Select * from [Sheet1$] Where ProductID>10

Select * from ProductInfo

--Example 2
--What happens when we try to import with the box unchecked
Select * from Sheet1$
Select * from MyCountry2

--Example 3 
--Importing multiple worksheets
Select * from Products
Select * from Countries
Select * from Customers

--Example 4
--Flat file
Select * from ProductListCSV


--Example 5
--Import from another SQL Server
Select * from Students

/*============================*/--LAB 3 - EXPORTING DATA--To Excel--To flat file--To SQL ServerUSE ImportExportDBSelect * from ProductInfo--Filtering (Select * from Products Where ProductID>10)Select * from ProductInfo Where ProductID>10/*============================*/--LAB 4 - BULK INSERTUSE ImportExportDBCreate Table ProductsBulk(	ProductID int,	ProductName nvarchar (250))Select * from ProductsBulk--1 using flat fileBulk insert ProductsBulkFrom 'C:\indu\sql_server\avtech_jan24\Week10\import\ProductInfo.txt'With(FirstRow = 2,/*======-,;:-tab (t)======*/FieldTerminator = ',',RowTerminator = '\n')--Select * from ProductsBulk--Delete from ProductsBulk--2 using CSVBulk insert ProductsBulkFrom 'C:\indu\sql_server\avtech_jan24\Week10\import\ProductListCSV.csv'With(FirstRow = 2,FieldTerminator = ',',RowTerminator = '\n')--Select * from ProductsBulk--Delete from ProductsBulk--3 using SP (stored procedure)Create Procedure InsertData	@Path varchar(500),	@TableName varchar(50)AS	Declare @sql nvarchar(1000)Begin	Select @sql='Bulk Insert '+@TableName+' From''';	Select @sql=@sql+@Path;	Select @sql=@sql+'''With	(Firstrow=2,Fieldterminator='','',Rowterminator=''\n'')';exec(@sql)End--nextInsertData'C:\indu\sql_server\avtech_jan24\Week10\import\ProductInfo.txt','ProductsBulk'Select * from ProductsBulk--4 using JSON files/*
Step 1: Use of OPENROWSET(BULK) to load contents of json file
It is a table-valued function that can read data from any file.
It returns a table with a single column that contains all the contents of the file. 
It can just load the entire contents of a file as a text value. 
(This single large value is known as a single character large object or SINGLE_CLOB.)

For Json file use this link - https://petition.parliament.uk/petitions.json?state=open
*/

/*=====================*/
Declare @Json nvarchar(max)

Select @Json = BulkColumn
From OpenRowSet (Bulk 'C:\indu\sql_server\avtech_jan24\Week10\import\petitions.json', Single_Clob) import
Select * into MyJsonTable
From OpenJson (@Json,'$.data')
With
(type nvarchar(50),id int, 
Link nvarchar(4000) '$.links.self',
action nvarchar(4000) '$.attributes.action', 
background nvarchar(4000) '$.attributes.background', 
PetitionStatus nvarchar(50) '$.attributes.state', 
signature_count int '$.attributes.signature_count', 
CreatedDate nvarchar(50) '$.attributes.created_at'
) as Dataset
Go


Select * from MyJsonTable
/*===============================*/

--Lab 5 - Cursor
--Will loop through each row in a table
--Used for dealing with each record in the result of a SELECT statement by looping through them

--Lifecycle --> declare,  open, fetch, close, deallocate
--have to fetch data using cursor and store it in local variables

--To demo cursor select to run from here
--START - SELECT FROM HERE
Declare @Temp table (StudentId int, StudentName nvarchar(50))

Insert into @Temp values ('51', 'John')
Insert into @Temp values ('52', 'Jane')
--Note - variable here is @StudentID
Declare @StudentId int, @StudentName nvarchar(50)
	
	Declare MyCursor cursor for
		Select StudentId, StudentName from @Temp
	Open MyCursor

	Fetch next from MyCursor into @StudentId, @StudentName
		While @@Fetch_Status = 0
			Begin
			--Print @StudentName
		Print @StudentName + ' Whose StudentId is ' + Cast(@StudentID as nvarchar(50))

Fetch next from MyCursor into @StudentId, @StudentName
	End
Close MyCursor
	Deallocate MyCursor

		--Uses of cursors
--1. In concurrent queries
--2. Similar to a foreach loop
--3. Use sparingly due to performance issues

/*=====================*/
--TABLE VARIABLE

--LAB 6

--To Create a Table Variable
--First, do a select * in Employee and Department tables and then do the table variable
Use MyFirstDB
Select * from EmployeeNew
Select * from Department
---code below 

/*
1.Table variables (@table) are created in memory while a Temporary table (#temp) is created in the tempdb database. 
However, if there is a memory pressure the pages belonging to a table variable may be pushed into tempdb.

2.Table variables cannot be used in transactions, logging or locking. This makes @table faster then #temp. 
Table variables are thus faster than temp tables.

3.Temporary tables permit Schema modifications unlike Table variables
*/
--We will try to create a Table variable and insert records into the table
--START RUNNING the code here
Declare @EmployeeCount Table
(DepartmentName nvarchar(50), DepartmentId int, TotalEmployees int)

--In the code below, we are just saying DepartmentName because that column is only present in Department table
--But you have to specify D.DepartmentId because that column is present in both tables
--Make sure there is a comma after D.DepartmentId... if not it will not work
Insert Into @EmployeeCount

	Select DepartmentName, D.DepartmentId,
		Count(*) As EmployeesInEachDepartment
From EmployeeNew E
	Inner Join Department D
	on E.DepartmentId = D.DepartmentId
		Group By DepartmentName, D.DepartmentId
--End copy for next Lab (7)  here
Select * from @EmployeeCount
--END RUNNING CODE
--The Select * has to be run along with the code for the table variable
--We have done lab exercises on Temp Tables(last week)
--Please check those exercise to compare and contrast
--Temp Tables and Table Variables
/*
Differences
When creating the Temp table you have to start with 'Create table followed by #
but in case of table variable you have to declare some variable as table
1. Performance - Table variables are faster than temp tables
2.Destroy - Once you create a temp table you have to drop it.  But the dropping is not required for table variables.
3.Parameter - Table variable can be passed as parameter to a stored procedure or to a function.  
You can't pass temp table as a parameter o a stored procedure or to a function.
*/ 
/*=============================*/
--DERIVED TABLE
--Lab 7
--... similar to a subquery... they are created on the fly
--Using the table that we used above
--Copy this from above
Select DepartmentName, D.DepartmentId,
		Count(*) As EmployeesInEachDepartment
From EmployeeNew E
	Inner Join Department D
	on E.DepartmentId = D.DepartmentId
		Group By DepartmentName, D.DepartmentId
--Run the above code, it will show a result

--Now, let's enclose this in a query
--Select * from or use column names
--Copy the code from above... enclose it within brackets
--Type one line before the parenthesis
--Type one line after the parenthesis
Select DepartmentName, DepartmentId,EmployeesInEachDepartment from
	(Select DepartmentName, D.DepartmentId,
			Count(*) As EmployeesInEachDepartment
	From EmployeeNew E
		Inner Join Department D
		on E.DepartmentId = D.DepartmentId
			Group By DepartmentName, D.DepartmentId)
EmployeeCount where EmployeesInEachDepartment > 1
--after running the above code add the line below and say you can sort it as well just like a table
Order By EmployeesInEachDepartment Asc
--Before order by the EmployeesInEachDept will be descnding but
--after order by it will be ascending
 
 /*=============================*/
 --COMMON TABLE EXPRESSIONS (CTE)
 --Lab 8
 --Pagination
 Use ImportExportDB
 Select * from Products
 --Then create a SP
Create Procedure GetProducts
	@PageNumber int,
	@PageSize int
As
	Declare @TotalCount int
	Declare @TotalPageNumber int
Begin
	Select @TotalCount=Count(ProductId) from Products
	Set @TotalPageNumber=@TotalCount/@PageSize
		If(@PageSize*@TotalPageNumber)<@TotalCount
			Begin
				Set @TotalPageNumber=@TotalPageNumber+1
			End
		Select @TotalCount As TotalCount,@TotalPageNumber As TotalPageNumber;
		--make sure there is a semi-colon here, if not it throws an error
			With pg As
			(
				Select ProductId from Products Order By ProductId
				Offset @PageSize*(@PageNumber-1) Rows
				Fetch next @PageSize Rows Only
			)
		Select * from Products As c Where Exists(Select 1 from pg Where pg.ProductId=c.ProductId)
	Order By c.ProductId option (recompile)
End
--
--Next, run the SP
--To run the above SP, provide the page # and the # of records to be displayed on each page
--To get users on page 1
GetProducts 1, 3  
--To get users on page 2
GetProducts 2, 3 
--To get users on page 3
GetProducts 3, 3 
--To get users on page 4 (it will not return anything since there is nothing on page 4)
GetProducts 4, 3 
/*===========================*/
--Case 2 - CTE
--Lab 9
Use MyFirstDB
With
	EmployeeCount (DepartmentName, DepartmentId, EmployeesInEachDepartment)
As
(Select DepartmentName, D.DepartmentId,
			Count(*) As EmployeesInEachDepartment
	From EmployeeNew E
		Inner Join Department D
		on E.DepartmentId = D.DepartmentId
			Group By DepartmentName, D.DepartmentId)
Select DepartmentName, DepartmentId, EmployeesInEachDepartment from EmployeeCount
/*===========================*/
--SPATIAL DATATYPES
--Lab 10
--Create a Table called SpatialDataTable
--Create columns called SpatialData

Create Table SpatialDataTable
(
	SpatialDataColumn geometry
)
--then insert values
--remember there is a comma in each line after values
--remember polygon has two opening braces and two closing braces
Insert Into SpatialDataTable(SpatialDataColumn)
Values
('Point(8 12)'),
('Linestring(0  0, 10 12)'),
('Polygon((0 0, 8 6, 9 7, 10 1, 0 0))')

Select * From SpatialDataTable
/*
The above Select * is not pretty, so we have to convert it to text as follows
*/
Select SpatialDataColumn.ToString() As 'SpatialDataString', 
SpatialDataColumn.AsGml() As 'SpatialXmlText'
From SpatialDataTable

--====================================
--GFS (Grandfather/Father/Son) backup - Grandfather once in month, Father once in week, Son everyday
--Backup in computer
--Full back upBackUp Database ImportExportDB to Disk = 'C:\indu\sql_server\avtech_jan24\Week10\DBbackup\DB_full.bak'

--Differntial backup - to have different data
--Incremental backup
BackUp Database ImportExportDB to Disk = 'C:\indu\sql_server\avtech_jan24\Week10\DBbackup\DB_diff.bak'With differential

--========================================
--To restore database from GUI

/*========================================
==========================================
==========================================*/

--LAB 11 - Transpose rows into columns
--We will not only transpose but also sort by country and order by Country
Create Table TouristDestinations
(
	CountryName nvarchar(100),
	CityName nvarchar(100)
)

Insert into TouristDestinations values('USA','Edison')
Insert into TouristDestinations values('USA','New York')
Insert into TouristDestinations values('USA','California')
Insert into TouristDestinations values('Canada','Ottawa')
Insert into TouristDestinations values('Canada','Montreal')
Insert into TouristDestinations values('Canada','Toronto')
Insert into TouristDestinations values('UK','London')
Insert into TouristDestinations values('UK','Liverpool')
Insert into TouristDestinations values('UK','Bristol')

Select * from TouristDestinations

--Code below for Transpose
--start running code from here
Select CountryName, CityName1, CityName2, CityName3
From(
	Select [CountryName],[CityName],
	'CityName'+
	cast(row_number() over(partition by CountryName order By CountryName)
		As nvarchar(50)) ColumnSequence
		from TouristDestinations
) Temp
Pivot
(
	max(CityName)
	for ColumnSequence in (CityName1, CityName2, CityName3)
)Piv
--end running code

--===============================
/*===========================*/

--LAB 12 - How to find SQL Server Instance

/*
1. GO to Connection Window. Server Name is the SQL Server instance.  
2. Type Select @@ServerName
*/

Select @@ServerName


/*===========================*/
--LAB 13 - How to get all Objects
--Use database name
Select * from Sys.Objects Where schema_id = Schema_id('dbo')
/*===========================*/

--LAB 14 - How to get Table details

--Use database name
Use MyFirstDB
Select * from Sys.Objects Where schema_id = Schema_id('dbo') 
and type_desc = 'USER_TABLE'
/*===========================*/
--LAB 15 - How to get View details
--Use database name
Use MyFirstDB
Select * from Sys.Objects Where schema_id = Schema_id('dbo')
and type_desc = 'View'

/*===========================*/
--LAB 16 - How to get Scalar function details

--Use MyFirstDB
SELECT * FROM sys.objects WHERE schema_id = SCHEMA_ID('dbo')
and type_desc='SQL_SCALAR_FUNCTION'

/*===========================*/
--LAB 17 - How to get SP details

Use MyFirstDB
Select * from Sys.objects Where schema_id = schema_id('dbo')
And type_desc = 'SQL_STORED_PROCEDURE'