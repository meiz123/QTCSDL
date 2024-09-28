create database HOUSEDB
Use HOUSEDB

create table EMPLOYEES (
	EmpID char(3) not null primary key, 
	Email varchar(25) unique,
	Salary int check (Salary>=0),
	Gender bit not null)

insert into EMPLOYEES (EmpID, Email, Salary, Gender)
Values ('100','qa@gmail.com','10000000',0),
('101','tlam@gmail.com','10000000',0),
('102','huyen@gmail.com','10000000',0)

Select * from EMPLOYEES
---

create table HOUSES (
	HouseID char(3) not null primary key,
	Area_m2 int,
	Price int not null,
	BedRoom int not null,
	HouseType varchar(20) not null)

Insert into HOUSES (HouseID,Price,BedRoom,HouseType)
Values ('101','500000','2','family'),
('202','600000','3','family'),
('301','550000','4','family')

Select * from HOUSES


create table CUSTOMERS(
	CustomerID char(12) not null primary key,
	Gender bit not null,
	Cname varchar(30) not null,
	Caddress varchar(50),
	Email varchar (30) unique)

insert into CUSTOMERS(CustomerID,Gender,Cname,Caddress,Email)
Values ('123456789010',0,'Quynh Anh','Ngu Hanh Son','qa@gmail.com'),
('123456789011',0,'Truc Lam','Ngu Hanh Son','tlam@gmail.com'),
('123456789012',0,'Khanh Huyen','Ngu Hanh Son','huyen@gmail.com')

Select * from CUSTOMERS

create table CONTRACTS(
	ContractNo char (15) not null primary key,
	HouseID char(3) not null ,
	EmpID char(3) not null,
	CustomerID char (12) not null,
	StartDate date not null,
	EndDate date,
	Duration int,
	ContractValue int,
	PrePaid int check (PrePaid >=0),
	OutstandingAmount int )
--
Alter table CONTRACTS 
add foreign key (HouseID) references HOUSES(HouseID) 
on update Cascade on delete cascade
Alter table CONTRACTS 
add foreign key (EmpID) references EMPLOYEES(EmpID)
on update Cascade on delete cascade
Alter table CONTRACTS 
add foreign key (CustomerID) references CUSTOMERS (CustomerID)
on update Cascade on delete cascade

--
insert into CONTRACTS(ContractNo,HouseID,EmpID,CustomerID,StartDate)
values ('Thuenha1','101','100','123456789010','2023-9-1'),
('Thuenha2','202','101','123456789010','2023-8-30'),
('Thuenha3','301','102','123456789010','2023-8-29')

Select * from CONTRACTS