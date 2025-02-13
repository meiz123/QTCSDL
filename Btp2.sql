use bank 
--cau 1--
select COUNT(ac_balance) as Sotaikhoanthuong
from account 
where ac_balance <0

--Cau 2
select t_type,COUNT(t_type) as Soluonggiaodich, sum(t_amount) as SoTiengiaodich from transactions
Group by t_type

--Cau 3
Select COUNT(cust_ad) as SoKhachCoDiaChiHue from customer
where Cust_ad like N'%Huế%'

--Cau 4
Select ac_type,MAX(ac_balance) as max from account
Group by ac_type

--Cau 5 
SELECT TOP 1 t_date AS NgayGiaoDichGanNhat
FROM transactions
ORDER BY t_date DESC;

--Cau 6
Select count(cust_name) as khachhanghotrantendung from customer
where Cust_name like N'Trần%' and Cust_name like N'%Dũng'

--Cau 7
Select year(t_date),t_type,sum(t_amount) as tongtiengui from transactions
group by year(t_date),t_type
Having (YEAR(t_date) between 2016 and 2017) and t_type =1

--Cau8
Select ac_type ,avg(ac_balance) as SoTienTBTrongTaiKhoan,COUNT(ac_no)as Soluongtaikhoan from account
Group by ac_type
Order by ac_type 

--Cau9
Select COUNT(cust_name) from customer
where Cust_name like N'Hồ%' and left(Cust_phone,3) in 
('032', '033', '034', '035', '036', '037', '038', '039', '096', '097', '098', '086')

--Cau 10
select COUNT(br_id) as TongSoChiNhanh from Branch

--Cau11
Select COUNT (cust_id) as SoKhachHangKhongoQN from customer
where Cust_ad not like N'%Quảng Nam'

--Cau12 Có bao nhiêu tài khoản nhiều hơn 300 triệu, tổng tiền trong số các tài khoản đó là bao nhiêu?
select count(Ac_no) as TongSoTK, SUM(ac_balance) as TongTienTK from account
where ac_balance>300000000

--Cau 13
Select YEAR(t_date), t_type=0,AVG(t_amount) as SotienTB from transactions 
where t_type=0
Group by year(t_date)
Having year(t_date)=2017

--Cau 14
Select count(Cust_name) as SL
from Branch inner join customer on Branch.BR_id = customer.Br_id
where Cust_ad like N'%Quảng Nam' and BR_name like N'%Đà Nẵng'

--15.	Hiển thị danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ.
--cot:cust_id, cust_nam, br_id, tong tien 
--bang: 
--dieukien:
select customer.cust_id,Cust_name,customer.Br_id,sum(account.ac_balance)
From customer	join account on customer.Cust_id=account.cust_id
				join Branch on customer.Br_id=
where Br_id = N'VN018'  
group by customer.cust_id,Cust_name,customer.Br_id,account.ac_balance

--16.	Trong quý 1 năm 2012, có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại Ngân hàng Vietcombank
Select COUNT(distinct customer.Cust_id) as TongKH 
from transactions join account on transactions.ac_no = account.ac_no
join customer on account.cust_id=customer.Cust_id
where YEAR(t_date)=2012 and DATEPART(quarter,t_date) =1 and t_type='0'

--17.	Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014
SELECT COUNT(transactions.t_id) AS SoLuongGD,
	SUM(transactions.t_amount) AS TongTienGiaoDich,
    MONTH(t_date) AS Month,
    YEAR(t_date) AS Year
FROM transactions
WHERE YEAR(t_date) = 2014
GROUP BY MONTH(t_date), YEAR(t_date);

--18.Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
Select customer.Br_id,BR_name ,sum(transactions.t_amount) as TongTienGui
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
					join Branch on customer.Br_id=Branch.BR_id
where t_type =1
Group by customer.Br_id,BR_name
Order by TongTienGui desc

/*19.	Chi nhánh Sài Gòn có bao nhiêu khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 10 năm trở lại đây.
Hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý. */
--cot:Cust_id, Cust_name,Cust_phone
--bang: customer, account, transaction, account,branch
--dieukien: khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 10 năm trở lại đây, chi nhánh sg
SELECT Cust_id, Cust_name,Cust_phone
FROM customer 
where Cust_id not in 
(select customer.Cust_id from customer join Branch on customer.Br_id=Branch.BR_id
Left join account on customer.Cust_id=account.cust_id
Left join transactions on account.Ac_no=transactions.ac_no
where Branch.BR_name like N'%Sài Gòn%' and t_date<(DATEADD(year,-10,getdate())))

--20.Thống kê thông tin giao dịch theo mùa, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình, 
--tổng tiền giao dịch, lượng tiền giao dịch nhiều nhất, lượng tiền giao dịch ít nhất. 
select case when MONTH(t_date) between 1 and 3 then 'Xuan'
when MONTH(t_date) between 4 and 6 then 'Ha'
when MONTH(t_date) between 7 and 9 then 'Thu'
else 'Dong' end as Mua,
COUNT(t_id) as SOGD,
AVG (t_amount) as LuongTienTB,
MAX(t_amount) as LuongGDNhieuNhat,
Min(t_amount) as LuongGDItNhat
From transactions
Group by case when MONTH(t_date) between 1 and 3 then 'Xuan'
when MONTH(t_date) between 4 and 6 then 'Ha'
when MONTH(t_date) between 7 and 9 then 'Thu'
else 'Dong' end

--21.	Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế. 
--Hãy đưa ra tên của khách hàng thực hiện giao dịch đó.
--cot: max(t_amount), year(t_date), branch_name
--bang: transactions , account, customer, branch 
--dieukien: năm 2016 của chi nhánh Huế. 
SELECT customer.Cust_name, transactions.t_amount AS GDMax
FROM transactions
JOIN account ON transactions.ac_no = account.Ac_no
JOIN customer ON account.cust_id = customer.Cust_id
JOIN Branch ON customer.Br_id = Branch.BR_id
WHERE YEAR(t_date) = 2016 AND BR_name LIKE N'%Huế' AND transactions.t_amount = (
      SELECT MAX(t_amount)
      FROM transactions
      JOIN account ON transactions.ac_no = account.Ac_no
      JOIN customer ON account.cust_id = customer.Cust_id
      JOIN Branch ON customer.Br_id = Branch.BR_id
      WHERE YEAR(t_date) = 2016 AND BR_name LIKE N'%Huế'
  )

--select top n with ties 
SELECT TOP 1 with ties customer.Cust_name, transactions.t_amount AS GDMax
FROM transactions JOIN account ON transactions.ac_no = account.Ac_no
JOIN customer ON account.cust_id = customer.Cust_id
JOIN Branch ON customer.Br_id = Branch.BR_id
WHERE YEAR(transactions.t_date) = 2016 AND Branch.BR_name LIKE N'%Huế'
ORDER BY transactions.t_amount DESC

--22.	Tìm khách hàng có lượng tiền gửi nhiều nhất vào ngân hàng trong mỗi năm 
--cot:cust_name, max(t_amount), t_type, year(t_date) 
--bang:transaction, account, customer
--dk: mỗi năm ,t_type=1
Select Cust_name, max(t_amount) as LuongtienLn,t_type,year(t_date) as Nam
From transactions join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where (t_amount) in (select max (t_amount)
					from transactions join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
					group by year(t_date)) and t_type='1'
group by  Cust_name,t_type,year(t_date)

--
Select  Cust_name,sum(t_amount) as LuongtienLn,year(t_date) as Nam
From transactions join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where t_type='1'
group by  year(t_date),Cust_name
Having sum(t_amount) in			(select max(t_amount) 
								from (select year(t_date),sum(t_amount)
									 from transactions join account on transactions.ac_no=account.Ac_no
									 where t_type='1'
									 GROUP BY year(t_date), cust_id)
									 


SELECT 
    year(t1.t_date) AS Nam,
    c.cust_id AS KhachHangID,
    c.cust_name AS TenKhachHang,
    SUM(t1.t_amount) AS LuongTien
FROM 
    transactions t1
JOIN 
    account a ON t1.ac_no = a.ac_no
JOIN 
    customer c ON a.cust_id = c.cust_id
WHERE 
    t1.t_type = '1'
GROUP BY 
    year(t1.t_date), c.cust_id, c.cust_name
HAVING 
    SUM(t1.t_amount) = (
        SELECT 
            MAX(tien_gioi)
        FROM (
            SELECT 
                year(t2.t_date) AS Nam,
                SUM(t2.t_amount) AS tien_gioi
            FROM 
                transactions t2
            JOIN 
                account a2 ON t2.ac_no = a2.ac_no
            WHERE 
                t2.t_type = '1'
            GROUP BY 
                year(t2.t_date), a2.cust_id
        ) AS subquery
        WHERE subquery.Nam = year(t1.t_date)
    )

--23.	Tìm những khách hàng có cùng chi nhánh với ông Phan Nguyên Anh
Select Cust_id,Cust_name,Br_id
from customer 
where Br_id = 
(select customer.Br_id 
from customer join Branch on customer.Br_id=Branch.BR_id
where Cust_name like N'Phan Nguyên Anh')

--24.	Liệt kê những giao dịch thực hiện cùng giờ với giao dịch của ông Lê Nguyễn Hoàng Văn ngày 2016-12-02
select t_id,DATEPART(hour,t_time) as Gio, t_date
From transactions 
where DATEPART(hour,t_time) in
(select DATEPART(hour,t_time)
From transactions join account on transactions.ac_no=account.Ac_no
Join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Lê Nguyễn Hoàng Văn' and t_date='2016-12-02' )
----25.	Hiển thị danh sách khách hàng ở cùng thành phố với Trần Văn Thiện Thanh
select cust_id,cust_name, Cust_ad
from customer
where 
		case 
		when CHARINDEX(',',Cust_ad)=0 then ltrim(right(cust_ad,CHARINDEX('-',REVERSE(cust_ad))-1))
		else
				ltrim(right(cust_ad,CHARINDEX(',',REVERSE(cust_ad))-1))
		end 
		like (select
					case 
						when CHARINDEX(',',Cust_ad)=0 then 
								ltrim(right(cust_ad,CHARINDEX('-',REVERSE(cust_ad))-1))
						else
								ltrim(right(cust_ad,CHARINDEX(',',REVERSE(cust_ad))-1))
					end as tinh 
				from customer
				where Cust_name=N'Trần Văn Thiện Thanh')

--26.	Tìm những giao dịch diễn ra cùng ngày với giao dịch có mã số 0000000217
select * from transactions
where datepart(DAY,t_date) =
(select datepart(DAY,t_date) from transactions
where t_id='0000000217')

--27.	Tìm những giao dịch cùng loại với giao dịch có mã số 0000000387
select t_id,t_type from transactions
where t_type =
(select t_type from transactions
where t_id='0000000387')

--28.	Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng
--bảng branch, transaction 
Select customer.Br_id,COUNT(Br_id) as SoLanGD
From transactions join account on transactions.ac_no=account.Ac_no
Join customer on account.cust_id=customer.Cust_id
where t_type=1 
Group by customer.Br_id
Having  COUNT(customer.Br_id) > 
(Select COUNT(customer.Br_id) as SoLanGD
From transactions join account on transactions.ac_no=account.Ac_no
Join customer on account.cust_id=customer.Cust_id
Join Branch on customer.Br_id=Branch.BR_id
WHERE Branch.BR_name LIKE N'%Đà Nẵng%'
    AND (YEAR(t_date) = 2015
    AND MONTH(t_date) = 12))


--29.	Hãy liệt kê những tài khoảng trong vòng 6 tháng trở lại đây không phát sinh giao dịch    
SELECT Ac_no
FROM account
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions join account on account.Ac_no = transactions.ac_no
    where transactions.t_date >= DATEADD(month, -6, GETDATE()))

--30.	Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2015 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi
--tiền vào ngân hàng với tổng số tiền là bao nhiêu.

select Branch.BR_id,BR_name,
COUNT(transactions.t_id) as TongGD, SUM(transactions.t_amount) as Tongtien
from Branch join customer on Branch.BR_id=customer.Br_id
			join account on customer.Cust_id=account.cust_id
			join transactions on account.Ac_no=transactions.ac_no
where Cust_name like N'Phạm Duy Khánh' and t_type='1' and t_date>= '2015-01-01'
Group by Branch.BR_id,BR_name, customer.Cust_id,customer.Cust_name

Select Branch.BR_name,
		(select count(t_type) 
		From transactions	join account on transactions.ac_no=account.Ac_no
							join customer on account.cust_id=customer.Cust_id 
		where t_type ='1'
			And t_date >='2015-01-01'
			and Cust_name=N'Phạm Duy Khánh') as SoGD,
		(select SUM(t_amount)
		From transactions	join account on transactions.ac_no=account.Ac_no
							join customer on account.cust_id=customer.Cust_id
		where t_type ='1'
			And t_date >='2015-01-01'
			and Cust_name=N'Phạm Duy Khánh') as TongTienGui
From Branch join customer on Branch.BR_id=customer.Br_id
where Cust_name=N'Phạm Duy Khánh'

--31.	Thống kê giao dịch theo từng năm, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình
select  YEAR(t_date)  as Nam, COUNT(t_id) as SOGD,AVG(t_amount) as TienGD from transactions
Group by YEAR(t_date)

--32.	Thống kê số lượng giao dịch theo ngày và đêm trong năm 2017 ở chi nhánh Hà Nội, Sài Gòn
select COUNT(t_id) as soGD,YEAR(t_date) as Nam,t_time,
(CASE   
	WHEN t_time < '6:00:00'THEN 'Đêm'   
	WHEN t_time < '18:00:00' THEN 'Ngày'     
	ELSE 'Đêm'   
 END) AS Thời_Gian,
 BR_name
From transactions join account on transactions.ac_no=account.Ac_no 
join customer on account.cust_id=customer.Cust_id 
join Branch on customer.Br_id=Branch.BR_id
where BR_name like'%Hà Nội%' or BR_name like'%Sài Gòn%'
group by YEAR(t_date),BR_name,t_time,
CASE   
	WHEN t_time < '6:00:00'THEN 'Đêm'   
	WHEN t_time < '18:00:00' THEN 'Ngày'     
	ELSE 'Đêm'   
 END
Having YEAR(t_date)=2017

--33.	Hiển thị danh sách khách hàng không thực hiện giao dịch nào trong năm 2016?
--c1
select Cust_id,Cust_name
From customer
except
Select customer.Cust_id,Cust_name
From transactions join account on transactions.ac_no=account.Ac_no
join customer on account.cust_id=customer.Cust_id
where Year(t_date)=2016
--c2
select Cust_id,Cust_name
From customer
where Cust_id not in (
select Cust_id from transactions join account on transactions.ac_no=account.Ac_no
where Year(t_date)=2016) 

--34.	Hiển thị những giao dịch trong mùa xuân của các chi nhánh miền trung. 
--Gợi ý: giả sử một năm có 4 mùa, mỗi mùa kéo dài 3 tháng; chi nhánh miền trung có mã chi nhánh bắt đầu bằng VT.

select 
(Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End) as Mua, t_id, customer.Br_id
From transactions t join account a on t.ac_no=a.Ac_no
Join customer on a.cust_id=customer.Cust_id
where customer.Br_id like 'VT%'
Group by 
(Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End), t_id,customer.Br_id
Having 
(Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End) like 'Autumn'

--35.Hiển thị họ tên và các giao dịch của khách hàng sử dụng số điện thoại 
--có 3 số đầu là 093 và 2 số cuối là 02. 
select customer.Cust_id, Cust_name, Cust_phone, t_id
From customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where LEFT(customer.Cust_phone ,3) in ('093') and right (customer.Cust_phone ,2) in ('02')

--36.	Hãy liệt kê 2 chi nhánh làm việc kém hiệu quả nhất trong toàn hệ thống 
--(số lượng giao dịch gửi tiền ít nhất) trong quý 3 năm 2017
select top 2 customer.Br_id, sum(t_amount)as TienGD, t_type, 
DATEPART(quarter, t_date) as Quy, year(t_date) as Nam
From customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where t_type='1'and year(t_date)='2017' and DATEPART(quarter, t_date)='3'
Group by customer.Br_id, t_type, 
DATEPART(quarter, t_date), year(t_date)
Order by TienGD asc

--37.	Hãy liệt kê 2 chi nhánh có bận mải nhất hệ thống (thực hiện nhiều giao dịch gửi tiền nhất) 
--trong năm 2017. 
select top 2 customer.Br_id, sum(t_amount)as TienGD, t_type, year(t_date) as Nam
From customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where t_type='1'and year(t_date)='2017' 
Group by customer.Br_id, t_type, year(t_date)
Order by TienGD desc

--38.	Tìm giao dịch gửi tiền nhiều nhất trong mùa đông.
--Hãy đưa ra tên của người thực hiện giao dịch và chi nhánh
select top 1 customer.Br_id, sum(t_amount)as TienGD, t_type,
(Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End) as Mua
From customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where t_type='1' 
Group by customer.Br_id, t_type,
(Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End)
Having (Case 
when datename(month,t_date) between 'January' and 'March' then 'Spring'
when datename(month,t_date) between 'March' and 'June' then 'Summer'
when datename(month,t_date) between 'July' and 'September' then 'Autumn'
Else 'Winter'
End) like 'Winter'
Order by TienGD desc

--39.	Để bổ sung nhân sự cho các chi nhánh, cần có kết quả phân tích về cường độ làm việc của họ. 
--Hãy liệt kê những chi nhánh phải làm việc qua trưa và loại giao dịch là gửi tiền.
select distinct customer.Br_id,t_type
from customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where t_time> '12:00:00' and t_type='1'

--40	Hãy liệt kê các giao dịch gửi tiền bất thường
--Gợi ý: là các giao dịch gửi tiền những được thực hiện ngoài khung giờ làm việc
Select t_id, t_type, t_amount, t_time
From transactions
where (t_time not between '7:30:00' and '11:00:00' 
and t_time not between '13:30:00' and '17:00:00') and t_type='1' 

--41.	Hãy điều tra những giao dịch bất thường trong năm 2017. 
--Giao dịch bất thường là giao dịch diễn ra trong khoảng thời gian từ 12h đêm tới 3 giờ sáng.
Select t_id, t_time, year(t_date) as Nam
From transactions
where (t_time between '00:00:00' and '03:00:00') and year(t_date)=2017

--42.	Có bao nhiêu người ở Đắc Lắc sở hữu nhiều hơn một tài khoản?
Select count(cust_id) as SoNguoi
From customer
where cust_id in (select customer.Cust_id from 
customer join account on customer.Cust_id=account.cust_id
where Cust_ad like N'%Đăk Lăk'
Group by customer.Cust_id
Having COUNT(account.Ac_no)>1)

--43.	Nếu mỗi giao dịch rút tiền ngân hàng thu phí 3.000 đồng, 
--hãy tính xem tổng tiền phí thu được từ thu phí dịch vụ từ năm 2012 đến năm 2017 là bao nhiêu?
select count(t_id) as SoGD, t_type, (count(t_id)*3000) as TongPhi
from transactions
where t_type='0' and (year(t_date) between 2012 and 2017)
Group by t_type

--44 
Select customer.Cust_id as MaKH,
(left(cust_name,charindex(' ',cust_name))) as Ho,
(right(cust_name, charindex(' ',reverse(cust_name))-1)) as Ten,
Sum(account.ac_balance) as SoDuTaiKhoan
From customer join account on customer.Cust_id=account.cust_id
where (left(cust_name,charindex(' ',cust_name))) like N'%Trần%'
Group by customer.Cust_id,(left(cust_name,charindex(' ',cust_name))),
(right(cust_name, charindex(' ',reverse(cust_name))-1))

--45.	Cuối mỗi năm, nhiều khách hàng có xu hướng rút tiền khỏi ngân hàng để chuyển sang ngân hàng khác
--hoặc chuyển sang hình thức tiết kiệm khác. Hãy lọc những khách hàng có xu hướng rút tiền khỏi ngân hàng bằng
--cách hiển thị những người rút gần hết tiền trong tài khoản (tổng tiền rút trong tháng 12/2017 nhiều hơn 100 
--triệu và số dư trong tài khoản còn lại <= 100.000)
select customer.Cust_id,Cust_name,sum(t_amount) as TienRut
From customer join account on customer.Cust_id=account.cust_id
Join transactions on account.Ac_no=transactions.ac_no
where ac_type='0' and  year(t_date)=2017 and month (t_date)=12 and ac_balance<=100000
Group by  customer.Cust_id,Cust_name
Having sum(t_amount)>100000000

--46.	Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công (giả sử tí cho vui ), 
--tổng tiền trong tài khoản bị thay đổi bất thường. Hãy liệt kê những tài khoản bất thường đó. 
--Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi – tổng tiền rút <> số tiền trong tài khoản
SELECT account.Ac_no,account.ac_balance , 
SUM(IIF(transactions.t_type = '1', t_amount, 0)) AS TongTienGui, 
SUM(IIF(transactions.t_type = '0', t_amount, 0)) AS TongTienRut
FROM account JOIN transactions ON account.Ac_no = transactions.ac_no
GROUP BY account.Ac_no, account.ac_balance
HAVING (SUM(IIF(transactions.t_type = '1', t_amount, 0)) 
        - SUM(IIF(transactions.t_type = '0', t_amount, 0))) 
       <> account.ac_balance;

--47.	Do hệ thống mạng bị nghẽn và hệ thống xử lý chưa tốt phần điều khiển đa người dùng nên một số tài khoản 
--bị invalid. Hãy liệt kê những tài khoản đó. Gợi ý: tài khoản bị invalid là những tài khoản có số tiền âm. 
Select Ac_no,ac_balance
From account
where ac_balance<0

--48.(Giả sử) Gần đây, một số khách hàng ở chi nhánh Đà Nẵng kiện rằng: tổng tiền trong tài khoản không khớp
--với số tiền họ thực hiện giao dịch. Hãy điều tra sự việc này bằng cách hiển thị danh sách khách hàng ở Đà Nẵng 
--bao gồm các thông tin sau: mã khách hàng, họ tên khách hàng, tổng tiền đang có trong tài khoản, tổng tiền đã gửi
--, tổng tiền đã rút, kết luận (nếu tổng tiền gửi – tổng tiền rút = số tiền trong tài khoản  OK, trường hợp còn 
--lại  có sai)
SELECT account.Ac_no,account.ac_balance , 
SUM(IIF(transactions.t_type = '1', t_amount, 0)) AS TongTienGui, 
SUM(IIF(transactions.t_type = '0', t_amount, 0)) AS TongTienRut
FROM account JOIN transactions ON account.Ac_no = transactions.ac_no
where account.Ac_no in (select account.Ac_no from 
account join customer on account.cust_id=customer.Cust_id
Join Branch on customer.Br_id =Branch.BR_id
where BR_name like N'%Đà Nẵng%')
GROUP BY account.Ac_no, account.ac_balance
HAVING (SUM(IIF(transactions.t_type = '1', t_amount, 0)) 
        - SUM(IIF(transactions.t_type = '0', t_amount, 0))) 
       <> account.ac_balance;

select customer.Cust_id,customer.Cust_name,account.Ac_no,ac_balance,
SUM(IIF(transactions.t_type = '1', transactions.t_amount, 0)) AS Tong_Tien_Da_Gui,
SUM(IIF(transactions.t_type = '0', transactions.t_amount, 0)) AS Tong_Tien_Da_Rut,
IIF(SUM(IIF(transactions.t_type = '1', transactions.t_amount, 0)) - 
SUM(IIF(transactions.t_type = '0', transactions.t_amount, 0)) = account.ac_balance, 'OK', 'sai') AS Ket_Luan
from transactions join account on transactions.ac_no=account.Ac_no
join customer on account.cust_id=customer.Cust_id
Join Branch on customer.Br_id =Branch.BR_id
where BR_name like N'%Đà Nẵng%'
Group by customer.Cust_id,customer.Cust_name,account.Ac_no, account.ac_balance

--49.Ngân hàng cần biết những chi nhánh nào có nhiều giao dịch rút tiền vào buổi chiều để chuẩn bị chuyển tiền
--tới. Hãy liệt kê danh sách các chi nhánh và lượng tiền rút trung bình theo ngày (chỉ xét những giao dịch diễn
--ra trong buổi chiều), sắp xếp giảm giần theo lượng tiền giao dịch. 

select Branch.BR_id,Branch.BR_name, avg(transactions.t_amount) as TienRutTB
From transactions join account on transactions.ac_no=account.Ac_no
Join customer on account.cust_id=customer.Cust_id
Join Branch on customer.Br_id=Branch.BR_id
where t_type='0'
Group by Branch.BR_id,Branch.BR_name
Order by TienRutTB desc