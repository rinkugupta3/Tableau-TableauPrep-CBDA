--week 1
--Create Database
Create Database MyFirstDB
--Update Alter Database
Alter Database MyFirstDB Modify Name = MyFirstDBNew
Execute sp_renamedb 'MyFirstDBNew', 'MyFirstDB'
use myfirstdb
select * from myfirstdb..studentinfo

/*
Delete 
Drop Database
Ctrl K + C --> CommentCtrl K + U --> UnComment
*/
Drop Database MyFirstDB
--Create, Alter, Drop databse using GUI
--right click "database" in object Explorer window and right click and click create, rename, delete
--=====================================================
---Create Tables
/*
Set the DB context
1. Use commnd
2. Drop down
*/
use MyFirstDB
create Table StudentInfo
(
	StudentID int,
	StudentName nvarchar (50),
)
---Insert data
insert into StudentInfo (StudentId, StudentName)
values (1, 'John')
---Select statement-- result set
select * from StudentInfo

--Week One HomeWork
/*
Assignment 1
Use SQL to:
• Create a database called CustomerDB
• Rename the database to CustomerDBNew
• Drop database CustomerDBNew
*/
Create database CustomerDB
Alter database CustomerDB modify name=CustomerDBRenew
Drop database CustomerDBRenew
/*
Assignment 2
Use SQL and GUI to:
• Create a Database called OrderDB
• Create a Table called OrderTable within OrderDB with columns 
OrderID, ProductName, CustomerName, Street, City, State
• Insert a record inside OrderTable with Values 101, Laptop, John, 
123Street, Metuchen, NJ
*/
Create database OderDB
Alter database OderDB modify name=OrderDB
use OrderDB
Create Table OrderTable
(
OrderID int,
ProductName nvarchar (50),
CustomerName nvarchar (50),
Street nvarchar (50),
City nvarchar (50),
State nvarchar (50),
)
select * from Ordertable
insert into OrderTable (OrderID,ProductName,CustomerName,Street,City,State)
values (101, 'Laptop','John','123Street','Metuchen','NJ')
select * from Ordertable
insert into 
OrderTable (OrderID,ProductName,CustomerName,Street,City,State)
values 
(102, 'PC','Mike','5555 Racy Street','Freehold','NJ'),
(103, 'Mac','Roger','1333 Disney Road','Bridgewater','FL'),
(104, 'Dell','Joe','12 Holloywood Blvd','Los Angles','CA'),
(105, 'HP','Bill','999 Main Street','Houston','TX')

select * from Ordertable
update OrderTable set street='123 Street'where orderID=101 