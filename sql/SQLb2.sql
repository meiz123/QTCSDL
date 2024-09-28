create database dtao
use dtao
--courses(cno,cname,credit)
Create table courses(Cno char (7) not null primary key, 
Cname varchar(50) not null, credit int default 3 check(credit>=0))
--
Insert into courses(Cno,Cname,credit)
Values ('ECO2001','Ecommerce'),
('MIS2001','Database')
Select * from courses
--
Insert into courses(Cno,Cname,credit)
Values ('ECO2002','Epayment',2)
--unique
create table students(sno char (12) not null primary key,
Sname varchar(50) not null,DOB date, gender bit not null,
Email varchar(50) unique , phone char(10) unique)
--foreign key
--course enrollment (sno,cno,time_enroll,semester, school_year,fee)
Create table course_enrollment(sno char(12) not null,
cno char(7) not null, time_enroll datetime default getdate(),
Semester char(1), school_year char(9), fee int,
Constraint pk primary key(sno,cno))
Alter table course_enrollment
Add constraint fk_courses foreign key (cno) references courses(cno)
On update cascade on delete cascade

Select * from courses
--
Insert into students(sno,Sname,gender,Email,phone)
Values('123456789012','Nguyen Van A',1,'a@gmail.com','090512345'),
('123456789013','Nguyen Thi B',0,'b@gmail.com','090512354')
Select * from students
insert into course_enrollment(sno,cno)
Values ('123456789012','ECO2001'),
('123456789012','MIS2001'),
('123456789013','ECO2001')
Select * from course_enrollment
update courses
Set Cno='E-C2001'
where Cno='ECO2001'
Select * from course_enrollment
select * from courses
Delete from courses
where Cno='E-C2001'