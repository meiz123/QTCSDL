use bank 
--•	Trước khi viết code, hãy đặt câu hỏi: Cần dùng bao nhiêu biến? Kiểu dữ liệu là gì?
/*1.	Viết đoạn code thực hiện việc chuyển đổi đầu số điện thoại di động theo quy định của bộ 
Thông tin và truyền thông cho một khách hàng bất kì, ví dụ với: Dương Ngọc Long*/
--3 biến
--input: tên khách hàng 
--process:	tìm số điện thoại của khách hàng custname= tên khách hàng 
--			nếu sdt 10 số thì giữ nguyên còn nếu là 11 số thì
--			các đầu số cũ của nhà mạng chuyển thành các đầu số mới theo quy định
--				  '0120' thành '070'
					--0121' thành '079'
					--0122' thành '077'
					--0126' thành '076'
					--0128' thành '078'
					--'0123' thành '083'
					--'0124%' then '084'
					--'0125%' then '085'
					--'0127%' then '081'
					--'0129%' then '082'
					--'0162%' then '032'
					--'0163%' then '033'
					--'0164%' then '034'
					--'0165%' then '035'
					--'0166%' then '036'
					--'0167%' then '037'
					--'0168%' then '038'
					--'0169%' then '039'
					--'0186%' then '056'
					--'0188%' then '058'
					--'0199%' then '059'
--output: số điện thoại của khách hàng được chuyển từ 11 số sang 10 số, số điện thoại đã được update 
declare @sdt varchar(11), @doi char(3),@sdtmoi char(10)
select @sdt= Cust_phone from customer where Cust_name=N'Dương Ngọc Long'
set @doi=
			case
			--mobi
				when @sdt like '0120%' then '070'
				when @sdt like '0121%' then '079'
				when @sdt like '0122%' then '077'
				when @sdt like '0126%' then '076'
				when @sdt like '0128%' then '078'
			--vina
				when @sdt like '0123%' then '083'
				when @sdt like '0124%' then '084'
				when @sdt like '0125%' then '085'
				when @sdt like '0127%' then '081'
				when @sdt like '0129%' then '082'
			--viettel
				when @sdt like '0162%' then '032'
				when @sdt like '0163%' then '033'
				when @sdt like '0164%' then '034'
				when @sdt like '0165%' then '035'
				when @sdt like '0166%' then '036'
				when @sdt like '0167%' then '037'
				when @sdt like '0168%' then '038'
				when @sdt like '0169%' then '039'
			--vietnamobile
				when @sdt like '0186%' then '056'
				when @sdt like '0188%' then '058'
			--Gmobile
				when @sdt like '0199%' then '059'
			end

update customer set Cust_phone=
Case
	when len(@sdt)=11 then @doi + right(@sdt,7)
	else @sdt
end
from customer
where Cust_name=N'Dương Ngọc Long'

--2.	Trong vòng 10 năm trở lại đây Nguyễn Lê Minh Quân có thực hiện giao dịch nào không? 
--Nếu có, hãy trừ 50.000 phí duy trì tài khoản. 
--input: Kh Nguyễn Lê Minh Quân 
--output: in ra kết quả Kh có thực hiện giao dịch trong vòng 10 năm hay không. Nếu có update -50000 phí duy trì tài khoản 
--process:	
--			B1: Đếm số giao dịch khách hàng Nguyễn Lê Minh Quân thực hiện trong vòng 10 năm 
--			B2: Tìm số tài khoản của Kh Nguyễn Lê Minh Quân
--			B3: kiểm tra số giao dịch khách hàng thực hiện trong vòng 10 năm 
--			B3a: Nếu số giao dịch >0: update trừ 50000 phí duy trì tài khoản. In kq đã -50000 phí duy trì tài khoản
		--	B3b: Nếu không thực hiện giao dịch trong vòng 10 năm thì giữ nguyên . In ra kết quả không thực hiện giao dịch nào trong vòng 10 năm

declare @count int , @ret nvarchar(50),@acno int
set @count=(Select count (t_id) 
			from account	join customer on account.cust_id=customer.Cust_id
							join transactions on account.Ac_no=transactions.ac_no
			where Cust_name like N'Nguyễn Lê Minh Quân'and
			Year(t_date)<DATEADD(year,-10,getdate()))
Select @acno=account.Ac_no
from account join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Nguyễn Lê Minh Quân'
If @count > 0
Begin
    Update account 
    Set ac_balance = ac_balance - 50000 
    Where Ac_no = @acno
    Set @ret = N'Đã trừ 50.000 phí duy trì tài khoản'
end
else
Begin
    Set @ret = N'Không có giao dịch nào trong vòng 10 năm';
end
Print @ret
Select ac_balance from account	join customer on account.cust_id=customer.Cust_id
							join transactions on account.Ac_no=transactions.ac_no
			where Cust_name like N'Nguyễn Lê Minh Quân'

--3.	Trần Quang Khải thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) 
--và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông)?
--Trước khi viết code, hãy đặt câu hỏi: Cần dùng bao nhiêu biến? Kiểu dữ liệu là gì?
--Dùng 4 biến biến thứ, biến mùa, biến tìm ngày giao dịch, biến in kq

--Declare @thu nvarchar(25), @mua nvarchar(25), @giaoDich date, @ref nvarchar(50)
--Select @giaoDich =	(select max(t_date) 
--					from transactions	join account on transactions.ac_no= account.Ac_no
--										join customer on account.cust_id=customer.Cust_id
--					where Cust_name like N'Trần Quang Khải')
--		SET @thu = CASE DATEPART(dw, @giaoDich)
--            WHEN 1 THEN N'Chủ nhật'
--            WHEN 2 THEN N'Thứ hai'
--            WHEN 3 THEN N'Thứ ba'
--            WHEN 4 THEN N'Thứ tư'
--            WHEN 5 THEN N'Thứ năm'
--            WHEN 6 THEN N'Thứ sáu'
--            ELSE N'Thứ bảy'
--            END
--		SET @mua = CASE 
--					WHEN DATEPART(MONTH, @giaoDich) BETWEEN 3 AND 5 THEN N'Mùa xuân'
--					WHEN DATEPART(MONTH, @giaoDich) BETWEEN 6 AND 8 THEN N'Mùa hạ'
--					WHEN DATEPART(MONTH, @giaoDich) BETWEEN 9 AND 11 THEN N'Mùa thu'
--					ELSE N'Mùa đông'
--					END
--print concat(N'Ngày giao dịch: ' +@thu, N' Mùa giao dịch: ' +@mua)

--4.	Đưa ra nhận xét về nhà mạng mà Lê Anh Huy đang sử dụng? 
--(Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)
--Trước khi viết code, hãy đặt câu hỏi: Cần dùng bao nhiêu biến? Kiểu dữ liệu là gì?
--Dùng 2 biến :truy vấn sdt varchar(11) và in kq varchar(50) 

--Declare @phone varchar(11), @kq nvarchar(50)
--Select  @phone=Cust_phone
--From customer
--where Cust_name like N'Lê Anh Huy'
--set @kq = case 
--when left(@phone,4) in ('0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169') 
--	then N'Lê Anh Huy dùng nhà mạng Viettel'
--when left(@phone,4) in ('0120','0121','0122',	'0126',	'0128')
--	then N'Lê Anh Huy dùng nhà mạng Mobiphone'
--when left(@phone,4) in ('0127', '0129', '0123', '0124', '0125')
--	then N'Lê Anh Huy dùng nhà mạng Vinaphone'
--when left(@phone,4) in ('0186','0188')
--	then N'Lê Anh Huy dùng nhà mạng Vietnamobile'
--else N'Lê Anh Huy dùng nhà mạng khác'
--End
--Print @kq

--5.	Số điện thoại của Trần Quang Khải là số tiến, số lùi hay số lộn xộn. 
--Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến

--Trước khi viết code, hãy đặt câu hỏi: Cần dùng bao nhiêu biến? Kiểu dữ liệu là gì?
--
--biến ktSDT varchar(9), @dem INT, @tang INT, @giam INT, @khac INT;

DECLARE @ktSDT VARCHAR(9), @dem INT, @tang INT, @giam INT, @khac INT;
SELECT @ktSDT =  RIGHT(Cust_phone, 8)
FROM customer
where Cust_name like N'Trần Quang Khải'
SET @dem = 0;
SET @tang = 0;
SET @giam = 0;
SET @khac = 0;

WHILE @dem < LEN(@ktSDT)
BEGIN
    IF SUBSTRING(@ktSDT, @dem + 1, 1) < SUBSTRING(@ktSDT, @dem + 2, 1)
    BEGIN
        SET @tang = @tang + 1;
    END
    ELSE IF SUBSTRING(@ktSDT, @dem + 1, 1) > SUBSTRING(@ktSDT, @dem + 2, 1)
    BEGIN
        SET @giam = @giam + 1;
    END
    ELSE
    BEGIN
        SET @khac = @khac + 1;
    END

    SET @dem = @dem + 1;
END
IF @tang = len (@ktSDT)-1
BEGIN
    PRINT N'Tăng';
END
ELSE IF @giam = len (@ktSDT)-1
BEGIN
    PRINT N'Giảm';
END
ELSE
BEGIN
    PRINT N'Hỗn hợp';
END;


--6.	Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?
--Trước khi viết code, hãy đặt câu hỏi: Cần dùng bao nhiêu biến? Kiểu dữ liệu là gì?
--ba biến

--Declare @buoi nvarchar(25), @giaoDich datetime
--Select @giaoDich =	(select max(t_time) 
--					from transactions	join account on transactions.ac_no= account.Ac_no
--										join customer on account.cust_id=customer.Cust_id
--					where Cust_name like N'Hà Công Lực')
--		SET @buoi = CASE 
--            WHEN DATEPART(HOUR, @giaoDich) between 6 and 10  THEN N'Sáng'
--            WHEN DATEPART(HOUR, @giaoDich) between 11 and 13 THEN N'Trưa'
--            WHEN DATEPART(HOUR, @giaoDich) between 14 and 17 THEN N'Chiều'
--			WHEN DATEPART(HOUR, @giaoDich) between 18 and 21 THEN N'Tối'
--            ELSE N'Đêm'
--            END
--print (N'Buoi giao dịch: ' +@buoi)

--7.	Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào? 
--Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.
-- 1 biến
--Declare @tenCN varchar(30)
--Select @tenCN= left(Br_id,2)
--From customer
--where Cust_name like N'Trương Duy Tường'
--If @tenCN like N'VN' 
--	Begin 
--		print N'Chi Nhánh NH: Miền Nam'
--	end
--else if @tenCN like N'VT'
--	Begin 
--		print N'Chi Nhánh NH: Miền Trung'
--	end
--else if @tenCN like N'VT'
--	Begin 
--		print N'Chi Nhánh NH: Miền Bắc'
--	end
--else 
--	Begin
--		print N'Mã Chi Nhánh sai'
--	end

--8.	Căn cứ vào số điện thoại của Trần Phước Đạt, 
--hãy nhận định anh này dùng dịch vụ di động của hãng nào: Viettel, Mobi phone, Vina phone, hãng khác.

--Declare @phone varchar(11), @kq nvarchar(50)
--Select  @phone=Cust_phone
--From customer
--where Cust_name like N'Trần Phước Đạt'
--set @kq = case 
--when left(@phone,4) in ('0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169') 
--	then N'Trần Phước Đạt dùng nhà mạng Viettel'
--when left(@phone,4) in ('0120','0121','0122',	'0126',	'0128')
--	then N'Trần Phước Đạt dùng nhà mạng Mobiphone'
--when left(@phone,4) in ('0127', '0129', '0123', '0124', '0125')
--	then N'Trần Phước Đạt dùng nhà mạng Vinaphone'
--when left(@phone,4) in ('0186','0188')
--	then N'Trần Phước Đạt dùng nhà mạng Vietnamobile'
--else N'Trần Phước Đạt dùng nhà mạng khác'
--End
--Print @kq

--9.	Hãy nhận định Lê Anh Huy ở vùng nông thôn hay thành thị. 
--Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”
--2 biến
--input: Kh Lê Anh Huy
--output: in ra kết quả KH ở nông thôn hay thành thị 
--process:	1.tìm địa chỉ khách hàng tên là lê huy anh 
--			2a. Nếu địa chỉ chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện” thì in kq vùng nông thôn
--			2.b. ngược lại in ra vùng thành thị

Declare @dC Nvarchar(30), @kQ Nvarchar(30)
Select @dC=Cust_ad
From customer
where Cust_name like N'Lê Anh Huy'
set @kQ= case	when @dC like N'%thôn %' then N'Vùng nông thôn'
				when @dC like N'%xóm%' then N'Vùng nông thôn'
				when @dC like N'% xã %' then N'Vùng nông thôn'
				when @dC like N'%đội%' then N'Vùng nông thôn'
				when @dC like N'%huyện%' then N'Vùng nông thôn'
				when @dC like N'%thôn %' then N'Vùng nông thôn'
				Else N'Vùng thành thị' end
print N'Lê Anh Huy ở ' +@kQ

--10.	Hãy kiểm tra tài khoản của Trần Văn Thiện Thanh, 
--nếu tiền trong tài khoản của anh ta nhỏ hơn không 
--hoặc bằng không nhưng 6 tháng gần đây không có giao dịch thì 
--hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’


--11.	Mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ? 
 
--declare @mGD char(10),@kq varchar (20)
--select @mGD=t_id
--From transactions	join account on transactions.ac_no=account.Ac_no
--					join customer on account.cust_id=customer.Cust_id
--where Cust_name Like N'Huỳnh Tấn Dũng'
--set @kq= case	when CONVERT(int,@mGD) % 2 =0 then N'Chia hết'
--				else N'Không chia hết' end
--print @kq


--12.	Có bao nhiêu giao dịch diễn ra trong tháng 9/2016 với tổng tiền mỗi loại là bao nhiêu 
--(bao nhiêu tiền rút, bao nhiêu tiền gửi)
--Declare @soGD int,@tienRut numeric(15,0), @tienGui numeric(15,0)
--Select	@soGD=count(t_id),
--		@tienRut=sum(case when t_type='0' then t_amount else 0 end),
--		@tienGui=sum(case when t_type='1' then t_amount else 0 end)
--From transactions
--where YEAR(t_date)=2016 and MONTH(t_date)=9
--Print concat (N'Tong GD ' ,@soGD)
--Print concat (N'Tong tien rut ',@tienRut)
--Print concat (N'Tong tien gui ',@tienGui)

--13.	Ở Hà Nội ngân hàng Vietcombank có bao nhiêu chi nhánh và có bao nhiêu khách hàng? 
--Trả lời theo mẫu: “Ở Hà Nội, Vietcombank có … chi nhánh và có …khách hàng”

--Declare @soCN int, @soKH int
--Select	@soKH =count(cust_id),
--		@soCN=count(BR_ad)
--From customer join Branch on customer.Br_id= Branch.BR_id
--where BR_name like N'%Hà Nội'
--print concat (N'Ở Hà Nội, Vietcombank có ',@soCN, N' chi nhánh và có ',@soKH,N' khách hàng')

--14.	Tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? 
--Tài khoản này thuộc chi nhánh nào?

--3 biến
Declare @tenKh Nvarchar(30),@soTien int, @tenCN Nvarchar(30)
select top 1 @tenKh=Cust_name, @soTien=ac_balance,@tenCN=Branch.BR_name
From account	join customer on account.cust_id=customer.Cust_id
				join Branch on Branch.BR_id=customer.Br_id
order by ac_balance desc
print @tenKh
Print @soTien
Print @tenCN

--15.	Có bao nhiêu khách hàng ở Đà Nẵng?
--1 biến
--declare @demKh int 
--Select @demKh=count(cust_id)
--from customer
--where Cust_ad like N'%Đà Nẵng'
--print @demKh

--16.	Có bao nhiêu khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn
--1 biến

Declare @count int
Select @count=count (cust_id)
From customer join Branch on customer.Br_id=Branch.BR_id
where Cust_ad like N'%Quảng Nam'

--17.	Ai là người thực hiện giao dịch có mã số 0000000387, thuộc chi nhánh nào? Giao dịch này thuộc loại nào?
--3 biến

Declare @who Nvarchar(30), @cN Nvarchar(30), @type int
select @who=Cust_name, @cN=BR_name, @type =t_type	
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
					Join Branch on customer.Br_id=Branch.BR_id
where t_id ='0000000387'
Print @who
Print @cN
Print @type

--18.	Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. 
--Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường”

declare @ds table  (Hovaten nvarchar(50),
					sdt varchar(15),
					sltk int,
					nhanxet nvarchar(30))
Insert into @ds select	Cust_name, Cust_phone, COUNT(Ac_no), 
						IIF(COUNT(ac_no) < 1, N'Bất thường', N'Bình thường')
				from customer join account on customer.Cust_id = account.cust_id
				group by Cust_name, Cust_phone
select * from @ds

--19.	Viết đoạn code nhận xét tiền trong tài khoản của ông Hà Công Lực. 
--<100.000: ít, < 5.000.000  trung bình, còn lại: nhiều
--2 biến
Declare @tien int, @nhanxet Nvarchar(30)
Select @tien= account.ac_balance
From account join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Hà Công Lực'

Set @nhanxet = case when @tien<100000 then N'ít'
					when 100000 <=@tien and @tien<5000000 then N'trung bình'
					Else N'nhiều' end
print concat (N'Tiền trong tài khoản của ông Hà Công Lực ', @nhanxet)

--20.	Hiển thị danh sách các giao dịch của chi nhánh Huế với các thông tin: 
--mã giao dịch, thời gian giao dịch, số tiền giao dịch, loại giao dịch (rút/gửi), số tài khoản. 

Declare @bang table (MaGD varchar(15),
					thoigianGD datetime,
					sotienGD int,
					loaiGD Nvarchar(10),
					Sotaikhoan varchar(20))
insert into @bang	select	t_id as MaGD,
							cast (t_date as datetime)+cast(t_time as datetime) as thoigianGD,
							t_amount as sotienGD,
							iif(t_type ='1',N'Gửi',N'Rút') as loaiGD,
							transactions.ac_no as Sotaikhoan 
					from transactions	join account on transactions.ac_no=account.Ac_no
										join customer on customer.Cust_id=account.cust_id
										Join Branch on Branch.BR_id= customer.Br_id
					where Branch.BR_name like N'%Huế'
select * from @bang

--21.	Kiểm tra xem khách hàng Nguyễn Đức Duy có ở Quang Nam hay không?
--2 biến
--Declare @kt nvarchar(30), @dc Nvarchar(50)
--Select @dc=Cust_ad
--From customer
--where Cust_name like N'Nguyễn Đức Duy'

--Set @kt = case	when @dc like N'% Quảng Nam' then N'KH ở QN'
--				else N'Kh không ở QN' end
--print @kt


--22.	Điều tra số tiền trong tài khoản ông Lê Quang Phong có hợp lệ hay không? 
--(Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). 
--Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản 
--khớp với tổng số tiền đã giao dịch (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)

--4 biến
--Declare @tongtiengui int, @tongtienrut int, @sotienHT int, @kq Nvarchar(30)
--Select	@sotienHT=account.ac_balance,
--		@tongtiengui= SUM(IIF(transactions.t_type = '1', t_amount, 0)) ,  
--		@tongtienrut= SUM(IIF(transactions.t_type = '0', t_amount, 0))  
--From transactions	join account on transactions.ac_no=account.Ac_no
--					join customer on account.cust_id=customer.Cust_id
--where Cust_name like N'Lê Quang Phong'
--group by ac_balance
--if @sotienHT=@tongtiengui-@tongtienrut
--Begin 
--	set @kq=N'Hợp lệ'
--end
--Else 
--Begin 
--	update account
--	Set ac_balance=@tongtiengui-@tongtienrut
--	From account	join transactions on transactions.ac_no=account.Ac_no
--					join customer on customer.Cust_id=account.cust_id
--	where Cust_name like N'Lê Quang Phong'

--	Set @kq=N'Không hợp lệ, đã cập nhật lại '
--End

--Print @kq

--23.	Chi nhánh Đà Nẵng có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không? 
--Nếu có, hãy hiển thị số lần giao dịch, nếu không, hãy đưa ra thông báo “không có”
--1 biến 
declare @soGD int
Select @soGD=COUNT(t_id)
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
					Join Branch on customer.Br_id=Branch.BR_id
where DATEPART(dw, t_date)=1 and Branch.BR_name like N'%Đà Nẵng'

If @soGD>0 
Begin 
	print concat (N'Số GD: ',@soGD)
end
Else 
Begin 
	print N'Không có'
end

--24.	Kiểm tra xem khu vực miền bắc có nhiều phòng giao dịch hơn khu vực miền trung ko?
--Miền bắc có mã bắt đầu bằng VB, miền trung có mã bắt đầu bằng VT
--3 biến 
Declare @kq Nvarchar(50), @mb int, @mt int
Select	@mb=COUNT(iif(BR_id like 'VB%',1,0)),
		@mt=COUNT(iif(BR_id like 'VT%',1,0))
from Branch
set @kq = case	when @mb>@mt then N'MB có nhiều phòng giao dịch hơn MT'
				when @mt>@mb then N'MT có nhiều phòng giao dịch hơn MB'
				Else N'MT và MB có số phòng giao dịch bằng nhau' end
print @kq
			

------------------------------------------------------------------------------------------------		
--1.	In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn
--Declare @i int, @n int
--set @i=1
--set @n=10
--while @i <=@n
--begin 
--	print @i
--	Set @i=@i+2
--End

--2.	In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn
--Declare @i int, @n int
--set @i=2
--set @n=10
--while @i <=@n
--begin 
--	print @i
--	Set @i=@i+2
--End

--3.	In ra 100 số đầu tiền trong dãy số Fibonaci

Declare @so int, @i numeric(35,0) ,@j numeric(35,0)
Set @so=0
Set @i=0
Set @j=1
while @so<=100
Begin 
	set @i=@i+@j
	Set @j=@i
	Print @i
	Set @so=@so +1
end

--4.	In ra tam giác sao: 1 tam giác vuông, 1 tam tam giác cân 

declare @tm varchar(10),@kt varchar(10), @count1 int 
Set @kt='*'
Set @tm='*'
Set @count1=1
while @count1 <=5
Begin 
	print @tm
	Set @tm=@tm+@kt
	set @count1 = @count1+1
End

--5.	In bảng cửu chương
declare @i int, @j int
Set @i=2
while @i<10
Begin 
	Set @j=1
	while @j<=10
		begin 
			PRINT cast(@i as nvarchar(2)) + ' x ' + cast(@j as nvarchar(2)) + ' = ' + cast(@i * @j as nvarchar(3))
			Set @j=@j+1
		End
		Print ''
		Set @i=@i+1
End


