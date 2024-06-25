/*======================Week9================*/
--Indexes
--Indexes are used to speed-up query process in SQL Server, 
--resulting in high performance.
--Clustered And Non Clustered Indexes
--LAB 1
-- Case 1 - Clustered Index (CI)
--CI - value type
/*
Defines the order in which data is physically stored 
in a table. Table data can be sorted in only way, 
therefore, there can be only one CI per table. 
In SQL Server, the primary key constraint 
automatically creates a CI on that particular column.
*/
 
Use MyFirstDB

Create Table EmployeePhoneBook
(
	EmployeeName nvarchar(250) Not Null,
	EmployeePhone int Not Null
)
Create Clustered Index IX_EmployeePhone_CI
On EmployeePhoneBook(EmployeeName, EmployeePhone)

-- Case 2 - Non-Clustered-Index(NCI)--
--NCI - reference type
/*
A NCI doesn’t sort the physical data 
inside the table. In fact, a NCI is stored at 
one place and table data is stored in another place. 
This is similar to a textbook where the book content 
is located in one place and the index is located 
in another. This allows for more than one NCI 
per table.
*/

Create NonClustered Index IX_EmployeeName_NCI
On EmployeePhoneBook(EmployeeName)
Include (EmployeePhone)

--Or

Create NonClustered Index IX_EmployeePhone_NCI
On EmployeePhoneBook(EmployeeName, EmployeePhone)
Where (EmployeeName >= 'xyz')
/*=================*/
--Build in funtions
--Lab2
--1 concatenantion addition
--case1
select Concat ('Joh', 'n')

--case2
use myfirstdb
select * from students

select concat (Studentid, '-',studentname) from students

--case2
select 'Jan'+'e'
select Concat ('Joh', 'n')

--2 Datalenght
select DATALENGTH('What a beautiful day ')

--3 Lenght
select LEN('What a beautiful day ')

--4 Left
select left('How are you?', 5) as my_result
select left('How are you?', 5) as 'my result'
select left('How are you?', 5) as 'my results are'

--5 Lower
select lower('How are you?') as 'my result'

--6 upper
select upper('How are you?') as 'my result'

--7 LTRIM
select ltrim('  How are you?') as 'my result'

--8 RTRIM
select rtrim('How are you?  ') as 'my result'

/*=======Build IN FUNCTIONS========*/

--9 NCHAR
--66 is for letter 'B'
select nchar(66)

--10 Patindex
--case1
select patindex ('%SQL%', 'Welcome to SQL Server class')
--case2
select patindex ('%SQLL%', 'Welcome to SQL Server class')
select patindex ('%SQL S%', 'Welcome to SQL Server class')
--case3
select patindex ('%[SQL]%', 'Welcome to SQL Server class')
--case4
select patindex ('%S_L%', 'Welcome to SQL Server class')
--case5
select patindex ('%S__%', 'Welcome to SQL Server class')
--case6
select patindex ('%[◘SQL]%', 'Welcome to SQL Server class')

--charindex
select charindex('Server', 'Welcome to SQL Server Class')
select charindex('day', 'what a beutiful day')

--replace
select replace('Microsoft SQL Server class', 'SQL Server', 'C#')

select * from students
select replace(StudentAddress, 'Street3', 'Stelton Road') from students
select replace(studentname, 'John', 'John Smith') + 
str(Studentid) + ' ' + str(age) from studentinfo6

--substring
select substring('what a day', 1,5)

--stuff - insert
select stuff('what a beautiful day', 17, 1, ' summer ')

--numeric function
--avg
select avg(age) as 'average age' from studentinfo6
--sum
select sum(age) as 'total age' from studentinfo6
--absolute
select abs(-123.4)
--ceiling
select ceiling(30.75)
--floor-round up
select floor(30.75)
--rand - randam number to generate
select rand()
--return a random number >=5 and <10:
select floor(rand()*(10-5+1)+5)

--Date
select getdate()
select dateadd(month, 1, '06/12/2022')
select dateadd(year, 1, '06/12/2022')
select dateadd(day, 1, '06/12/2022')

select dateadd(month, -1, '06/12/2022')
select dateadd(year, -1, '06/12/2022')
select dateadd(day, -1, '06/12/2022')

--Date difference
select datediff(year, '2013/03/04', '2022/03/04')
select datediff(month, '2013/03/04', '2022/03/04')
select datediff(hour, '2013/03/04', '2022/03/04')

--cast
select cast(15.12 as int)
select cast(15.12 as varchar)
select cast('2018/03/04' as datetime)

--Convert with dates
--default
select convert(varchar, getdate(), 101) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy
--US
select convert(varchar, getdate(), 101) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy
--ANSI
select convert(varchar, getdate(), 102) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy
--UK/French
select convert(varchar, getdate(), 103) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy
--German
select convert(varchar, getdate(), 104) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy
--Italian
select convert(varchar, getdate(), 105) as
withyy,convert(varchar, getdate(), 1) as
withoutyyyy

--convert to money
select convert(varchar, cast(1234567 as money), 1)

--coalesce
select coalesce(null,'X', 'Y', 'Z')

--Isdate
select isdate('2009-09-27')
--return 1 mean valid number
select isnumeric('20090927')
select isnumeric('some hello')

--nullif
select nullif('SQL', 'Server')
select nullif('SQL', 'SQL')

/*=======User Defined FUNCTIONS========*/
--Lab3 
--scalar funtion
--Left dropdown Programmability>>>functions
use myfirstdb
create function findsum(@number1 int, @number2 int)
	returns int
		As
			Begin
				Declare @sum int
				set @sum = @number1 + @number2
				Return @sum
			End
--call the function
select dbo.findsum(10,5)

/*=======Table valued FUNCTIONS========*/
/*============================*/
--LAB 4 - TABLE VALUED FUNCTIONS
--
Use MyFirstDB
Select * from Students

--Note: No BEGIN END clause for table valued functions

Create Function UdfStudentsTest(@StudentAddress nvarchar(50))
	Returns Table
		As
			Return
			(
				Select * from Students
				Where StudentAddress = @StudentAddress
			)

--Step 2 - call the function
Select * from dbo.UdfStudentsTest('220 main')
--Or
Select * from dbo.UdfStudentsTest('Street4')

/*==========TEMP TABLES =========================*/
/*
Two types - local and global
Temp table stored in Databases>>system databases>>>tempdb>>Temporary Tables
*/
--Local table is used by who created and Global table is used by everyone
--Local Global Temp table is active for the session and will be removed after session is endede.
--will one # sign
/*
1.Stored in tempdb
2.Local temp tables are available only to session that created them
3.Automatically destroyed at termination of procedure or session
3a.just want to do some temporary calculation and then drop the table
4.Prefixed with #table_name
5.Can be created with same name in multiple windows
6.Then drop the table since we cannot use the table if it is still there in memory
*/

--Local temp table need to have '#'
--LAB 5
Create Table #Employee
(
	EmployeeID int,
	EmployeeName nvarchar(100),
	DepartmentID int,
	ManagerID int
)

--Insert records into temp table
Insert into #Employee(EmployeeID, EmployeeName, DepartmentID, ManagerID)
Values(1, 'John', 10, 3 )

Select * from #Employee

-- insert another record

Insert into #Employee(EmployeeID, EmployeeName, DepartmentID, ManagerID)
Values(2, 'Jane', 12, 4 )

--Can run sql queries like a normal table

Select Top 1 EmployeeID, EmployeeName, DepartmentID, ManagerID from #Employee

-- To drop the temp table

Drop Table #Employee


/*===================================*/

--Global Temp Tables
--LAB 6

/*
1.Also stored in tempdb
2.Available to all sessions and users
3.Dropped automatically when the last session using 
temp table has completed
4.Prefix with ##Table_Name
*/
--Table will have two # sign '##'
Create Table ##Employee
(
	EmployeeID int,
	EmployeeName nvarchar(100),
	DepartmentID int,
	ManagerID int
)

Insert into ##Employee(EmployeeID, EmployeeName, DepartmentID, ManagerID)
Values(1, 'David', 10, 3 )

Select * from ##Employee

-- insert another record

Insert into ##Employee(EmployeeID, EmployeeName, DepartmentID, ManagerID)
Values(2, 'Mary', 12, 4 )

-- You can delete from a temp table

Delete from ##Employee

--To drop a global temp table

Drop Table ##Employee


/*=========VIEWS==========================*/
--LAB 7 - VIEWS
--Left menu stored in myfirstdb>>>Views
Select * from Students

Create View [StudentsView]
As
	Select StudentID, StudentName, StudentAddress, StudentEmail 
	from Students
	Where StudentID = 106

Select * from StudentsView

--To rename a View

sp_rename StudentsView, StudentsViewNew

Select * from StudentsViewNew

--To refresh a View

Execute sp_refreshview StudentsViewNew

--To schemabind a view

Create View dbo.ViewName
With schemabinding
As
Select StudentID, StudentName, StudentAddress, StudentEmail 
	from Students
	Where StudentID = 106

/*
--INTERVIEW
--Schemabinding is an interview question
--Schemabinding --> Binds the view to the schema of the underlying table or tables.  
--When schemabinding is specified, the base table or tables cannot be modified in a way 
--that would affect the view definition

--Can we use temp table in view?
/*
No, a view consists of a single Select statement. 
You cannot create or drop tables in a view. ... CTEs are temporary result sets that are 
defined within the execution scope of a single statement and they can be used in views.
Which is better CTE or temp table?
A temp table is good for re-use or to perform multiple processing passes on a set of data. 
A CTE can be used either to recurse or to simply improved readability.
*/
*/

/*===========TRIGGERS=================*/
--LAB 8
--DML Trigger
--DML - data in tables
--Types of DML Triggers
--a. AFTER Trigger (executes after the action)
--b. INSTEAD OF Triggers

Select * from StudentInfo2

Create Trigger TableStudentInfo2Safety
On StudentInfo2
	For
		Insert, Update, Delete
		As
			Print 'You do not have permissions to Insert, Update or Delete'
		Rollback

--STORED in left menu @ MyFirstDB>>>Tables>>>Triggers>>>Tigger Table

Select * from StudentInfo2

--Insert a value

Insert into StudentInfo2(StudentName) Values('David')
--will have message "You do not have permissions to Insert, Update or Delete"
---How to disable trigger>>>>right click tigger and select disable

/*======================================*/
--LAB 9
--DDL Trigger
--DDL - Tables

Create Database DDLSafetyDatabase

--Trigger to stop creating tables inside the DB

Create Trigger TableStopCreateSafety
on DDLSafetyDatabase
	For 
		Create_Table, Alter_Table, Drop_Table
	As
		Print 'You do not have permissions to modify a database'
	Rollback


	--Trigger Assignments
/*============================*/
--Assignment 1 - Audit Table
--Step 1 - Create the two tables - s copy code from here
Create Table CustomerInfo
(
	CustomerID int Identity(1,1),
	CustomerName nvarchar(200),
	CustomerAddress nvarchar(200),
	CustomerPhone numeric
)
Create Table CustomerInfoAudit
(
	AuditID int Identity(1,1),
	CustomerID int,
	CustomerName nvarchar(200),
	CustomerAddress nvarchar(200),
	CustomerPhone numeric,
	ActionType char(1),
	CreatedDate Datetime
)
--Step 2- Create an After Insert Trigger
Create Trigger trgCustomerInfoAudit on CustomerInfo
After Insert 
As
	Begin
		Declare @CustomerID int
		Declare @CustomerName nvarchar(200)
		Declare @CustomerAddress nvarchar(200)
		Declare @CustomerPhone numeric
		Declare @ActionType char(1)
	
		Select @CustomerID=i.CustomerID,@CustomerName=i.CustomerName, @CustomerAddress=i.CustomerAddress,
		@CustomerPhone=i.CustomerPhone from Inserted i

		Set @ActionType ='I'

		Insert into CustomerInfoAudit(CustomerID,CustomerName,CustomerAddress,CustomerPhone,ActionType,CreatedDate)
		Values(@CustomerID,@CustomerName,@CustomerAddress,@CustomerPhone,@ActionType,GETDATE())
	End
	--Step 3- Insert a value into CustomerInfo table
Insert into CustomerInfo(CustomerName, CustomerAddress, CustomerPhone)
values ('John', '123 street, Edison, NJ', 7321234567)
--Then check the inserted values
Select * from CustomerInfo
Select * from CustomerInfoAudit
--Insert another record
Insert into CustomerInfo(CustomerName, CustomerAddress, CustomerPhone)
values ('Jane', '456 street, Edison, NJ', 9081234567)
--Step 4- Do a Select * from both the tables
Select * from CustomerInfo
Select * from CustomerInfoAudit
--Step 5 - Create an AFTER UPDATE Trigger
Create Trigger trgCustomerInfoAuditUpdate on CustomerInfo
After Update 
As
	Begin
		Declare @CustomerID int
		Declare @CustomerName nvarchar(200)
		Declare @CustomerAddress nvarchar(200)
		Declare @CustomerPhone numeric
		Declare @ActionType char(1)
	
		Select @CustomerID=i.CustomerID,@CustomerName=i.CustomerName, @CustomerAddress=i.CustomerAddress,
		@CustomerPhone=i.CustomerPhone from Inserted i

		Set @ActionType ='U'

		If Not Update(CustomerName)
			Begin
				Set @CustomerName = Null
			End
		If Not Update(CustomerAddress)
			Begin
				Set @CustomerAddress = Null
			End
		If Not Update(CustomerPhone)
			Begin
				Set @CustomerPhone = Null
			End
		Insert into CustomerInfoAudit(CustomerID,CustomerName,CustomerAddress,CustomerPhone,ActionType,CreatedDate)
		Values(@CustomerID,@CustomerName,@CustomerAddress,@CustomerPhone,@ActionType,GETDATE())
	End
	--Step 6 - Next, update a record; just run the next line
Update CustomerInfo set CustomerName='John New' where CustomerID = 1
	--Then do a select * from both tables
Select * from CustomerInfo
Select * from CustomerInfoAudit
	--Step 7- AFTER DELETE Trigger - copy code from next line until the End statement
Create Trigger trgCustomerInfoAuditDelete on CustomerInfo
After Delete 
As
	Begin
		Declare @CustomerID int
		Declare @CustomerName nvarchar(200)
		Declare @CustomerAddress nvarchar(200)
		Declare @CustomerPhone numeric
		Declare @ActionType char(1)
	
		Select @CustomerID=i.CustomerID,@CustomerName=i.CustomerName, @CustomerAddress=i.CustomerAddress,
		@CustomerPhone=i.CustomerPhone from Deleted i

		Set @ActionType ='D'

		Insert into CustomerInfoAudit(CustomerID,CustomerName,CustomerAddress,CustomerPhone,ActionType,CreatedDate)
		Values(@CustomerID,@CustomerName,@CustomerAddress,@CustomerPhone,@ActionType,GETDATE())

	End
	--Step 8 - Next, delete a record
Delete from CustomerInfo where CustomerID = 1
	--Step 9
Select * from CustomerInfo
Select * from CustomerInfoAudit

/*============================*/
--Assignment 2 - Setting limits on Working hours and Payment data entries
--Step 1 - Create the Table
Create Table ContractorPayment
(
	ContractorID int,
	WorkingHours int,
	HourlyRate decimal (10,2),
	ContractorPayment decimal (10,2),
	CreatedDate datetime
)
--Step 2 -- INSTEAD OF Insert Trigger
Create Trigger trgContractorPayment On ContractorPayment
Instead Of Insert
As 
	Begin
		Declare @ContractorID int
		Declare @WorkingHours int
		Declare @HourlyRate decimal(10,2)
		Declare @ContractorPayment decimal(10,2)
			
Select @ContractorID=i.ContractorID, @WorkingHours=i.WorkingHours, @HourlyRate=i.HourlyRate, @ContractorPayment=i.ContractorPayment from Inserted i

	If @WorkingHours>8
		Begin
			RAISERROR('Working hours cannot be greater than 8', 16,1)
		End
	Else
		Begin
			If Not Exists(Select CreatedDate From ContractorPayment Where Convert(varchar,CreatedDate,101)=Convert(varchar,GETDATE(),101) And ContractorID=@ContractorID)
			
				Begin
					Set @ContractorPayment = @WorkingHours * @HourlyRate

					If @ContractorPayment > 300
						Begin
							RAISERROR('Payment cannot exceed $300', 16,1)
						End
					Else
				Begin
					Insert into ContractorPayment(ContractorID, WorkingHours, HourlyRate,ContractorPayment,CreatedDate)
					Values(@ContractorID, @WorkingHours, @HourlyRate,@ContractorPayment,GETDATE())
				End
			End

			Else
				Begin
					RAISERROR('Payment record already exists', 16, 1)
				End
		End
	End
--Step 3 - --Insert a record and do a select *-- code works despite squiggly
	Insert into ContractorPayment(ContractorID,WorkingHours,HourlyRate) 
	Values(1, 8, 25)

	Select * from ContractorPayment

	--Step 4- --Insert another record with working hours more than 8
	--10 will not go through as it is more than 8
	Insert into ContractorPayment(ContractorID,WorkingHours,HourlyRate) 
	Values(1, 10, 25)

	--Step 5 - --Insert another record with hourly rate of $40 - it will not go through
	--as payment cannot exceed $300
	Insert into ContractorPayment(ContractorID,WorkingHours,HourlyRate) 
	Values(2, 8, 40)

	--Step 6 - --Try inserting the first record once again
	--will not go through as record already exists
	Insert into ContractorPayment(ContractorID,WorkingHours,HourlyRate) 
	Values(1, 8, 25)

	--Step 7 - Instead of Update Trigger
Create Trigger trgContractorPaymentUpdate On ContractorPayment
Instead Of Update
As 
	Begin
		Declare @ContractorID int
		Declare @WorkingHours int
		Declare @HourlyRate decimal(10,2)
		Declare @ContractorPayment decimal(10,2)
			
Select @ContractorID=i.ContractorID, @WorkingHours=i.WorkingHours, @HourlyRate=i.HourlyRate, @ContractorPayment=i.ContractorPayment from Inserted i

	If @WorkingHours>8
		Begin
			RAISERROR('Working hours cannot be greater than 8', 16,1)
		End
	Else
		Begin
			Set @ContractorPayment = @WorkingHours * @HourlyRate

			If @ContractorPayment > 300
				Begin
					RAISERROR('Payment cannot exceed $300', 16,1)
				End
					Else
				Begin
					Update ContractorPayment Set WorkingHours=@WorkingHours, HourlyRate = @HourlyRate, ContractorPayment = @ContractorPayment
					Where Convert(varchar,CreatedDate,101)=Convert(varchar,GETDATE(),101) And ContractorID=@ContractorID
				End
			End
	End

--Step 8 - --Next, update the record -- MAKE SURE YOU PUT THE CREATED DATE AS THAT DAY OF THE CLASS
--as what shows up in the table on select *
	Update ContractorPayment Set WorkingHours=8, HourlyRate=20.50 Where Convert(varchar,CreatedDate,101)='07/09/2022' And ContractorID=1
	Select * from ContractorPayment/*===============================*/
--BUILT-IN FUNCTIONS
--LAB 2
--1. Concat
--Case 1
Select Concat ('Joh','n')

--Or
--Case 2
Use MyFirstDB

Select * from Students

--Now let's change it to
Select Concat (StudentID,' ',StudentName ) 
from Students

--Or
--Note space before and after the hyphen

Select Concat (StudentID,' - ', StudentName ) 
from Students

-- or use colon as a separator
Select Concat (StudentID,' : ', StudentName ) 
from Students

--Case 3
--Concat with +
Select 'Jan'+'e'

--2. DataLength
Select DATALENGTH('What a beautiful day ')
-- Gives the length of an expression in bytes
--note extra space after day
--Answer will be 21 as it counts space after day

--3.Length
Select LEN('What a beautiful day ')
-- Gives the length of the character used,
--instead of length of the bit and excludes trailing spaces
--Answer will be 20 since it removes the trailing space after day

--4.Left
--Will start from the Left and stop at 5 spaces
Select LEFT('How are you?', 5) AS My_Result
--Or
Select LEFT('How are you?', 5) AS 'My Result'
--Or
Select LEFT('How are you?', 5) AS 'My Results Are'

--5.Lower
Select LOWER('How are you?') 

--6.Upper
Select Upper('How are you?') AS UpperCase

--7.LTRIM (Remove leading spaces from a string)
--Note extra space before How
Select LTRIM(' How are you?') 

--8.RTRIM (Remove trailing spaces from a string)
--Note extra space after you?
Select RTRIM(' How are you?   ') AS Result

--9. NCHAR (returns unicode character based on number code)
Select NCHAR(66)

--10. PATINDEX (returns the location of a pattern in a string)
--% - Match any string of any length (including 0 length)
--_ - Match one single character
--[] - Match any characters in the brackets, e.g. [abc]
--[^] - Match any character not in the brackets, e.g. [^abc]

--Case 1
Select Patindex ('%SQL%','Welcome to SQL Server class')
--Answer is 12

--Case 2 (Note the two L's in the matching string -no SQLL, so returns 0)
Select Patindex ('%SQLL%','Welcome to SQL Server class')
--The following will work
Select Patindex ('%SQL S%','Welcome to SQL Server class')
--Answer is 12

--Case 3
Select Patindex ('%[SQL]%','Welcome to SQL Server class')
--Answer is 3

--Case 4
Select Patindex ('%S_L%','Welcome to SQL Server class')
--Answer is 12

--Case 5 (two underscores)
Select Patindex ('%S__%','Welcome to SQL Server class')
--Answer is 12

--Case 6
Select Patindex ('%S__%','Welcome to SQL Server class')
--Answer is 12

--Case 7
Select Patindex ('%[^SQL]%','Welcome to SQL Server class')
--Answer is 1

--Other PatIndex examples for practice
Select PATINDEX('%bea%','What a beautiful day')
--Answer is 8 because 'bea' starts at 8th position
--Or (no bead, so returns 0)
Select PATINDEX('%bead%','What a beautiful day')
--Or
Select PATINDEX('%[bea]%','What a beautiful day')
--Answer is 3 because that is the specific pattern
--Or
Select PATINDEX('%bea_ti%','What a beautiful day')
--Answer is 8 because beautiful starts at 8th position
--Or (two underscores)
Select PATINDEX('%bea__%','What a beautiful day')
--Answer is 8
--Or
Select PatIndex('%[^bea]%','What a beautiful day')
--Answer is 1

--11.CHARINDEX (returns location of a substring within a string)
--Example 1

Select CHARINDEX('Server', 'Welcome to SQL Server class')
--Answer is 16
--Example 2

Select CHARINDEX('day','What a beautiful day')
--Answer is 18 because 'day' is at 18th position

--12.REPLACE (replaces a sequence of characters in a 
--string with another set of characters)
--phrase msft... 'sql server' to be replaced by C#
Select REPLACE('Microsoft SQL Server Class','SQL Server','C#')
--Or

Select * from Students
Select REPLACE(StudentAddress,'Street1','Stelton Road') 
from Students
--Note that the above is only for display purpose
--If you do a 'Select * from Students' again, the original info will be there

--13. STR (to convert to a string)

--Difficulty with int info; will get an error message
--So int datatype has to be converted to str.  Ex: str(StudentID)
Select * from Students
Select REPLACE(StudentName,'Student1','Student1Updated') + str(StudentID) from Students

--Select REPLACE(StudentName,'Jane','Mary Jane') + 
--StudentID + ' ' + Age from StudentInfo6
--So 
--Use str
Select REPLACE(StudentName,'John','John Smith') + 
str(StudentID) + ' ' + str(Age) from StudentInfo6

--recommend using ltrim with str
Select REPLACE(StudentName,'John','John Smith') + 
str(StudentID) + ' ' + ltrim(str(Age)) from StudentInfo6

--14.SUBSTRING (extracts a substring from a string)
Select SUBSTRING('Beautiful Day', 1, 5)
--Answer is 'beaut' since it starts at 1st position and ends at 5th position

--15. STUFF (Deletes a sequence of characters from a string 
--and then inserts another sequence of characters into 
--the string, starting at a specified position)
Select STUFF('What a beautiful day', 17, 1, ' summer ')

--Other examples
Select STUFF('Beautiful day', 10, 1, ' summer ')
--If you use 2 instead of 1 then the 'd' in d will go missing. It will read as 'Beautiful summer ay'
Select STUFF('Beautiful day', 10, 2, ' summer ')

--Numeric functions
--16. AVG
Select AVG(Age) AS 'Average Age' FROM StudentInfo6

--17. SUM
Select SUM(Age) AS 'Total Age' FROM StudentInfo6

--18. ABS (absolute value of a #)
Select Abs(-123.4)

--19. CEILING (Returns the smallest integer value that 
--is greater than or equal to a number)
Select CEILING(30.75)

--20. FLOOR
Select FLOOR(30.75)

--21. RAND
--Returns a random number or a random number within a range
--In the following example, it returns a random number >= 5 
--and <=10
Select RAND()
--Or
--Return a random number >= 5 and <=10:
Select FLOOR(RAND()*(10-5+1)+5)
--Or
--Select a random row using Microsoft SQL Server.
Select TOP 3 StudentID,StudentName,Age
FROM StudentInfo6 ORDER BY NEWID();
--22.ROUND
--round to second position after decimal point
Select ROUND(123.456789, 2)
--round to third position after decimal point
Select ROUND(123.456789, 3)
--23.SIGN()
--Sign function returns a value indicating the sign of a number
--If number > 0, it returns 1 -- greater than zero
--If number = 0, it returns 0
--If number < 0, it returns -1 -- less than zero
Select Sign (100)
--Or
Select Sign (-100)
--Or
Select Sign (0)
--Date functions
--24.Get current date
Select GETDATE();

--25. DateAdd for adding dates 
Select DateAdd(month, 1, '06/12/2022')
Select DateAdd(year, 1, '06/12/2022')
Select DateAdd(day, 1, '06/12/2022')

--DateAdd for subtracting dates 
--change 1 to a -1
Select DateAdd(month, -1, '06/12/2022')
Select DateAdd(year, -1, '06/12/2022')
Select DateAdd(day, -1, '06/12/2022')

--26. DATEDIFF
SELECT DATEDIFF(year, '2013/03/04', '2022/03/04')
--OR (will get same result as above)
SELECT DATEDIFF(yy, '2013/03/04', '2022/03/04')
--Month
SELECT DATEDIFF(month, '2013/03/04', '2022/03/04');
--OR
SELECT DATEDIFF(mm, '2013/03/04', '2022/03/04');
--HOURS
SELECT DATEDIFF(hour, '2013/03/04 02:00', '2022/03/04 16:00')
--OR
SELECT DATEDIFF(hh, '2018/03/04 02:00', '2019/03/04 16:00');
/*
interval Required. The time/date part to return. Can be one of the
following values:
year, yyyy, yy = Year
quarter, qq, q = Quarter
month, mm, m = month
dayofyear = Day of the year
day, dy, y = Day
week, ww, wk = Week
weekday, dw, w = Weekday
hour, hh = hour
minute, mi, n = Minute
second, ss, s = Second
millisecond, ms = Millisecond
date1, date2 Required. The two dates to calculate the difference between
*/
--UTC Date
--Conversion functions
--27. CAST (Converts an expression from one data type 
--to another)
SELECT CAST(15.12 AS int)
--Or
SELECT CAST(15.12 AS varchar)
--Or
SELECT CAST('2018/03/04' AS datetime)

--28. CONVERT with dates(Converts an expression from 
--one data type to another)
--Most important when working with dates or money
--Default
SELECT CONVERT(varchar, GETDATE(), 101) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY
--US
SELECT CONVERT(varchar, GETDATE(), 101) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY
--ANSI
SELECT CONVERT(varchar, GETDATE(), 102) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY
--UK/French
SELECT CONVERT(varchar, GETDATE(), 103) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY
--German
SELECT CONVERT(varchar, GETDATE(), 104) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY
--Italian
SELECT CONVERT(varchar, GETDATE(), 105) AS
WithYYYY,CONVERT(varchar, GETDATE(), 1) AS
WithoutYYYY

--29. CONVERT with money
SELECT CONVERT(varchar, CAST(1234567 AS money), 1)
--Convert money to comma delimiters

--Advanced functions
--30.COALESCE
--Return the first non-null value in a list:
/*
Properties of the SQL Coalesce function
1.Expressions must be of same data-type
2.It can contain multiple expressions
3.The SQL Coalesce function is a syntactic shortcut for the Case expression
4.Always evaluates for an integer first, an integer followed by character 
expression yields integer as an output.
*/
Select COALESCE (NULL,'X','Y','Z')
--Or
Select Coalesce (NULL, Null, 10, 20, Null)
--Or
Select Coalesce (NULL, Null, 20,10, 'John')

--31. ISDATE(Returns 1 if the expression is a valid date, 
--otherwise 0)
SELECT ISDATE('2019-09-27')
--Or
SELECT ISDATE('Some text')
--28.ISNUMERIC(Returns 1 if the expression is a valid number, 
--otherwise 0)
SELECT ISNUMERIC('20190927')
--Or
SELECT ISNUMERIC('Some text')
--32.NULLIF
/*
The NULLIF() function compares two expressions.
If expr1 and expr2 are equal, the NULLIF() function 
returns NULL (no difference between the two terms).  Otherwise, it returns expr1.
*/
SELECT NULLIF('SQL','Server')
--Next try
SELECT NULLIF('SQL','SQL')

/*======USER DEFINED FUNCTIONS=======*/
--Example of scalar functions
--LAB 3 - SCALAR FUNCTIONS (Example 1)
--Step 1 - create the function
-- 10 + 5 = 15
Use MyFirstDB

Create Function FindSum(@number1 int, @number2 int)
	Returns int
		As
			Begin
				Declare @sum int
				Set @sum = @number1 + @number2
				Return @sum
			End
--You can see the function in MyFirstDB --> Programmability-->Functions --> Scalar valued functions
--Step 2 - call the function
Select dbo.FindSum(10,5)

--SCALAR FUNCTIONS (Example 2)
--33/10 --> remainder(modulus) = 3
--Step 1 - create function
Create Function FindModulus(@number1 int, @number2 int)
	Returns int
		As
			Begin
				While(@number1 > @number2)
					Begin
						Set @number1 = @number1 - @number2
					End
				Return @number1
			End

--Step 2 - call function
Select dbo.FindModulus(33,10)
/*
Note: If the first number is smaller than the second number,
then the first number inside the paranthesis will be returned since 
we have not defined how to handle exceptions
*/
Select dbo.FindModulus(20,44)
--Or
Select dbo.FindModulus(30,60)

--But calculation will be fine as long as the first number is
--larger than the second number
Select dbo.FindModulus(44,20)
--If there is no remainder, you will get the second number as the answer
Select dbo.FindModulus(40,20)
Select dbo.FindModulus(60,20)

