use Bank
--Cau1
Select Cust_id, Cust_name, Cust_phone from customer
where Cust_ad like N'%Đà Nẵng%'

--Cau2
Select Ac_no, ac_type, cust_id from account
where ac_type ='1'

--Cau 3
Select Cust_id,Cust_name, Cust_phone from customer
where left(Cust_phone,4) not in ('0120', '0121','0122','0126','0128')

--Cau 4
Select  Cust_id,Cust_name, Cust_phone, Cust_ad from customer
where Cust_name like N'Phạm%'

--Cau 5
Select  Cust_id,Cust_name, Cust_phone, Cust_ad from customer
where RIGHT(Cust_name, Charindex(' ', reverse(Cust_name))-1) like '%g%'

Select  Cust_id,Cust_name, Cust_phone, Cust_ad from customer
where Cust_name like N'%g%'

--Cau 6
Select  Cust_id,Cust_name, Cust_phone, Cust_ad from customer
where RIGHT(Cust_name, Charindex(' ', reverse(Cust_name))-1) like '_[H,T,A,Ê]%'

Select 

--Cau 7
Select t_id, t_type,t_date from transactions
where DATEPART(quarter,t_date) = 4 and YEAR(t_date)=2016

--Cau 8
Select t_id, t_type,t_date from transactions
where DATEPART(quarter,t_date) = 3 and YEAR(t_date)=2016

--Cau9
Select Cust_id, Cust_name,Cust_phone, Br_id from customer
where Br_id not like 'VB%'

--Cau10
Select Ac_no, ac_balance,cust_id from account
where ac_balance >=100000000

--Cau11
Select t_id,t_type,t_amount, t_time,t_date,datename(weekday,t_date) as Ten from transactions
where t_type ='1' and 
(((t_time < '08:00:00' or t_time >'11:30:00') and
(t_time <'13:30:00' or t_time >'16:30:00')) or
datename(weekday,t_date) in ('Sunday','Saturday'))

--Cau12
Select t_id,t_type,t_amount, t_time from transactions
where t_type ='0' and 
(DATEPART(hour, t_time) between 0 and 3)

--Cau 13
Select Cust_id,Cust_name,Cust_ad from customer
where Cust_ad like N'%Ngũ Hành Sơn%Đà Nẵng'

--Cau 14
Select * from Branch
where BR_ad is null or len(BR_ad) = 0 

--Cau 15
Select t_id,t_type,t_amount from transactions
where t_type = '0' and t_amount <50000

--Cau 16
Select t_id,t_type,t_amount,t_date,ac_no from transactions
where YEAR(t_date) = '2017' and t_type = '1'

--Cau 17
Select Ac_no,ac_balance,ac_type,cust_id from account
where ac_balance < 0

--Cau 18
Select Cust_id, Cust_name, Right(Cust_name,Charindex(' ',reverse(Cust_name))-1) as Ten,
Case 
when CHARINDEX(',',Cust_ad)=0 then LTRIM(right(cust_ad, charindex('-',reverse(cust_ad))-1))
else
 LTRIM(right(cust_ad, charindex(',',reverse(cust_ad))-1)) 
 End as Tinh
from customer
where Tinh like N'%Ngũ Hành sơn%' replace (
--Cau 19 
Select Cust_id, Cust_name, Cust_phone,Cust_ad from customer
where Cust_name not like N'[N,T]%'

--Cau 20
Select Cust_id, Cust_name, Cust_phone,Cust_ad from customer
where right(Cust_name,3) like N'[a,u,i,á,à,ạ,ã,ú,ù,ũ,ụ,í,ì,ĩ,ị]%' 

--Cau 21
--c1
Select Cust_id,Cust_name, Cust_phone,Cust_ad from customer
where SUBSTRING(Cust_name, charindex(' ',Cust_name)+1, len(Cust_name)-charindex(' ',reverse(Cust_name))) like N'%Văn%' or
SUBSTRING(Cust_name, charindex(' ',Cust_name)+1, len(Cust_name)-charindex(' ',reverse(Cust_name))) like N'%Thị%'
--c2
Select Cust_id,Cust_name, Cust_phone,Cust_ad from customer
where rtrim (Cust_name) like N'%Văn_%' or rtrim (Cust_name) like N'%Thị_%'
--Cau 22 
Select Cust_id,Cust_name, Cust_phone,Cust_ad from customer
where Cust_ad like N'%Thôn%' or (Cust_ad like N'%Thôn%' and Cust_ad like N'%Xã%')
or (Cust_ad like N'%Xóm%' and Cust_ad like N'%Xã%')

--Cau 23
Select Cust_id,Cust_name, Cust_phone,Cust_ad from customer
where SUBSTRING(RIGHT(cust_name,charindex(' ',reverse(cust_name))-1),2,1) like N'[u,ũ,a]'

--21
Select cust_name, right(cust_name,CHARINDEX(' ',reverse(Cust_name))) as Ten from customer
where SUBSTRING(Cust_name, charindex(' ',cust_name)+1, len(cust_name)-charindex(' ',reverse(cust_name))) like N'%Thị%' or
SUBSTRING(Cust_name, charindex(' ',cust_name), len(cust_name)-charindex(' ',reverse(cust_name))) like N'%Văn%'

Select cust_name from customer
where (Cust_name not like N'Văn%' and Cust_name like N'%Văn_') or
(Cust_name not like N'Thị%' and Cust_name like N'%Thị_')

Select Cust_id,Cust_name, Cust_phone,Cust_ad from customer
where (rtrim (Cust_name) like N'%Văn_%' and  ) or (rtrim (Cust_name) like N'%Thị_%')