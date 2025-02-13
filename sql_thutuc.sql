use Bank
--return: dừng chạy trong thủ tục 
--1.	Chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin và truyền thông nếu biết mã khách của họ.
/*
	input: Mã khách hàng  
	output:  đầu số điện thoại được chuyển đổi. Update lại số điện thoại sau khi chuyển đổi
	Process:
			B1: Tìm khách hàng tên: Dương Ngọc Long
			B2a: chuyển đổi theo quy định sau:
							0120 thành 070
							0121 thành 079
							0122 thành 077
							0126 thành 076
							0128 thành 078
							0123 thành 083
							0124 thành 084
							0125 thành 085
							0127 thành 081
							0129 thành 082
							0162 thành 032
							0163 thành 033
							0164 thành 034
							0165 thành 035
							0166 thành 036
							0167 thành 037
							0168 thành 038
							0169 thành 039
							0186 thành 056
							0188 thành 058
							0199 thành 059
*/
create proc chuyendoidausotheomaKH (@maKH varchar(9))
as
Begin
	Declare @moi char(10), @doi varchar(15), @sdt varchar (15)
	select @sdt=Cust_phone
	From customer
	where cust_id=@maKH 
	set @doi = case when LEFT(@sdt,4) like '0120' then '070'
					when LEFT(@sdt,4) like '0121' then '079'
					when LEFT(@sdt,4) like '0122' then '077'
					when LEFT(@sdt,4) like '0126' then '076'	
					when LEFT(@sdt,4) like '0128' then '078'
					when LEFT(@sdt,4) like '0123' then '083'		
					when LEFT(@sdt,4) like '0124' then '084'	
					when LEFT(@sdt,4) like '0125' then '085'
					when LEFT(@sdt,4) like '0127' then '081'			
					when LEFT(@sdt,4) like '0129' then '082'		
					when LEFT(@sdt,4) like '0162' then '032'		
					when LEFT(@sdt,4) like '0163' then '033'			
					when LEFT(@sdt,4) like '0164' then '034'			
					when LEFT(@sdt,4) like '0165' then '035'	
					when LEFT(@sdt,4) like '0166' then '036'
					when LEFT(@sdt,4) like '0167' then '037'	
					when LEFT(@sdt,4) like '0168' then '038'
					when LEFT(@sdt,4) like '0169' then '039'
					when LEFT(@sdt,4) like '0186' then '056'		
					when LEFT(@sdt,4) like '0188' then '058'			
					when LEFT(@sdt,4) like '0199' then '059'			
				end
	set @moi = @doi+right(@sdt,7)	
	update customer
	set Cust_phone=@moi
	where cust_id=@maKH
End

Exec  chuyendoidausotheomaKH @maKH='000001'
Select * from customer


--2.	Kiểm tra trong vòng 10 năm trở lại đây khách hàng có thực hiện giao dịch nào không, nếu biết số tài khoản của họ? 
--Nếu có, hãy trừ 50.000 phí duy trì tài khoản. 
/* 
	input: số tài khoản
	output: xác nhận kết quả thực hiện (1: update, 0: loi/khong update)
	Process: 
			B1: Đếm số giao dịch của tài khoản. điều kiện : stk=ac_no và t_date>=DATEADD(year,-10,getdate())
			B2a: Nếu số giao dịch >0. update: trừ 50000 phí duy trì tài khoản.	-->output: thành công: 1, ngược lại: 0 
			B2b: Nếu SGD=0 không update											-->output:0
*/
--code 

Create or alter proc kiemtrasogdtrong10nam (@stk char(10), @kq Nvarchar(70) output)
As
Begin
	Declare @dem int

	Select @dem=(count(t_id))
	From transactions 
	where	transactions .Ac_no = @stk and 
			t_date>=DATEADD(year,-10,getdate())
			--cách viết khác dateiff(year, t_date, getdate())<=10 

	if @dem>0 
		Begin 
			update account
			set ac_balance=ac_balance-50000
			where Ac_no=@stk
			Set @kq='1'
		end
	Else if @dem=0
		Begin
			set @kq='0'
		End
	print @kq
End

Declare @kq Nvarchar(70)
Exec kiemtrasogdtrong10nam '1000000001',@kq output
Select * from account

--3.	Kiểm tra khách thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) và 
--vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông) nếu biết mã khách. 
/*
	input: mã khách hàng
	Output: In ra giao dịch gần đây nhất thực hiện vào thứ mấy (thứ hai, thứ ba, thứ tư,…, chủ nhật) và vào 
	mùa nào(mùa xuân, mùa hạ, mùa thu, mùa đông)
	process: 
			B1: Tìm giao dịch gần nhất được thực hiện của khách hàng
			B2: xác định giao dịch vào thứ mấy
			B3: Xác định giao dịch được thực hiện vào mùa nào
*/

Create proc c3 (@tenKH Nvarchar(30), @kq nvarchar(100) output)
As 
Begin
	declare @gdgn date, @thu Nvarchar(20), @mua nvarchar(20)
	Select @gdgn =max(t_date)
	From transactions	join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
	where Cust_name = @tenKH

	Set @thu=	case DATEPART(dw,@gdgn)
					when 1 then N'chủ Nhật'
					when 2 then N'thứ hai'
					when 3 then N'thứ ba'
					when 4 then N'thứ tư'
					when 5 then N'thứ năm'
					when 6 then N'thứ sáu'
					when 7 then N'thứ bảy'
				end
	set @mua =	case DATEPART(quarter,@gdgn)
					when 1 then 'mùa xuân'
					when 2 then 'mùa hạ'
					when 3 then 'mùa thu'
					when 4 then 'mùa đông'
				end
	set @kq= concat(N'Khách hàng thực hiện giao dịch gần nhất vào: ',@thu,', ',@mua)
End

Declare @kl nvarchar(100)
Exec c3 N'Trần Quang Khải', @kl output
print @kl

--4.	Đưa ra nhận xét về nhà mạng của khách hàng đang sử dụng nếu biết mã khách? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)
/*
	input: Tên khách hàng
	Output: In ra nhà mạng mà khách hàng đang sử dụng
	Process: 
			B1: Tìm số điện thoại của khách hàng
			B2: Kiểm tra số điện thoại 
			B2a: Nếu số điện thoại có 11 chữ số thì kiểm tra 4 chữ số đầu tiên 
				+Nếu thuộc các đầu số 0162, 0163, 0164, 0165, 0166, 0167, 0168, 0169 -->nhà mạng viettel
				+Nếu thuộc các đầu số 0120,0121,0122,0126,	0128 -->nhà mạng mobiphone
				+Nếu thuộc các đầu số 0127, 0129, 0123, 0124, 0125--> nhà mạng vinaphone
				+Nếu thuộc các đầu số 0186, 0188 -->nhà mạng Vietnamobile
				+Nếu không thì thuộc các nhà mạng khác 
			B2b: Nếu số điện thoại có 10 số thì kiểm tra 3 chữ số đầu tiên 
				+Nếu thuộc các đầu số 032,033,034,035,036,037,038,039 -->nhà mạng viettel
				+Nếu thuộc các đầu số 070,079,077,076,078-- nhà mạng mobiphone
				+Nếu thuộc các đầu số 083,084,085,081,082 --> nhà mạng vinaphone
				+Nếu thuộc các đầu số 056, 058 -->nhà mạng Vietnamobile
				+Nếu không thì thuộc các nhà mạng khác 
*/
--code 
Create proc c4 (@ten Nvarchar(50), @nhamang nvarchar(60) output)
As 
Begin 
	declare @phone varchar(11)
	Select @phone=Cust_phone
	From customer
	where Cust_name Like N'Lê Anh Huy'
	If len(@phone)=11 
		begin 
			if	left(@phone,4) in ('0162', '0163', '0164', '0165',' 0166',' 0167', '0168', '0169')
				set @nhamang =N'Nhà mạng viettel'
			else if left(@phone,4) in ('0120','0121','0122','0126',	'0128')
				set @nhamang=N'Nhà mạng mobiphone'
			else if left(@phone,4) in ('0127', '0129', '0123', '0124', '0125')
				set @nhamang=N'Nhà mạng vinaphone'
			else if left(@phone,4) in ('0186','0188')
				set @nhamang=N'Nhà mạng Vietnamobile'
			else set @nhamang=N'Nhà mạng khác'
		End
	else if len(@phone)=10
		begin
			if	left(@phone,3) in ('032', '033', '034', '035', '036', '037', '038', '039','096')
				set @nhamang =N'Nhà mạng viettel'
			else if left(@phone,3) in ('070', '079', '077', '076', '078')
				set @nhamang=N'Nhà mạng mobiphone'
			else if left(@phone,3) in ('083', '084', '085', '081', '082')
				set @nhamang=N'Nhà mạng vinaphone'
			else if left(@phone,3) in ('056', '058')
				set @nhamang=N'Nhà mạng Vietnamobile'
			else set @nhamang=N'Nhà mạng khác'
		End
	print @nhamang
End

Declare @nm nvarchar(60)
Exec c4 N'Lê Anh Huy',@nm output

--5.	Nếu biết mã khách, hãy kiểm tra số điện thoại của họ là số tiến, số lùi hay số lộn xộn. 
--Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến
/*
	input: tên khách hàng
	Output: In ra kết quả là số tiến hay số lùi hay số lộn xộn
	Process: 
			B1: tìm số điện thoại của khách hàng
			B2: lấy dãy số trừ 3 số đầu tiên của điện thoại 
			B3: khởi tạo vòng lặp xét dãy số 
			B3a: Nếu số sau liền kề lớn hơn hoặc bằng số trước  --> dãy số tiến 
			B3b: Nếu số sau nhỏ hơn hoặc bằng số trước liền kề  --> dãy số lùi
			B3c: Nếu không dãy số thuộc số lộn xộn
*/

Create proc c5 (@ten nvarchar (50),@kl Nvarchar(30) output )
As 
Begin
	declare @sdt5 varchar(11),@dayso varchar(8), @tang int, @giam int, @lx int, @count int 
	Select @sdt5=Cust_phone
	From customer
	where Cust_name = @ten

	set @dayso=	case when len (@sdt5)= 11 then right(@sdt5,8)
						else right(@sdt5,7)
				end
	set @count=1
	Set @tang=0
	Set @giam=0
	while @count<=len(@dayso)
		begin
			if SUBSTRING(@dayso,@count,1)<= SUBSTRING(@dayso,@count+1,1)
				begin
					set @tang=@tang+1
				End
			else if SUBSTRING(@dayso,@count,1)>= SUBSTRING(@dayso,@count+1,1)
				begin
					set @giam=@giam+1
				End
			set @count=@count+1
		end

	set @kl= case	when @tang=len(@dayso)-1 then N'Dãy số tăng'
					when @giam=len(@dayso)-1 then N'Dãy số giảm'
					Else N'Dãy số lộn xộn'
			end
	print @kl
End

Declare @kqc5 nvarchar(30)
Exec c5 N'Trần Quang Khải', @kqc5 output

--6.	Nếu biết mã khách, hãy kiểm tra xem khách thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?
/*
	input: mã khách hàng
	Output: in ra Kq khách hàng thực hiện giao dịch gần đây nhất vào buổi nào
	Process: 
			B1: Tìm giao dịch gần nhất của Hà Công Lực
			B2: Từ giờ của giao dịch xác định buổi giao dịch 
				+Nếu từ 6 đến 10 --> Sáng
				+Nếu từ	11 đến 13 -->Trưa
		        +Nếu từ 14 đến 17 --> Chiều
				+Nếu từ	18 đến 21 --> Tối
				+còn lại là đêm
*/
--code: 
Create proc c6 (@maKH varchar (10), @buoi Nvarchar(30) output)
As 
begin
	declare  @giogd datetime, @t_date date
	Select top 1 @t_date=t_date,@giogd =t_time
	From transactions	join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
	where customer.Cust_id=@maKH
	order by t_date DESC, t_time DESC
	SET @buoi = CASE 
				WHEN DATEPART(HOUR, @giogd) between 6 and 10  THEN N'Sáng'
				WHEN DATEPART(HOUR, @giogd) between 11 and 13 THEN N'Trưa'
				WHEN DATEPART(HOUR, @giogd) between 14 and 17 THEN N'Chiều'
				WHEN DATEPART(HOUR, @giogd) between 18 and 21 THEN N'Tối'
				ELSE N'Đêm'
				END
	print @buoi
End

Declare @b nvarchar (30)
Exec c6 N'000001', @b output

--7.	Nếu biết số điện thoại của khách, hãy kiểm tra chi nhánh ngân hàng mà họ đang sử dụng thuộc miền nào?
--Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.
/*
	input:  số điện thoại của khách
	Output: tên miền
	Process: 
			B1:Tìm br_id của khách, điều kiện cust_phone = số điện thoại
			B2: nếu br_id là 'VN%' : miền nam, 
							'VT%' : miền trung, 
							'VB%' : miền bắc, 
							còn lại: bị sai mã.
			-----> output param 
*/
Create or alter proc c7 (@sdt varchar(11), @mien Nvarchar(20) output)
as 
Begin 
	Declare  @maCN nvarchar(10)
	Select @maCN=customer.Br_id
	From customer
	where Cust_phone=@sdt

	Set @mien = case	when @maCN like 'VN%' then N'Miền nam'
						when @maCN like 'VT%' then N'Miền Trung'
						when @maCN like 'VB%' then N'Miền Bắc'
						Else N'Mã sai'
				end
	print @mien
End

Declare @m Nvarchar(20)
Exec c7 '01645500071', @m output

--8.	Căn cứ vào số điện thoại của khách, hãy nhận định vị khách này dùng dịch vụ di động của hãng nào:
--Viettel, Mobi phone, Vina phone, hãng khác.
--tương tự c4

--9.	Hãy nhận định khách hàng ở vùng nông thôn hay thành thị nếu biết mã khách hàng của họ. 
--Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”
/*
	input: mã khách hàng 
	ouput: in ra kq khách hàng ở vùng nông thôn hay thành thị
	Process: 
			B1: Tìm ra địa chỉ của khách hàng 
			B2: +Ở vùng nông thôn nếu địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc (“xã” không phải "thị xã") hoặc “huyện” 
*/
create proc c9 (@maKh varchar(10), @nd Nvarchar(50) output)
as
Begin 
	declare @dc Nvarchar(100)

	Select @dc=Cust_ad
	From customer
	where Cust_id=@maKh

	Set @nd =	case	when @dc like N'% thôn %' then N'nông thôn'
						when @dc like N'% xóm %' then N'nông thôn'
						when @dc like N'% đội %' then N'nông thôn'
						when @dc like N'% huyên %' then N'nông thôn'
						when (@dc like N'% xã %' and @dc not like N'% thị xã %') then N'nông thôn'
						Else N'thành thị'
				end
	print @nd

End

Declare @c9 nvarchar(50)
Exec c9 N'000001',@c9 output

--10.	Hãy kiểm tra tài khoản của khách nếu biết số điện thoại của họ. Nếu tiền trong tài khoản của họ nhỏ hơn không 
--hoặc bằng không nhưng 6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’
/*
	input: số điện thoại
	output: Cập nhật tình trạng tài khoản của kh
	process:  Tìm ra tài khoản của kh theo số điện thoại
			- Kiểm tra số tiền trong tk của khách hàng
			- Nếu số tiền =0 hoặc <0 và tk không giao dịch trong 6 tháng gần đây -> đóng tài khoản
			- cập nhật tk đó : ac_type ='k'

*/
create proc c10(@cust_phone varchar(15),@ac_type nvarchar(30) output)
as
begin
		declare @tkhoan varchar(20) , @tgian date,@loai varchar(30),@sogd int
		select @tkhoan=ac_balance,@tgian =t_date,@loai=ac_type, @sogd=t_amount
		from account join transactions on account.Ac_no=transactions.ac_no
					join customer on customer.Cust_id=account.cust_id
					where Cust_phone=@cust_phone
		if @tkhoan <0 or (@tkhoan =0 and datepart(month,getdate())-datepart(month,@tgian)<=6 and count(@sogd)=0)
		begin 
			update account
			set ac_type='K'
			from account join customer on account.cust_id=customer.Cust_id
			where Cust_phone=@cust_phone
			set @ac_type= N'Tài khoản đã bị đóng'
		end;
		else
		begin
			set @ac_type=  N'Tài khoản còn tồn tại'
		end;
end
declare @s nvarchar(30)
exec c10 '0935270776',@s output
print @s

--11.	Kiểm tra mã số giao dịch gần đây nhất của khách là số chẵn hay số lẻ nếu biết mã khách. 
/*
	input:  mã khách hàng
	output: in ra mã số giao dịch gần đây nhất của khách hàng là số chẵn hay số lẻ
	Process: 
			B1: tìm mã số giao dịch(t_id) gần đây nhất của khách hàng qua mã khách hàng
			B2: Lấy mã số gd chia cho 2 
			B2a: Nếu chia hết -->số chẵn
			B2b: Nếu chia dư --> số lẻ 
*/

Create proc c11 (@maKH varchar(11), @kqs Nvarchar (20)output)
As 
Begin 
	declare @mGD char(10), @t date
	select top 1   @mGD=(t_id), @t=(t_date)
	From transactions	join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
	where customer.Cust_id=@maKH
	Order by t_date desc
	set @kqs= case	when CONVERT(int,@mGD) % 2 =0 then N'Số chẵn'
					else N'Số lẻ' end
	print @kqs
End

Declare @c11 Nvarchar (20)
Exec c11 '000024', @c11 output

--12.	Trả về số lượng giao dịch diễn ra trong khoảng thời gian nhất định (tháng, năm), 
--tổng tiền mỗi loại giao dịch là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)
/*
	input : thời gian nhất định tháng,năm
	Output: Thống kê số giao dịch diễn ra trong thời gian trên 
			Thống kê tổng tiền rút trong thời gian trên 
			Thống kê tổng tiền gửi trong thời gian trên 
	process: 
			B1: tìm tất cả các giao dịch trong thời gian đó
			B2: Đếm số giao dịch trong thời gian đó
			B3: tính tổng tiền rút, gửi
*/
create proc c12 (@thang int, @nam int, @kq nvarchar(70) output)
As 
Begin
	Declare @soGD int,@tienRut numeric(15,0), @tienGui numeric(15,0)
	Select	@soGD=count(t_id),
			@tienRut=sum(case when t_type='0' then t_amount else 0 end),
			@tienGui=sum(case when t_type='1' then t_amount else 0 end)
	From transactions
	where YEAR(t_date)=@nam and MONTH(t_date)=@thang
	set @kq= concat (N'Tong GD: ' ,@soGD,N', tong tien rut: ',@tienRut,N' tong tien gui: ', @tienGui)
End

Declare @12 nvarchar(70)
exec c12 6,2015,@12 output
Print @12

--12.	Trả về số lượng giao dịch diễn ra trong khoảng thời gian nhất định (tháng, năm), 
--tổng tiền mỗi loại giao dịch là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)
/*
	input : thời gian nhất định tháng,năm
	Output: trả về số giao dịch diễn ra trong thời gian trên 
			trả về tổng tiền rút trong thời gian trên 
			trả về tổng tiền gửi trong thời gian trên 
	process: 
			
*/
create or alter proc gd_thongke (@thoigian varchar(20), @thongke nvarchar(60) output)
As 
Begin 
	declare @year int, @month int, @tongrut numeric(15,0), @tonggui numeric(15,0),@sogd int
	if @thoigian like '%[-,/]%'
		begin
			if @thoigian like '%/%'
			Begin 
				set @year = right (@thoigian, 4)
				set @month = left(@thoigian, CHARINDEX('/',@thoigian) - 1)
			End
			Else if @thoigian like '%-%'
			Begin 
				set @year = right (@thoigian, 4)
				set @month = left(@thoigian, CHARINDEX('-',@thoigian) - 1)
		End
	Else 
		Begin
			set @year=@thoigian
			set @month=null
		End
	if @month is not null
		begin
			Select	@soGD=count(t_id),
					@tongrut=sum(case when t_type='0' then t_amount else 0 end),
					@tonggui=sum(case when t_type='1' then t_amount else 0 end)
			From transactions
			where YEAR(t_date)=@year and MONTH(t_date)=@month
		End
	else 
		begin 
			Select	@soGD=count(t_id),
					@tongrut=sum(case when t_type='0' then t_amount else 0 end),
					@tonggui=sum(case when t_type='1' then t_amount else 0 end)
			From transactions
			where YEAR(t_date)=@year 
		End
	End
	set @thongke= concat (N'Tong GD: ' ,@soGD,N', tong tien rut: ',@tongrut,N' tong tien gui: ', @tonggui)	
End 
declare @kqc12 nvarchar(60) 
Exec gd_thongke '09-2016', @kqc12 out
Print @kqc12
--13.	Trả về số lượng chi nhánh ở một địa phương nhất định.
/*
	input: tên địa phương 
	Output: in ra kêt quả “Ở [tên địa phương], Vietcombank có … chi nhánh và có …khách hàng”
	Process: 
			B1: Đếm số chi nhánh và số Kh hiện có tại địa phương
*/

Create proc c13 (@tendiaphuong nvarchar(50), @kq nvarchar(100) output)
As 
Begin 
	Declare @soCN int, @soKH int
	Select	@soKH =count(cust_id),
			@soCN=count(BR_ad)
	From customer join Branch on customer.Br_id= Branch.BR_id
	where BR_name like N'%'+ @tendiaphuong
	set @kq= concat (N'Ở ',@tendiaphuong, N', Vietcombank có ',@soCN, N' chi nhánh và có ',@soKH,N' khách hàng')
	Print @kq
End
Declare @c13 nvarchar(100)
Exec c13 N'Huế',@c13 output

--14.	Trả về tên khách hàng có nhiều tiền nhất là trong tài khoản, số tiền hiện có trong tài khoản đó là bao nhiêu? 
--Tài khoản này thuộc chi nhánh nào?
/*
	input: bảng account, customer, branch
	output: in ra tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? 
			Tài khoản này thuộc chi nhánh nào?
	process: 
			B1: thực hiện nối các bảng 
			B2: lấy top1 theo thứ tự được sắp xếp từ trên xuống dưới 
*/
create proc c14 (@kq nvarchar(200) output)
As 
begin
	Declare @tenKh Nvarchar(30),@soTien int, @tenCN Nvarchar(30)
	select top 1 @tenKh=Cust_name, @soTien=ac_balance,@tenCN=Branch.BR_name
	From account	join customer on account.cust_id=customer.Cust_id
					join Branch on Branch.BR_id=customer.Br_id
	order by ac_balance desc
	set @kq= concat (N'Khách hàng có nhiều tiền nhất trong tài khoản là: ',@tenKh,N' , số tiền: ',@soTien,N' , tên chi nhánh : ', @tenCN)
	print @kq
End

Declare @c14 nvarchar(200) 
Exec c14 @c14 output


--15.	Trả về số lượng khách của một chi nhánh nhất định.
/*
	input: tên chi nhánh 
	output: in ra số khách hàng ở chi nhánh 
	process: 
			B1: kiểm tra tên chi nhánh có tồn tại không
			B1a: Nếu tên chi nhánh không có tên trong danh sachs thì in ra 'không tồn tại tên chi nhánh'
			B1b: Nếu tên chi nhánh tồn tại, đếm số khách hàng tại chi nhánh 
*/
Drop proc c15
create proc c15 (@tenchinhanh nvarchar(50),@kq nvarchar(150) output)
As
Begin
	declare @kt int,@dem int

	select @kt=COUNT(*)
	From Branch 
	where BR_name like N'%'+@tenchinhanh
	if @kt>0
		Begin
			Select @dem=COUNT(cust_id)
			From customer join Branch on customer.Br_id=Branch.BR_id
			where BR_name like N'%'+@tenchinhanh
			Set @kq=concat( N'Số khách hàng ở chi nhánh ',@tenchinhanh, N' là: ',@dem)
		End
	else if @kt=0
		begin
			Set @kq=N'Không tồn tại tên chi nhánh'
		End
End

DECLARE @c15 nvarchar(150);
EXEC c15 N'Sài Gòn', @c15 output
Print @c15

--16.	Tìm tên, số điện thoại, chi nhánh của khách thực hiện giao dịch, nếu biết mã giao dịch.
/*
	input: mã giao dịch 
	Output: in ra tên, số điện thoại, chi nhánh của khách thực hiện giao dịch
	Process:	B1:kiểm tra mã giao dịch có tồn tại không
				B1a:Nếu tồn tại, tìm tên, số điện thoại, chi nhánh của khách thực hiện giao dịch
				B1b: Nếu không, in ra không tồn tại mã giao dịch 
*/

Create proc c16(@magd varchar(15), @kq nvarchar(150) output)
As
Begin
	declare @kt int,@ten nvarchar(50), @sdt varchar(15), @cn varchar(50)
	select @kt=COUNT(*)
	From transactions 
	where t_id=@magd
	if @kt>0
		Begin
			Select @ten=customer.Cust_name, @sdt=Cust_phone, @cn= Branch.BR_name
			From transactions	join account on transactions.ac_no=account.Ac_no
								join customer on account.cust_id=customer.Cust_id
								Join Branch on customer.Br_id= Branch.BR_id
			where t_id=@magd
			Set @kq=concat( N'Tên khách hàng: ',@ten, N', SĐT:  ',@sdt, N', tên chi nhánh: ',@cn)
		End
	else if @kt=0
		begin
			Set @kq=N'Không tồn tại mã giao dịch'
		End
End

Declare @c16 nvarchar(150)
Exec c16 '0000000201', @c16 output
Print @c16

--17.	Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. 
--Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường”
/*
	input: Không có 
	Output:Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét(“Bất thường”, “Bình thường”)
	Process:	b1: Tạo biến bảng gồm các cột: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét
				b2: chèn dữ liệu vào bảng :lấy dữ liệu của các cột tương ứng từ hai bảng customer và account
				B3: in kết quả
*/

Create proc c17
As 
Begin
	declare @ds table  (Hovaten nvarchar(50),
						sdt varchar(15),
						sltk int,
						nhanxet nvarchar(30))
	Insert into @ds select	Cust_name,
							Cust_phone,
							COUNT(Ac_no), 
							IIF(COUNT(ac_no) < 1, N'Bất thường', N'Bình thường')
					from customer join account on customer.Cust_id = account.cust_id
					group by Cust_name, Cust_phone
	select * from @ds
End
exec c17

--18.	Nhận xét tiền trong tài khoản của khách nếu biết số điện thoại. <100.000: ít, < 5.000.000  trung bình, còn lại: nhiều
/*
	input: số điện thoại khách hàng
	Output:in ra nhận xét tiền trong tài khoản của khách nhiều, ít hay trung bình
	Process: 
			B1:
*/
Create proc c18 (@sdt varchar(11), @kq Nvarchar(150) output)
As
Begin
	Declare @tien int, @ten Nvarchar(40), @nhanxet Nvarchar(30)
	Select @tien= account.ac_balance, @ten=Cust_name
	From account join customer on account.cust_id=customer.Cust_id
	where Cust_phone=@sdt

	Set @nhanxet = case when @tien<100000 then N'ít'
						when 100000 <=@tien and @tien<5000000 then N'trung bình'
						when 5000000<=@tien then N'nhiều' end
	set @kq= concat (N'Tiền trong tài khoản của ',@ten, ': ',@nhanxet)
	Print @kq
End

declare @c18 Nvarchar(150)
Exec c18 '01282157875',@c18 output

--19.	Kiểm tra khách hàng đã mở tài khoản tại ngân hàng hay chưa nếu biết họ tên và số điện thoại của họ.
select * from customer 
where cust_id not in (select Cust_id from account)
/*
	input:họ tên và số điện thoại Kh
	output: in ra kết quả khách hàng đã mở tài khoản hay chưa
	Process: 
			b1: từ tên tìm ra cust_id 
			B1a: nếu không tìm thấy thì in ra không tồn tại kh 
			B1b: nếu cust_id có trong bảng account --> khách hàng đã mở tài khoản. Ngược lại khách hàng chưa mở tài khoản
*/

create proc c19 (@ten nvarchar(40), @sdt nvarchar(11),@kq nvarchar(50) output)
As
Begin 
	declare @cust_id varchar(10), @dem int
	Select @cust_id = Cust_id
	From customer
	where Cust_name like @ten and Cust_phone=@sdt 
	If @cust_id is null or len(@cust_id)=0
	Begin
		set @kq= N'Khách hàng không có trong danh sách'
	End
	Else 
	Begin
		select @dem= count(cust_id) from customer 
		where Cust_id=@cust_id and cust_id in (select Cust_id from account)
		If @dem>0
			begin
				set @kq= N'Khách hàng đã mở tài khoản'
			end
		else if @dem=0 set @kq=N'Khách hàng chưa mở tài khoản'
	End
End

Declare @c19 nvarchar(50)
exec c19 N'Trần Đức Quý','01638843209',@c19 output
print @c19

--20.	Điều tra số tiền trong tài khoản của khách có hợp lệ hay không nếu biết mã khách? 
--(Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). 
--Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với 
--tổng số tiền đã giao dịch (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)

/*
	input: mã khách
	Output: In ra kết quả hợp lệ (tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản) hoặc update số tiền
	Process: 
			B1: kiểm tra số tiền trong tài khoản khách hàng 
			B1a:nếu tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản--> In ra 'Hợp lệ'
			B1b: Ngược lại cập nhật lại tài khoản (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)
*/

Create proc c20 (@maKH varchar(10),@kq nvarchar(50) output)
As 
Begin
	Declare @tongtiengui int, @tongtienrut int, @sotienHT int
	Select	@sotienHT=account.ac_balance,
			@tongtiengui= SUM(IIF(transactions.t_type = '1', t_amount, 0)) ,  
			@tongtienrut= SUM(IIF(transactions.t_type = '0', t_amount, 0))  
	From transactions	join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
	where customer.Cust_id =@maKH
	group by ac_balance
	if @sotienHT=@tongtiengui-@tongtienrut
	Begin 
		set @kq=N'Hợp lệ'
	end
	Else 
	Begin 
		update account
		Set ac_balance=@tongtiengui-@tongtienrut
		From account	join transactions on transactions.ac_no=account.Ac_no
						join customer on customer.Cust_id=account.cust_id
		where customer.Cust_id =@maKH
		Set @kq=N'Không hợp lệ, đã cập nhật lại '
	End
	Print @kq
End

declare @c20 nvarchar(50)
Exec c20 '000002',@c20 output

--21.	Kiểm tra chi nhánh có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không nếu biết mã chi nhánh? Nếu có, trả về lần giao dịch.
/*
	input:mã chi nhánh
	Output:trả về lần giao dịch
	Process:
			B1: 
			B2:
*/
Create proc c21 (@macn varchar(10),@kq nvarchar(50) output)
As 
Begin
	declare @soGD int
	Select @soGD=COUNT(t_id)
	From transactions	join account on transactions.ac_no=account.Ac_no
						join customer on account.cust_id=customer.Cust_id
	where DATEPART(dw, t_date)=1 and Br_id=@macn
	set @kq=concat(N'Số giao dịch của chi nhánh là: ',@soGD)
	print @kq
End

Declare @c21 nvarchar(50)
Exec c21 'VT009',@c21

--22.	In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn
/*
	input: n bất kì 
	Output: In ra dãy số lẻ từ 1 – n
	Process:	B1: khởi tạo vòng lặp chạy từ 1 đến n với bước nhảy là 2 
				B2: in ra kết quả sau mỗi lần lặp
*/
create proc c22 (@n int, @i int output)
As 
Begin
	set @i=1
	set @n=10
	while @i <=@n
	begin 
		print @i
		Set @i=@i+2
	End
End

Declare @c22 int
Exec c22 10,@c22 output

--23.	In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn
/*
	input: n bất kì 
	Output: In ra dãy số chẵn từ 0 – n
	Process:	b1: set giá trị i=2
				B2: khởi tạo vòng lặp chạy từ 2 đến n với bước nhảy là 2 in ra i
*/
create proc c23 (@n int, @i int output)
As 
Begin
	set @i=2
	set @n=10
	while @i <=@n
	begin 
		print @i
		Set @i=@i+2
	End
End

Declare @c23 int
Exec c23 10,@c23 output

--24.	In ra 100 số đầu tiền trong dãy số Fibonaci
/*
	input: không có 
	Output: ra 100 số đầu tiền trong dãy số Fibonaci
	Process:	b1: set giá trị biến: so=0, i=0, j=1
				B2: khởi tạo vòng lặp in ra 100 số (so<=100)
				B3: gán i=i+j
				B4:	gán j=i
				B5	In ra i
				B6: bước nhảy số=số+1
*/
create proc c24 (@i numeric(35,0)output)
As 
Begin
	Declare @so int,@j numeric(35,0)
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
End

Declare @c24 numeric(35,0)
Exec c24 @c24 output

--25a)	tam giác vuông
/*
	input: không có 
	output: tam giác vuông
	Process: tạo biến chứa kí tự '*'
*/
create proc c25 (@tm varchar(30) output)
As 
Begin
	declare @kt varchar(10), @count1 int 
	Set @kt='*'
	Set @tm='*'
	Set @count1=1
	while @count1 <=5
	Begin 
		print @tm
		Set @tm=@tm+@kt
		set @count1 = @count1+1
	End
End

Declare @c25 varchar(30)
Exec c25 @c25 output

--b)	tam giác cân

--       *
--      ***
--     *****
--    *******
--   *********

/*
	input: không có
	output: như hình trên 
	Process: 
			b1: tạo biến : số vòng lặp n=5, i=1, in khoảng trắng, in ngôi sao
			B2: khởi tạo vòng lặp i<=n
			B3: gán biến in khoảng trắng (kt) =kt *(n-i)
			B4:	gán biến in ngôi sao (ns) =i *2 -i
			B5:	In ra kt+ns
			B6:	bước nhảy i=i+1
*/
--REPLICATE (chuỗi cần lặp, số kí tự)
create proc c25c 
as
begin
    DECLARE @n int = 5, @i int = 1, @kt varchar(30), @ns varchar(30);
    while @i <= @n
    BEGIN
        set @kt = REPLICATE(' ', @n - @i);
        set @ns = REPLICATE('*', @i * 2 - 1);
		print @kt+@ns
        set @i = @i + 1;
    end
end
Exec c25c

--e)	Kiểm tra số điện thoại của khách là số tiến hay số lùi nếu biết mã khách. 
/*
	input: mã khách hàng
	output: kết luận số tiến hay số lùi hay lộn xộn 
	Process
*/

--sửa code c12
create or alter proc sptinhTong ( @thoigian varchar(10), @slgd int output, @totalGui numeric (15,0) output, @totalRut numeric (15,0) output)
as
begin
	declare @thang int declare @nam int 
	if @thoigian like '%[/,-]%' 
	begin--06/2015 06-2015
		set @nam = right (@thoigian, 4)
		set @thang = left(@thoigian, CHARINDEX('/',@thoigian) - 1)
	end
	if @thang is null 
	begin
		select @slgd=count(t_id) 
		from transactions
		where year (t_date) = @nam

		select @totalRut=sum(t_amount) 
		from transactions
		where year (t_date) = @nam and t_type = 0
		
		select @totalGui=sum(t_amount) 
		from transactions
		where year (t_date) = @nam and t_type = 1
	end 
	else 
	begin
		select @slgd=count(t_id) 
		from transactions
		where month (t_date) = @thang and year (t_date) = @nam

		select @totalRut=sum(t_amount) 
		from transactions
		where month (t_date) = @thang and year (t_date) = @nam and t_type = 0
		
		select @totalGui=sum(t_amount) 
		from transactions
		where month(t_date) = @thang and year (t_date) = @nam and t_type = 1
	end
	print @slgd
	Print @totalGui
	Print @totalRut 
end



--sửa code
CREATE OR ALTER PROC sptinhTong 
(
    @thoigian VARCHAR(10), 
    @slgd INT OUTPUT, 
    @totalGui NUMERIC(15,0) OUTPUT, 
    @totalRut NUMERIC(15,0) OUTPUT
)
AS
BEGIN
    DECLARE @thang INT, @nam INT
	if @thoigian like '%/%'
	Begin 
		set @nam = right (@thoigian, 4)
		set @thang = left(@thoigian, CHARINDEX('/',@thoigian) - 1)
	End
	Else if @thoigian like '%-%'
	Begin 
		set @nam = right (@thoigian, 4)
		set @thang = left(@thoigian, CHARINDEX('-',@thoigian) - 1)
	End
	else 
	Begin 
		set @nam=@thoigian
		set @thang = null
	End
	if @thang is null
	Begin 
		select @slgd=count(t_id) 
		from transactions
		where year (t_date) = @nam

		select @totalRut=sum(t_amount) 
		from transactions
		where year (t_date) = @nam and t_type = 0
		set @totalRut= iif(@totalRut is null,0,@totalRut)

		select @totalGui=sum(t_amount) 
		from transactions
		where year (t_date) = @nam and t_type = 1
		set @totalGui= iif(@totalGui is null,0,@totalGui)
	End
	Else 
	Begin
		select @slgd=count(t_id) 
		from transactions
		where month (t_date) = @thang and year (t_date) = @nam

		select @totalRut=sum(t_amount) 
		from transactions
		where month (t_date) = @thang and year (t_date) = @nam and t_type = 0
		set @totalRut= iif(@totalRut is null,0,@totalRut)
		
		select @totalGui=sum(t_amount) 
		from transactions
		where month(t_date) = @thang and year (t_date) = @nam and t_type = 1
		set @totalGui= iif(@totalGui is null,0,@totalGui)
	End
end
declare @sl int , @tonggui numeric (15,0) , @tongrut numeric (15,0) 
exec sptinhTong '01-2016', @sl out, @tonggui out, @tongrut out
print @sl
Print @tonggui
Print @tongrut

