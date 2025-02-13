use bank
--1.Kiểm tra thông tin khách hàng đã tồn tại trong hệ thống hay chưa nếu biết họ tên và số điện thoại. Tồn tại trả về 1, không tồn tại trả về 0
/*
	input:họ tên và số điện thoại
	output: trả về 0 hoặc 1 
	process: kiểm tra cust_id(đếm ) có tồn tại không. Điều kiện: Cust_name = @hoten and Cust_phone=@sdt
			 nếu đếm =1 -->output: 1
			 Ngược lại -->output: 2
*/
Drop function kh_kiemtrathongtin
Create function kh_kiemtrathongtin (@hoten nvarchar(50), @sdt varchar(11))
Returns int
As 
begin
	declare	@dem int, @kq int
	Select @dem = COUNT(cust_id)
	From customer
	where Cust_name = @hoten and Cust_phone=@sdt
	Set @kq =	case when @dem = 0 then 0
					 else 1
				end
	Return @kq
End
Select dbo.kh_kiemtrathongtin(N'Hà Công Lực','0783388103')

--2.	Tính mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. 
--Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch
/*
	input:không có
	output:mã giao dịch mới
	Process: b1: tìm mã gd lớn nhất
			b2: giá trị gd mới = giá trị mã gd lớn nhất +1 -->output
			B3: format so--> đủ 10 kí tự 
*/
drop function gd_tinhmagdmoi
Create function gd_tinhmagdmoi ()
Returns char(10)
As 
Begin 
	declare @mgd_moi char(10),@mdg_gd char (10)
	Select @mdg_gd=Max(t_id)
	From transactions
	Set @mgd_moi=@mdg_gd+1
	--set @magd =right('000000000000',@magd,10)
	Set @mgd_moi= REPLICATE('0',10-len(@mgd_moi))+cast(@mdg_gd+1 as varchar(10))
	Return @mgd_moi
End
Select dbo.gd_tinhmagdmoi()

--3.	Tính mã tài khoản mới. (định nghĩa tương tự như câu trên) 
Create or alter function tk_tinhmatkmoi ()
Returns char(10)
As 
Begin 
	declare @mtk_moi char(10),@mtk_gd char (10)
	Select @mtk_gd=Max(Ac_no)
	From account
	Set @mtk_moi=@mtk_gd+1
	Set @mtk_moi=cast(@mtk_gd+1 as varchar(10))
	Return @mtk_moi
End
Select dbo.tk_tinhmatkmoi()

--4.	Trả về tên chi nhánh ngân hàng nếu biết mã của nó.
/*
	input: mã ngân hàng
	Output: tên chi nhánh ngân hàng
	Process: tìm tên chi nhánh NH. Điều kiện: BR_id=@maCN -->output
*/
create or alter function br_tenCN (@maCN char(5))
Returns nvarchar(100)
as 
Begin
	declare @tenCN nvarchar(100)
	Select @tenCN=BR_name
	From Branch
	where BR_id=@maCN 
	Return @tenCN
End 
select dbo.br_tenCN ('VB001')

--5.	Trả về tên của khách hàng nếu biết mã khách.
/*
	input:mã khách
	Output:tên của khách hàng
	Process:tìm tên khách hàng. Điều kiện cust_id=@maKH
*/
create function kh_tenKH (@maKH char(6))
Returns nvarchar(50)
As 
begin
	declare @tenKH nvarchar(50)
	Select @tenKH=Cust_name
	From customer
	where Cust_id=@maKH
	Return @tenKH
End
Select dbo.kh_tenKH('000001')

--6.	Trả về số tiền có trong tài khoản nếu biết mã tài khoản.
/*
	input:mã tài khoản
	output:số tiền có trong tài khoản
	Process: 
*/
create or alter function ac_sotienTK (@maTK char (10))
Returns numeric(15,0)
As 
Begin
	declare @sotien numeric(15,0)
	Select @sotien =ac_balance
	From account
	where Ac_no=@maTK
	Return @sotien
End
Select dbo.ac_sotienTK ('1000000001')

--7.	Trả về số lượng khách hàng nếu biết mã chi nhánh.
/* 
	input: mã chi nhánh
	Output:số lượng khách hàng
	Process: đếm số lượng khách hàng, điều kiện: br_id=@maCN
*/

Create or alter function cn_slKH (@maCN char(5))
Returns int 
As 
Begin 
	declare @dem int 
	Select @dem=count(cust_id)
	From customer
	where Br_id=@maCN
	Return @dem
End
Select dbo.cn_slKH ('VT009')

--8.	Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch.
--Giao dịch bất thường: giao dịch gửi diễn ra ngoài giờ hành chính, 
--giao dịch rút diễn ra vào thời điểm 0am  3am
/*
	input:mã giao dịch
	output: trả về bất thường hoặc bình thường
	Process:b1: xác định giờ giao dịch. điều kiện: t_id=@magd
			b2: kiểm tra giời giao dịch 
				+Nếu giao dịch diễn ra ngoài giờ hành chính ngoài khoảng 7h30->10h30 và 13h30 ->16h30--> output: bất thường
				+Ngược lại:-->output: bình thường
*/
Create or alter function gd_ktgd (@magd char(10))
Returns nvarchar(30) 
As 
Begin 
	declare @trangthai nvarchar(30),@giogd datetime
	Select @giogd=t_time
	From transactions
	where t_id=@magd
	Set @trangthai=case	when	(@giogd not between '07:30:00' and '10:30:00') and 
								(@giogd not between '13:30:00' and '16:30:00') then N'Bất thường'
						else N'Bình thường'
					end
	return @trangthai
End
Select dbo.gd_ktgd ('0000000201')



------------------------------------------------THỦ TỤC, HÀM------------------------------------------
--1.	Trả về tên chi nhánh ngân hàng nếu biết mã của nó.
/*
	input: mã ngân hàng
	Output: tên chi nhánh ngân hàng
	Process: tìm tên chi nhánh NH. Điều kiện: BR_id=@maCN -->output
*/
Create or alter proc cn_tenCN (@maCN char(5),@tenCN nvarchar(100) output)
As 
Begin 
	Select @tenCN=BR_name
	From Branch
	where BR_id=@maCN 
	print @tenCN
end
Declare @c1 nvarchar(100)
exec cn_tenCN 'VB002',@c1

--2.	Trả về tên, địa chỉ và số điện thoại của khách hàng nếu biết mã khách.
/*
	input:  mã khách
	Output: tên, địa chỉ và số điện thoại của khách hàng
	Process: tìm tên, địa chỉ và số điện thoại của khách hàng. Điều kiện: BR_id=@maCN -->output
*/
Create or alter function kh_thongtinkh (@maKh char(6))
Returns table
as 
Return	select Cust_name,Cust_ad, Cust_phone
		from customer
		where Cust_id=@maKh
select * from dbo.kh_thongtinkh ('000001')

--3.	In ra danh sách khách hàng của một chi nhánh cụ thể nếu biết mã chi nhánh đó.
/*
	input: mã chi nhánh
	Output: danh sách khách hàng của chi nhánh
	Process: tìm khách hàng của chi nhánh. Điều kiện: BR_id=@maCN -->output
*/
Create or alter function cn_dskh (@macn char(5))
Returns table
as 
Return	select Cust_name,Cust_ad, Cust_phone
		from customer
		where Br_id=@macn
select * from dbo.cn_dskh ('VB002')

--4.	Kiểm tra một khách hàng nào đó đã tồn tại trong hệ thống CSDL của ngân hàng chưa nếu biết: 
--họ tên, số điện thoại của họ. Đã tồn tại trả về 1, ngược lại trả về 0
/*
	input: họ tên, số điện thoại
	Output: trả về 1 hoặc 0
	Process:	b1:	tìm cust_id có tồn tại trong bảng customer không. 
					Điều kiện: cust_name=@ten và cust_phone=@sdt
				b2: nếu len(cust_id)=0 hoặc cust_id is null -->output:0
					ngược lại :-->output:1
*/
create or alter function kh_tontai (@ten nvarchar(50), @sdt varchar(11))
returns int
As 
Begin 
	declare @cust_id char(6),@kq int
	Select @cust_id=Cust_id
	From customer
	where Cust_name=@ten And Cust_phone=@sdt
	Set @kq =	case	when (len(@cust_id)=0 or @cust_id is null) then 0
						else 1
				end
	return @kq
End
select dbo.kh_tontai (N'Nguyễn Lê Minh Quân','0962883220')

--5.	Cập nhật số tiền trong tài khoản nếu biết mã số tài khoản và số tiền mới. 
--Thành công trả về 1, thất bại trả về 0
/*
	input: mã số tài khoản và số tiền mới
	output: cập nhật số tiền trong tài khoản. Thành công trả về 1, thất bại trả về 0
	Process:	b1: tìm số tiền hiện tại trong tài khoản. Điều kiện ac_no=@stk
				b2: update ac_blance = số tiền mới. Điều kiện:Ac_no=@stk
				B3: nếu ac_blance ban đầu khác với số tiền mới  -->output:1
					nếu ac_blance ban đầu bằng với số tiền mới  -->output:0		
*/
Create or alter proc ac_capnhattien (@stk char (10), @sotienmoi numeric(15,0))
As
Begin
	declare @sotienbd numeric(15,0),@kq int
	--
	Select @sotienbd = ac_balance 
	From account
	where Ac_no=@stk
	--
	Update account
	Set ac_balance=@sotienmoi
	where Ac_no=@stk
	--
	Set @kq =	case	when @sotienbd <>@sotienmoi then 1
						else 0
				end
	return @kq
End

--6.	Cập nhật địa chỉ của khách hàng nếu biết mã số của họ. Thành công trả về 1, thất bại trả về 0
/*
	input: mã số khách hàng
	output: cập nhật địa chỉ của khách hàng. Thành công trả về 1, thất bại trả về 0
	Process:	b1: tìm địa chỉ hiện tại của khách hàng trong tài khoản. Điều kiện cust_id=@makh
				b2: update cust_ad = địa chỉ mới. Điều kiện:cust_id=@makh
				B3: nếu cust_ad ban đầu khác với địa chỉ mới  -->output:1
					nếu cust_ad đầu bằng với địa chỉ mới  -->output:0		
*/
Create or alter proc kh_capnhatdc (@makh char (6), @diachimoi nvarchar(100))

As
Begin
	declare @dcbd nvarchar(100),@kq int
	--
	Select @dcbd = Cust_ad 
	From customer
	where Cust_id=@makh
	--
	Update customer
	Set Cust_ad=@diachimoi
	where Cust_id=@makh
	--
	Set @kq =	case	when @dcbd <>@diachimoi then 1
						else 0
				end
	return @kq
End

--7.	Trả về số tiền có trong tài khoản nếu biết mã tài khoản.
/*
	input:mã tài khoản
	output:số tiền có trong tài khoản
	process: tìm số tiền có trong tài khoản. Điều kiện: Ac_no= @matk
*/
create or alter function ac_sotien (@matk char(10))
Returns numeric (15,0)
As
Begin
	declare @tientk numeric (15,0)
	Select @tientk=ac_balance
	From account
	where Ac_no=@matk
	Return @tientk
End
select dbo.ac_sotien ('1000000004')

--8.	Trả về số lượng khách hàng, tổng tiền trong các tài khoản nếu biết mã chi nhánh.
/*
	input:mã chi nhánh
	Output: số lượng khách hàng, tổng tiền trong các tài khoản của chi nhánh
	Process:	tìm số lượng khách hàng, tổng tiền trong các tài khoản. 
				Điều kiện br_id=@maCN 
*/
create or alter function cn_slkh_tongtien(@maCN char(5))
Returns @acc table (slkh int,
					Tongtien numeric(15,0)
					)
As
Begin
	insert into @acc
	select COUNT(customer.Cust_id), sum (ac_balance)
	From account	join customer on account.cust_id=customer.Cust_id
					join Branch on Branch.BR_id=customer.Br_id
	where customer.Br_id=@maCN
	Group by Ac_no 
	Return
End
select * from dbo.cn_slkh_tongtien('VN012')
Select * from Branch

/*9.	Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. 
Giao dịch bất thường: giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra 
vào thời điểm 0am  3am
câu 8 hàm */

/*10.	Trả về mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. 
Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch

input:không có
	output:mã giao dịch mới
	Process: b1: tìm mã gd lớn nhất
			 b2: giá trị gd mới = giá trị mã gd lớn nhất +1 -->output
*/
--THỦ TỤC
Create or alter proc gd_tinhmagdmoic2 (@mgd_moi char(10) output)
As 
Begin 
	declare @mdg_gd char (10)
	Select @mdg_gd=Max(t_id)
	From transactions
	Set @mgd_moi=@mdg_gd+1
	Set @mgd_moi= REPLICATE('0',10-len(@mgd_moi))+cast(@mdg_gd+1 as varchar(10))
	
End
Declare @c10c1 char(10)
Exec gd_tinhmagdmoic2 @c10c1 output
print @c10c1


/*11.	Thêm một bản ghi vào bảng TRANSACTIONS nếu biết các thông tin ngày giao dịch, thời gian giao dịch, 
số tài khoản, loại giao dịch, số tiền giao dịch. Công việc cần làm bao gồm:
a.	Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý
b.	Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
c.	Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
d.	Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý
e.	Tính mã giao dịch mới
f.	Thêm mới bản ghi vào bảng TRANSACTIONS
g.	Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch

Input: ngày giao dịch, thời gian giao dịch, số tài khoản, loại giao dịch, số tiền giao dịch
output:Cập nhật bảng ACCOUNT
Process:	b1: Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý
			b2:Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
			b3:Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
			b4: Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý
			b5:Tính mã giao dịch mới
			b6:Thêm mới bản ghi vào bảng TRANSACTIONS
			b7:Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch
*/
--

create or alter proc cau11	@t_date date,
							@t_time time,
							@ac_no char(10),
							@t_type bit,
							@t_amount decimal(15,0),
							@ret bit output
as
begin
	declare @MaGDMoi char(10)
	-- a. Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý
	if @t_date > cast (getdate() as date) or
	(@t_date = cast (getdate() as date) and @t_time > cast (getdate() as time))
	begin
		print N'Thoi gian khong hop le!'
		set @ret = 0
		return
	end
	-- b. Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
	if @ac_no not in (select ac_no from account)
		begin
			print N'So tai khoan khong ton tai!'
			set @ret = 0
			return
		end
	-- c. Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
	if @t_type not in (1,0)
		begin
			print N'Loai giao dich khong phu hop!'
			set @ret = 0
			return
		end
	-- d. Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý
	if @t_amount <=0
		begin
			print 'So tien khong hop le!'
			set @ret = 0
			return
		end
	-- e. Tính mã giao dịch mới
	set @MaGDMoi = dbo.gd_tinhmagdmoi()
	-- f. Thêm mới bản ghi vào bảng TRANSACTIONS
	insert into transactions (t_id, t_date, t_time, ac_no, t_type, t_amount)
	values (@MaGDMoi,@t_date, @t_time, @ac_no, @t_type, @t_amount)
	if @@rowcount <= 0
		begin
			print 'insert that bai'
			set @ret = 0
			return
		end

	-- g. Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch
	update account
	set ac_balance =	case @t_type	when 1 then ac_balance + @t_amount
									else ac_balance - @t_amount
						end
	where ac_no = @ac_no
	if @@rowcount >=1
		begin
			print 'cap nhat thanh cong'
			set @ret = 1
		end
	else
		begin
			print 'cap nhat khong thanh cong'
			set @ret = 0
		end
end
--test
declare @t_date date,
		@t_time time,
		@ac_no char(10),
		@t_type bit,
		@t_amount decimal(15,0),
		@ret bit
set @t_date = '2024-10-08'
set @t_time = '15:57:00'
set @ac_no = '1000000001' --90806000 --90806001
set @t_type = 1
set @t_amount = 1
exec cau11 @t_date,
			@t_time,
			@ac_no ,
			@t_type,
			@t_amount,
			@ret out
print @ret

/*
12.	Thêm mới một tài khoản nếu biết: mã khách hàng, loại tài khoản, số tiền trong tài khoản. Bao gồm những công việc sau:
a.	Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
b.	Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
c.	Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý.
d.	Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
e.	Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có.

Input:mã khách hàng, loại tài khoản, số tiền trong tài khoản
Output: thêm bản ghi mới in ra 1 (thành công), 0 (thất bại)
*/

Create or alter proc c12 (@makh char(6), @ac_type char(1), @stk char (10), @c12 bit out)
As
Begin
	/*a.	Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
	process: 
	*/
	If @makh not in (select cust_id from customer)
		begin 
			print N'Mã khách hàng không tồn tại'
			Set 
		End
	-- b. Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
	if @ac_no not in (select ac_no from account)
		begin
			print N'So tai khoan khong ton tai!'
			set @ret = 0
			return
		end
End

----------------------------------------------------------------------------------------------------------------------
/*2.	Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 thì đưa ra thông báo ‘tài khoản đã bị xóa’ 
và hủy thao tác đã thực hiện. Ngược lại:  
i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao dịch < 50.000 thì đưa ra thông báo ‘không đủ tiền’ 
và hủy thao tác đã thực hiện.

- bảng: transactions
- loại: after
- sự kiện: insert
- process:	B1. Lấy ra ac_no, t_type, t_amount từ bảng inserted---->@ac_no, @t_type, @t_amount
			B2. Lấy ra ac_balance, ac_type từ bảng account với điều kiện ac_no=@ac_no---->@ac_balance, @ac_type
			B3.1 Nếu ac_type = 9, print‘tài khoản đã bị xóa’ +rollback
			B3.2 Ngược lại
				a) Nếu @t_type=1, update account, ac_balance=ac_balance+@t_amount
									đk: ac_no=@ac_no
				b) Nếu @t_type=0
					b).1: ac_balance-@t_amount<50000, print ‘không đủ tiền’ +rollback
					b).2: Ngược lại, update account, ac_balance=ac_balance-@t_amount
									đk: ac_no=@ac_no
*/

create trigger tc2 
on transactions
for insert 
as
begin
	declare @ac_type bit, @t_type bit, @ac_no varchar(20), @tien numeric,@ac_balace  numeric
	select @t_type=t_type, @ac_no=ac_no, @tien=t_amount from inserted
	select  @ac_type=ac_type ,@ac_balace=ac_balance from account where ac_no=@ac_no 
	if @ac_type='9'
	begin
		print N'Tài khoản đã bị xoá'
		rollback
		return
	end
	else
		if @t_type=1
			begin
				update account
				set ac_balance=ac_balance+@tien
				where ac_no=@ac_no
			end
		else if @t_type=0
			begin
				set @ac_balace=@ac_balace-@tien
				if @ac_balace<50000
					begin
						print N'Không đủ tiền'
						rollback
						return
					end
				else 
				update account
				set ac_balance=ac_balance-@tien
				where ac_no=@ac_no
			end
end

------------------------------------------------------------------------------------------------------------------------------------
/*12.	Thêm mới một tài khoản nếu biết: mã khách hàng, loại tài khoản, số tiền trong tài khoản. Bao gồm những công việc sau:
a.	Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
b.	Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
c.	Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý.
d.	Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
e.	Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có.
	input: mã khách hàng, loại tài khoản, số tiền trong tài khoản
	Output: thâ
	Process:
*/

create or alter proc sp_themthongtin (@makh varchar(20) ,@loaitk bit, @sotien numeric,@ref bit output )
as
begin 
if not exists (select 1 from customer where Cust_id=@makh)
begin 
	set @ref=0
	print N'Mã không tồn tại'
	return
end
if @loaitk not in (1,0)
begin 
	set @ref=0
	print N'loại tk sai'
	return
end
if @sotien<0
begin 
	set @ref=0
	print N'sotien không họp lệ'
	return
end
if @sotien is null
begin 
	set @sotien=50000
end
declare @matkmoi varchar(20)
set @matkmoi=(select max(Ac_no)+1 from account )
insert into account(Ac_no,ac_balance,ac_type,cust_id)
values(@matkmoi,@sotien,@loaitk,@makh)
if @@ROWCOUNT<=0
begin 
	set @ref=0
end
else
begin 
	set @ref=1
end
end
declare @makhach varchar (10), 
		@loai char(1),
		@sotien1 numeric(15,2),
		@ret bit 
set @makhach='000000'
Set @loai=1
Set @sotien1=null

exec sp_themthongtin @makhach,@loai,@sotien1,@ret output
Select * from customer
Select * from account
----------------------------------------------------------------------------------------------
create or alter proc themtk(@makhach varchar (10), @loai char(1),@sotien numeric(15,2),@ret bit out)
As
Begin
	if @makhach not in (select Cust_id from customer)
		begin 
			print N'ma chua ton tai'
			set @ret=0
			return
		end
	if @loai not in (0,1)
		begin 
			print N'sai loai'
			set @ret=0
			return
		end
	if @sotien<0 
		begin 
			print N'tien khong hop le'
			set @ret=0
			return
		end
	if @sotien=null
		begin 
			set @sotien =50000
		end
	declare @matk varchar(10)
	set @matk=(select max(Ac_no)+1 from account )
	insert into account ([Ac_no],[ac_balance],[ac_type],[cust_id])
	values (@matk,@sotien,@loai,@makhach)
	If @@ROWCOUNT=0 
		begin 
			set @ret=0
		End
	else 
		begin
			set @ret=1
		End
End
declare @makhach varchar (10), 
		@loai char(1),
		@sotien numeric(15,2),
		@ret bit 
set @makhach='000001'
Set @loai=01
Set @sotien=null
exec themtk @makhach,@loai,@sotien,@ret out
Print @ret
