use bank
--1.	Viết đoạn code thực hiện việc chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin và truyền thông cho 
--một khách hàng bất kì, ví dụ với: Dương Ngọc Long
/*
		input: tên khách hàng: Dương Ngọc Long
		output: số điện thoại của khách hàng đã được chuyển từ 11 số ->10 số. Số điện thoại đã được update
		Process:
			B1: Tìm khách hàng tên: Dương Ngọc Long
			B2a: Nếu số điện thoại của khách hàng là 11 số thì chuyển đổi theo quy định sau:
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
			B2b: Nếu số điện thoại của khách hàng là 10 số thì giữ nguyên
*/
--code:
Declare @moi char(10), @doi varchar(15), @sdt varchar (15)

select @sdt=Cust_phone
From customer
where Cust_name=N'Dương Ngọc Long'
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
where Cust_name=N'Dương Ngọc Long' 

Select Cust_phone
From customer
where Cust_name=N'Dương Ngọc Long' 


--2.	Trong vòng 10 năm trở lại đây Nguyễn Lê Minh Quân có thực hiện giao dịch nào không? Nếu có, hãy trừ 50.000 phí duy trì tài khoản. 
/* 
	input: Khách hàng tên Nguyễn Lê Minh Quân
	output: In ra kết quả Kh có thực hiện giao dịch nào trong vòng 10 năm không. 
				+Nếu có update trừ 50000 phí duy trì tài khoản. 
					In ra màn hình khách hàng thực hiện giao dịch trong vòng 10 năm, đã trừ phí duy trì tài khoản 
				+Nếu không in ra kết quả khách hàng không thực hiện giao dịch nào trong vòng 10 năm 
	Process: 
			B1: Tìm số tài khoản của KH Nguyễn Lê Minh Quân
			B2: Đếm số giao dịch của tài khoản trên trong vòng 10 năm 
			B2a: Nếu số giao dịch >0. update: trừ 50000 phí duy trì tài khoản. 
			B2b: Nếu SGD=0 không update
*/
--code 
Declare @stk char(10), @dem int, @kq Nvarchar(100)

Select @stk = Ac_no
From account join customer on account.cust_id=customer.Cust_id
where	Cust_name Like N'Nguyễn Lê Minh Quân' 

Select @dem=(count(t_id))
From transactions join account on transactions.ac_no=account.Ac_no
where	account.Ac_no = @stk and 
		t_date>=DATEADD(year,-10,getdate())

if @dem>0 
	Begin 
		update account
		set ac_balance=ac_balance-50000
		where Ac_no=@stk
		Set @kq=N'Khách hàng đã thực hiện giao dịch trong vòng 10 năm. Đã trừ 50000 phí duy trì tài khoản'
	end
Else
	Begin
		set @kq=N'KH không thực hiện giao dịch trong vòng 10 năm'
	End
print @kq

select ac_balance from transactions  join account on transactions.ac_no=account.Ac_no
							join customer on account.cust_id=customer.Cust_id
where Cust_name Like N'Nguyễn Lê Minh Quân' 

--3.	Trần Quang Khải thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) và 
--vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông)?
/*
	input: Khách hàng Trần Quang Khải
	Output: In ra giao dịch gần đây nhất thực hiện vào thứ mấy và vào mùa nào
	process: 
			B1: Tìm giao dịch gần nhất được thực hiện của Trần Quang Khải
			B2: xác định giao dịch vào thứ mấy
			B3: Xác định giao dịch được thực hiện vào mùa nào
*/
declare @gdgn date, @thu Nvarchar(20), @mua nvarchar(20)
Select @gdgn =max(t_date)
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Trần Quang Khải'

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
print concat(N'Trần Quang Khải thực hiện giao dịch gần nhất vào: ',@thu,', ',@mua)


--4.	Đưa ra nhận xét về nhà mạng mà Lê Anh Huy đang sử dụng? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)
/*
	input: KH Lê Anh Huy
	Output: In ra nhà mạng mà khách hàng đang sử dụng
	Process: 
			B1: Tìm số điện thoại của Lê Anh Huy
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
declare @phone varchar(11), @nhamang Nvarchar(30)
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
		if	left(@phone,3) in ('032', '033', '034', '035', '036', '037', '038', '039')
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

--5.	Số điện thoại của Trần Quang Khải là số tiến, số lùi hay số lộn xộn. 
--Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến

/*
	input: KH Trần Quang Khải
	Output: In ra kết quả là số tiến hay số lùi hay số lộn xộn
	Process: 
			B1: tìm số điện thoại của Trần Quang Khải
			B2: lấy dãy số trừ 3 số đầu tiên của điện thoại 
			B3: khởi tạo vòng lặp xét dãy số 
			B3a: Nếu số sau liền kề lớn hơn hoặc bằng số trước  --> dãy số tiến 
			B3b: Nếu số sau nhỏ hơn hoặc bằng số trước liền kề  --> dãy số lùi
			B3c: Nếu không dãy số thuộc số lộn xộn
*/
declare @sdt5 varchar(11),@dayso varchar(8), @tang int, @giam int, @lx int, @count int ,@kl Nvarchar(30)
Select @sdt5=Cust_phone
From customer
where Cust_name like N'Trần Quang Khải'

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

--6.	Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?
/*
	input: KH Hà Công Lực
	Output: in ra Kq Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào
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
declare @buoi Nvarchar(30), @giogd datetime, @t_date date
Select top 1 @t_date=t_date,@giogd =t_time
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Hà Công Lực'
order by t_date DESC, t_time DESC
SET @buoi = CASE 
            WHEN DATEPART(HOUR, @giogd) between 6 and 10  THEN N'Sáng'
            WHEN DATEPART(HOUR, @giogd) between 11 and 13 THEN N'Trưa'
            WHEN DATEPART(HOUR, @giogd) between 14 and 17 THEN N'Chiều'
			WHEN DATEPART(HOUR, @giogd) between 18 and 21 THEN N'Tối'
            ELSE N'Đêm'
            END
print @buoi

--7.	Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào? 
--Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.
/*
	input:  Trương Duy Tường
	Output: in ra chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào
	Process: 
			B1:Tìm mã chi nhánh của Trương Duy Tường đang sử dụng
			B2: nếu mã chi nhánh là VN : miền nam, VT : miền trung, VB : miền bắc, còn lại: bị sai mã.
*/
Declare @maCN nvarchar(10), @mien Nvarchar(20)
Select @maCN=customer.Br_id
From customer
where Cust_name like N'Trương Duy Tường'

Set @mien = case	when @maCN like 'VN%' then N'Miền nam'
					when @maCN like 'VT%' then N'Miền Trung'
					when @maCN like 'VB%' then N'Miền Bắc'
					Else N'Mã sai'
			end
print @mien

--8.	Căn cứ vào số điện thoại của Trần Phước Đạt, hãy nhận định anh này dùng dịch vụ di động của hãng nào:
--Viettel, Mobi phone, Vina phone, hãng khác.
--tương tự c4
declare @phone varchar(11), @hang Nvarchar(30)
Select @phone=Cust_phone
From customer
where Cust_name Like N'Trần Phước Đạt'
If len(@phone)=11 
	begin 
		if	left(@phone,4) in ('0162', '0163', '0164', '0165',' 0166',' 0167', '0168', '0169')
			set @hang =N'Hãng viettel'
		else if left(@phone,4) in ('0120','0121','0122','0126',	'0128')
			set @hang=N'Hãng mobiphone'
		else if left(@phone,4) in ('0127', '0129', '0123', '0124', '0125')
			set @hang=N'Hãng vinaphone'
		else if left(@phone,4) in ('0186','0188')
			set @hang=N'Hãng Vietnamobile'
		else set @hang=N'Hãng khác'
	End
else if len(@phone)=10
	begin
		if	left(@phone,3) in ('032', '033', '034', '035', '036', '037', '038', '039')
			set @hang =N'Hãng viettel'
		else if left(@phone,3) in ('070', '079', '077', '076', '078')
			set @hang=N'Hãng mobiphone'
		else if left(@phone,3) in ('083', '084', '085', '081', '082')
			set @hang=N'Hãng vinaphone'
		else if left(@phone,3) in ('056', '058')
			set @hang=N'Hãng Vietnamobile'
		else set @hang=N'Hãng khác'
	End
print @hang

--9.	Hãy nhận định Lê Anh Huy ở vùng nông thôn hay thành thị. Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc 
--“xóm” hoặc “đội” hoặc “xã” hoặc “huyện”

/*
	input: Lê Anh Huy
	ouput: in ra kq Lê Anh Huy ở vùng nông thôn hay thành thị
	Process: 
			B1: Tìm ra địa chỉ của LAH
			B2: +Ở vùng nông thôn nếu địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc (“xã” không phải "thị xã") hoặc “huyện” 
*/
declare @dc Nvarchar(100), @nd Nvarchar(50)

Select @dc=Cust_ad
From customer
where Cust_name Like N'Lê Anh Huy'

Set @nd =	case	when @dc like N'% thôn %' then N'nông thôn'
					when @dc like N'% xóm %' then N'nông thôn'
					when @dc like N'% đội %' then N'nông thôn'
					when @dc like N'% huyên %' then N'nông thôn'
					when (@dc like N'% xã %' and @dc not like N'% thị xã %') then N'nông thôn'
					Else N'thành thị'
			end
print @nd

--10.	Hãy kiểm tra tài khoản của Trần Văn Thiện Thanh, nếu tiền trong tài khoản của anh ta nhỏ hơn không hoặc bằng không nhưng 
--6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’

/*
input : tài khoản của Trần Văn Thiện Thanh
output: Đóng tài khoản update ac_type = ‘K’ nếu tiền trong tài khoản của anh ta nhỏ hơn không hoặc bằng không và 
--6 tháng gần đây không có giao dịch
		Nếu không thì in ra tài khoản vẫn hoạt động
process : 
			b1: Tìm tài khoản của KH
			B2: kiểm tra số tiền trong tài khoản .
			B2a: nếu >0 --> kl: tài khoản hoạt động bình thường
			B2b: Nếu nhỏ hơn không thì đếm số giao dịch trong 6 tháng gần đây. 
			B3b: Nếu không có giao dihcj nào thì đóng tài khoản bằng cách cập nhật ac_type = ‘K’
		
*/

Declare @ttk int, @demgd int, @acc varchar(10)
Select @ttk= ac_balance, @acc=account.Ac_no
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where Cust_name like N'Trần Văn Thiện Thanh'

if @ttk <=0 
	begin
		select @demgd=count(t_id)
		From transactions
		where transactions.ac_no =@acc and 
		t_date>=DATEADD(MONTH,-6,getdate())
		if @demgd=0
			begin
				update account
				Set ac_type='K'
				where Ac_no=@acc
			End
		else
			begin
				print(N'TK đang hoạt động')
			End
	End
else 
	begin 
		print (N'Tk đang hoạt động')
	End

--11.	Mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ? 
/*
	input:  Huỳnh Tấn Dũng
	output: in ra mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ
	Process: 
			B1: tìm mã số giao dịch(t_id) gần đây nhất của Huỳnh Tấn Dũng 
			B2: Lấy mã số gd chia cho 2 
			B2a: Nếu chia hết -->số chẵn
			B2b: Nếu chia dư --> số lẻ 
*/
declare @mGD char(10),@kqs Nvarchar (20), @t date
select top 1   @mGD=(t_id), @t=(t_date)
From transactions	join account on transactions.ac_no=account.Ac_no
					join customer on account.cust_id=customer.Cust_id
where Cust_name Like N'Huỳnh Tấn Dũng'
Order by t_date desc
set @kqs= case	when CONVERT(int,@mGD) % 2 =0 then N'Số chẵn'
				else N'Số lẻ' end
print @kqs


--12.	Có bao nhiêu giao dịch diễn ra trong tháng 9/2016 với tổng tiền mỗi loại là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)
/*
	input : giao dịch diễn ra trong tháng 9/2016
	Output: Thống kê số giao dịch diễn ra trong tháng 9/2016
			Thống kê tổng tiền rút trong tháng 9/2016
			Thống kê tổng tiền gửi trong tháng 9/2016
	process: 
			B1: tìm tất cả các giao dịch trong tháng 9/2016
			B2: Đếm số giao dịch trong tháng 9 
			B3: tính tổng tiền rút, gửi
*/

Declare @soGD int,@tienRut numeric(15,0), @tienGui numeric(15,0)
Select	@soGD=count(t_id),
		@tienRut=sum(case when t_type='0' then t_amount else 0 end),
		@tienGui=sum(case when t_type='1' then t_amount else 0 end)
From transactions
where YEAR(t_date)=2016 and MONTH(t_date)=9
Print concat (N'Tong GD ' ,@soGD)
Print concat (N'Tong tien rut ',@tienRut)
Print concat (N'Tong tien gui ',@tienGui)

--13.	Ở Hà Nội ngân hàng Vietcombank có bao nhiêu chi nhánh và có bao nhiêu khách hàng? 
--Trả lời theo mẫu: “Ở Hà Nội, Vietcombank có … chi nhánh và có …khách hàng”
/*
	input: ngân hàng Vietcombank ở Hà Nội
	Output: in ra kêt quả “Ở Hà Nội, Vietcombank có … chi nhánh và có …khách hàng”
	Process: 
			B1: Đếm số chi nhánh và số Kh hiện có tại Nh VCB hà nội 
*/
Declare @soCN int, @soKH int
Select	@soKH =count(cust_id),
		@soCN=count(BR_ad)
From customer join Branch on customer.Br_id= Branch.BR_id
where BR_name like N'%Hà Nội'
print concat (N'Ở Hà Nội, Vietcombank có ',@soCN, N' chi nhánh và có ',@soKH,N' khách hàng')

--14.	Tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? 
--Tài khoản này thuộc chi nhánh nào?
/*
	input: account, customer, branch
	output: in ra tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? 
--Tài khoản này thuộc chi nhánh nào?
	process: 
			B1: thực hiện nối các bảng 
			B2: lấy top1 theo thứ tự được sắp xếp từ trên xuống dưới 
*/

Declare @tenKh Nvarchar(30),@soTien int, @tenCN Nvarchar(30)
select top 1 @tenKh=Cust_name, @soTien=ac_balance,@tenCN=Branch.BR_name
From account	join customer on account.cust_id=customer.Cust_id
				join Branch on Branch.BR_id=customer.Br_id
order by ac_balance desc
print @tenKh
Print @soTien
Print @tenCN

--15.	Có bao nhiêu khách hàng ở Đà Nẵng?
/*
	input: bảng customer
	output: in ra số khách hàng ở DN
	process: 
			B1: thực hiện nối các bảng 
			B2: lấy top1 theo thứ tự được sắp xếp từ trên xuống dưới 
*/

declare @demKh int 
Select @demKh=count(cust_id)
from customer
where Cust_ad like N'%Đà Nẵng'
print @demKh