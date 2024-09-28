create database [HotelDB]
Use [HotelDB]
select * from [dbo].[Data]
--Q1
Alter table [dbo].[Data]
Add RoomType char(1)
Update [dbo].[Data]
set RoomType =left(RoomID,1)
--Q2
Alter table [dbo].[Data]
Add Floors char(1)
Update [dbo].[Data]
set Floors = SUBSTRING(RoomID,2,1)
--Q3
Alter table [dbo].[Data]
Add Nationality char(2)
Update [dbo].[Data]
set Nationality =LEFT (CustomerID,2)
--Q4
Alter table [dbo].[Data]
Add CustomerType varchar(6)
Update [dbo].[Data]
set CustomerType = iif(right(CustomerID,1)='S','Single','Group')
--Q5
Alter table [dbo].[Data]
Add Age int
Update [dbo].[Data]
Set Age = DATEDIFF(year,DateOfBirth,getdate())
--Q6
Alter table [dbo].[Data]
Add UnitPrice int
Update [dbo].[Data]
Set UnitPrice = iif(RoomType='A','200',iif(RoomType='B','150',iif(RoomType='C','100','80')))
--Q7
Alter table [dbo].[Data]
Add Duration int
Update [dbo].[Data]
Set Duration = DATEDIFF(day,DateCheckin,DateCheckout)
--Q8
Alter table [dbo].[Data]
Add RoomMoney int
Update [dbo].[Data]
Set RoomMoney= Duration*UnitPrice
--Q9
Alter table [dbo].[Data]
Add Discount int
Update [dbo].[Data]
Set Discount = RoomMoney * 
iif(Duration>10,0.2,
iif((6<=Duration)and (Duration<=10),0.1,
iif((3<=Duration)and (Duration<=5),0.05,0)))
--Q10
Alter table [dbo].[Data]
Add TotalPaid int
Update [dbo].[Data]
Set TotalPaid=RoomMoney-Discount + ( 0.1 * RoomMoney)
