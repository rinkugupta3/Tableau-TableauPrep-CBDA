/*=============Week3===CRUD (create,read,update,delete)=====================*/
use master
use MyFirstDB

/*=============Lab1==============*/
--Insert one record at a time
Create Table Students
(
	StudentID int,
	StudentName nvarchar (250),
	StudentAddress nvarchar (250),
	StudentEmail nvarchar (250)
)

Insert into Students (StudentID, StudentName, StudentAddress, StudentEmail)
values (101, 'John', '145 Main Street Middletown NJ 07748', 'email1@test.com')

select * from Students

/*========Lab2=============*/
--Insert mulitples records simulaneously
Insert into Students (StudentID, StudentName, StudentAddress, StudentEmail)
values 
(102, 'Mark', '165 Main Street Middletown NJ 07748', 'email2@test.com'),
(103, 'Joe', '4444 Main Street Middletown NJ 07748', 'email3@test.com'),
(104, 'Bill', '990004 Main Street Middletown NJ 07748', 'email4@test.com')

------Insert multiple data with Union All
Insert into Students (StudentID, StudentName, StudentAddress, StudentEmail)
select 105, 'Student3', 'Street3','email5@test.com'
Union All
select 106, 'Student4', 'Street4','email6@test.com'
Union All
select 107, 'Student7', 'Street7','email7@test.com'

select * from students




/*=========Lab3=================*/
---Create Duplicate Tables or back table
Create Table StudentsDuplicate
(
	StudentId int,
	StudentName nvarchar (250),
	StudentAddress nvarchar (250)
)

select * from StudentsDuplicate

Insert into StudentsDuplicate (StudentId, StudentName, StudentAddress)

select StudentId, StudentName, StudentAddress from Students

/*===================Lab4==========*/
--Update one column
--case1-- For String
select * from Students

update students set StudentAddress='44757 Main Street Middletown NJ 07748' 
where StudentName='Student3'

--case2-- For Numbers
update students set StudentEmail='email1new@test.com' 
where StudentID=101

select * from Students

/*=============Lab5========================*/
--update multiple column

update students set 
StudentAddress = '88222 Main Street Middletown NJ 07748',
StudentEmail='email1update@test.com'
where StudentID=106

select * from Students

/*=========Lab6=================*/
--Error while NOT having WHERE clause
---update operation require to have where clause

StudentAddress = '883222 Main Street Middletown NJ 07748',
StudentEmail='email7update@test.com'
StudentID=107

/*========Lab7==========*/
--Delete one record at a time

delete from students where studentid=107

select * from Students

/*===========Lab8=======*/
---Delete multiple records

delete from students where StudentID in (105, 104)

/*=======Lab9=========*/
--Truncate Table-----different between delete and trucate in powerpoint
select * from Students
select * from StudentsDuplicate

Truncate Table StudentsDuplicate

/*==============Lab10======*/
--Read opration
--classic select statement
--case1--reading from the table
select * from Students
--case2--display strings (inline code)
select 'how are you?'
---case3--combine 2 strings (concatenation)
select 'Hello Hello' + ' how are you?'
--case4---Display numbers to person
select 10,20,30

select 10+20
select 20-10
select 10*20
select 20/10
select 20/3 as integer, 20 % 3 as remainder
select 20/3 as Quotient, 20 % 3 as Modulus
/*=======Lab11=======*/
--Using Filter Conditions - simple where clause

select * from Students
select * from students where studentid=101

/*========Lab12=======*/
--Not Equal opeator
select * from students where studentid <>101

/*========Lab13=======*/
--Greater Than
select * from students where studentid > 105

/*========Lab14=======*/
--Less than
select * from students where studentid < 105

/*========Lab15=======*/
--Grater than equal to
select * from students where studentid >= 105

/*========Lab16=======*/
--Less than or equal to
select * from students where studentid <= 105

/*========Lab17========*/
--Between
select * from students where studentid between 102 and 105

/*======Lab18=========*/
--Like operator (searching for text) (% any number of char, -is for one number search
--case1 Like 'text%'
select * from students where studentname like'Ma%'
--case2 Like '%text'
select * from students where studentname like'%3'
--case3 Like '_text%'
select * from students where studentname like'_3%'
--case4 Like '%text%'
select * from students where studentname like'%S%'
--case5 Like 'text_text%'
select * from students where studentname like's_u%'
--case6 Like 'text%text'
select * from students where studentname like's%4'

/*======Lab19=========*/
--