/*======Create Table=====*/
use MyFirstDB
Create Table StudentInfo2
(
	StudentID int Identity (100,2),
	--Identity (100,2) mean
	--100 = seed value (starting value)
	--2 = increment value
	--100 (start)
	--102 (next)
	--104 (next)
	StudentName nvarchar (50)
)

/*====Query with select and drag from table====*/

select [StudentID],[StudentName] from studentinfo2
select * from studentinfo2
insert into StudentInfo2 (StudentName)
values ('marry')