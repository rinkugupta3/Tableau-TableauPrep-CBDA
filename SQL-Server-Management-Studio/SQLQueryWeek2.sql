/*-----WEEK2-------*/
/*=============Lab1=========*/
/*Query1====================*/
--Single user mode
--For Maintance stop database for other user to access and only admin can acess.
Use Master
Go
	Alter Database MyFirstDB set single_user with rollback immediate
Go
--After refresh and then will have (single user) beside db*/
/*Query2=================*/
--In another window, if another user try to login and will get message:
--"Database 'MyFirstDB' is already open and can only have one user at a time"

/*Query3=================*/
--Multi user mode
--Now Maintance is over and have multi user access db
Use Master
Go
	Alter Database MyFirstDB set Multi_User
Go
--After refresh and then (single user) will be remove from db and user can login from another window

/*=============Lab2========================*/
--DataTypes
--Create Table
--difference between char and varchar
use MyFirstDB
Create Table Employee
(
	EmployeeID int Identity (1,1),
	EmployeeName varchar (50),
	--3 string types 'char', 'varchar', 'nvchar'
	Street nvarchar (50),
	City char (50),
	State char (50),
	ZipCode int
)

select * from [dbo].[Employee]where City='Freehold'

Insert into Employee (EmployeeName,[Street],[City], [State],[ZipCode])
values ('Mary', '12 Main Street', 'Freehold', 'NJ', 07749)

/*=====Lab3=======*/
--Fixed lenght of char (fixed lenght datatype)
--doesn not work, if chat over limit
Insert into [dbo].[Employee] (EmployeeName,[Street],[City], [State],[ZipCode])
values ('Bob','Durham', 'Piscataway50characters', 'NJ',23456)

/*===============Lab4==========*/
--unicode characters for nvarchar
--Having user name in foreign language

insert into Employee (EmployeeName,[Street],[City], [State],[ZipCode])
values (N'こんにちは', N'こんにちは', 'Tokyo', 'Japan', 99876)
--input N (National) before unicode
select * from [dbo].[Employee]
--will have ????? in employee name because employeename char type is 'varchar' 
--and use 'nvarchar'

/*===========Lab5========*/
----Type safety
--if user input char intead of int values
use myfirstdb
select * from [StudentInfo]

Insert into StudentInfo (StudentID, StudentName)
values ('xyz','Alice')

--Error message "conversion failed when converting the varchar value 'xyz' to data type int."

--Fix query with init values

Insert into StudentInfo (StudentID, StudentName)
values (2,'Alice')

/*==========Lab6=========*/
--Change data type
--DDL Data Defination Language
--case1--change datatype of an existing column from string to init
select * from employee
sp_help Employee
Alter Table Employee Alter Column City int
--have existing data in table and will not allow
--Add new column as phone
Alter Table Employee Add Phone char (10)
Alter Table Employee Alter Column phone int

--case2--change datatype of an existing column from int to string
Alter Table Employee Alter Column phone varchar(20)

insert into employee ([EmployeeName],[Street],[City],[State],[ZipCode],[Phone])
values ('Robert', '12345 Main Street', 'Middletown','NJ',08879,'xyz')

--case3--change datatype of an existing column from string to int
--after values have been entered
Alter Table Employee Alter Column phone int
--Error:
--"Conversion failed when converting the varchar value 'xyz' to data type int.
--The statement has been terminated"
--Failed becuase column already have values.

/*========Lab7======*/
---Dropping a column

Alter Table Employee Drop Column Phone
select * from employee
sp_help Employee

/*========Lab8======*/
--Renaming columns

Execute sp_rename 'Employee.Street', 'Road', 'Column'

/*========Lab9======*/
--Renaming Tables

Exec sp_rename Employee, EmployeeNew

Exec sp_rename EmployeeNew, Employee

select * from employee
sp_help Employee
