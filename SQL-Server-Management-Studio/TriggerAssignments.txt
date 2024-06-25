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
	Select * from ContractorPayment