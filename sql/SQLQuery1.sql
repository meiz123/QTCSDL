Create Database Daotao
Use daotao
Create table Monhoc(MaMH char(6) not null primary key,
TenMH varchar(50) not null, SoTC int not null)
Alter table Monhoc
Add LoaiMH char(2) 
--
Insert into Monhoc
values ('DBI202', 'Database', 3, 'BB'),
('PGI202', 'Programming', 3, 'BB'),
('ALI202', 'Algorithm', 2, 'TC')
--
Select * from Monhoc
--
Create Table Khoa(MaKhoa char(5) not null Primary Key,
TenKhoa varchar(50) not null, Vitri varchar(120))
--
Alter Table MonHoc
Add MaKhoa char(5)
--
Alter Table Monhoc
Add Constraint FK_Khoa Foreign key (MaKhoa) References Khoa(MaKhoa)
Drop Database Daotao