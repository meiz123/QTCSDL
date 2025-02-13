--rollback: cho cho lưu dữ liệu vào bảng chính
/*1.	Khi xóa dữ liệu trong bảng account, hãy thực hiện thao tác cập nhật trạng thái tài khoản là 9 (không dùng nữa) 
thay vì xóa.
Input: lệnh delete được thực thi xoá dữ liệu trên bảng account
Output: cập nhật trạng thái tài khoản là 9 (không dùng nữa)
Process: cập nhật trạng thái của tài khoản =9. Điều kiện Ac_no thuộc ac_no trong bảng deleted
*/
Create or alter trigger acc_capnhattt_tk
On account
instead of delete
As
Begin 
	update account
	Set ac_type = '9'
	where Ac_no in (select Ac_no From deleted)
End

DELETE FROM account
WHERE Ac_no = '1000000054'


/*
2.	Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 thì đưa ra 
thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao dịch < 50.000 thì đưa ra 
thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện.

	Input: lệnh insert trên bảng transations được thực thi
	output: tài khoản đã bị xoá hoặc update số tiền giao dịch hoặc thông báo 'không đủ tiền'
	Process: b1: tìm trạng thái của tài khoản. Điều kiện ac_no = ac_no trong bảng inserted  
			b2: nếu ac_type =9 --> ‘tài khoản đã bị xóa’
				nếu t_type=1: cập nhật số dư tài khoản = số dư + tiền gửi
				Nếu t_type =0 : kiểm tra nếu số dư sau khi thực hiện giao dịch<50000
				--> 'không đủ tiền' và rollback còn không thì cập nhật số dư tài khoản= số dư -tiền rút. 
*/
go
Create or alter trigger tran_themdulieu
On transactions
after insert
As
Begin
	--b1
	Declare @ac_type char(1), @ac_balance numeric(15,4)
	Select @ac_type=ac_type,@ac_balance=ac_balance
	from account
	where Ac_no in (select Ac_no From inserted)

	--b2
	If @ac_type='9'
		begin 
			print N'Tài khoản đã bị xoá'
			rollback
		End
	if (select t_type from inserted)='1'
		begin 
			update account
			Set ac_balance=@ac_balance+ (select t_amount from inserted)
			where Ac_no in (select Ac_no From inserted)
		End
	else if (select t_type from inserted)='0'
		if (@ac_balance-(select t_amount From inserted))<50000
			begin 
				print N'Không đủ tiền'
				Rollback
			End
		else
			begin 
				update account
				Set ac_balance=@ac_balance-(select t_amount from inserted)
				where Ac_no in (select Ac_no From inserted)
			End
End

Select * from transactions
Select * from account
delete transactions where t_id=1000000055

update account
Set ac_balance=295473000
where Ac_no='1000000053'
--test 295473000(2)
INSERT INTO Transactions (t_id, t_type, t_amount, t_date, t_time, ac_no)
VALUES (1000000055, 0, 10, '2024-10-08', '10:00:00', '1000000053')

INSERT INTO Transactions (t_id, t_type, t_amount, t_date, t_time, ac_no)
VALUES (1000000412, 1, 20, '2024-10-08', '10:00:00', 1000000053)

/*
3.	Sau khi xóa dữ liệu trong transactions hãy tính lại số dư trong bảng account:
a.	Nếu là giao dịch rút
Số dư = số dư cũ + t_amount
b.	Nếu là giao dịch gửi
Số dư = số dư cũ – t_amount

	Input: thực hiện thao tác delete trên bảng transaction
	Output: update số dư. 1(thành công) 0(thất bại)
	Process:
			b1: tìm số dư tk trước khi xoá bảng. Điều kiện ac_no in (select ac_no from deleted)
			B2: +nếu (select t_type from deleted)=1 update số dư = số dư cũ – t_amount 
				nếu thành công-->output 1 ngược lại -->output 0
				+nếu (select t_type from deleted)=0 update số dư = số dư cũ + t_amount 
				nếu thành công-->output 1 ngược lại -->output 0
*/
create or alter trigger transaction_xoadl_updatesodu 
On transactions
After delete
As
Begin 
	declare @ac_balance numeric(15,4)
	select @ac_balance=ac_balance
	From account
	where Ac_no In (select Ac_no from deleted)
	If (select t_type from deleted)=1
		begin 
			update account
			Set ac_balance=@ac_balance-(select t_amount from deleted)
			where Ac_no In (select Ac_no from deleted)
			If @@ROWCOUNT=0
				begin 
					print 0
				End
			else 
				begin 
					print 1
				End
		End
	else if (select t_type from deleted)=0
		begin 
			update account
			Set ac_balance=@ac_balance+(select t_amount from deleted)
			where Ac_no In (select Ac_no from deleted)
			If @@ROWCOUNT=0
				begin 
					print 0
				End
			else 
				begin 
					print 1
				End
		End
End

Select * from transactions
Select * from account

delete transactions where t_id=1000000412

/*4.	Khi cập nhật hoặc sửa dữ liệu tên khách hàng, hãy đảm bảo tên khách không nhỏ hơn 5 kí tự. 
	input: cập nhật hoặc sửa dữ liệu tên khách hàng
	output: 1( cập nhật thành công), 0 (thât bại)
	Process:
			 -kiểm tra độ dài tên mới đổi >=5 ký tự thì update nếu thành công->output:1 ngược lại output:0
			 -ngược lại output:0
*/
create or alter trigger KH_sua_capnhat
On customer
For update
As 
begin 
	declare @cust_name nvarchar(50)
	Select @cust_name = Cust_name
	From inserted
	If len(@cust_name)<5
		begin
			print 0
			Rollback
		End
End

Update customer
Set Cust_name='Hà'
where Cust_id=000001

/*7.	Khi sửa dữ liệu trong bảng transactions hãy tính lại số dư trong bảng account:
Số dư = số dư cũ + (t_amount mới – t_amount cũ)
	input: sửa dữ liệu trong bảng transactions
	Output: cập nhật số dư , in ra 1(thành công) 0 (thất bại)
	Process: 
			b1: lưu lại giá trị số dư trước khi sửa 
			B2: update Số dư = số dư cũ + (t_amount mới – t_amount cũ)
				nếu thành công -->output 1
				Ngược lại -->output 0
*/

create or alter trigger ac_capnhatsodu
on transactions
after update 
As 
Begin 
	Update account 
	Set ac_balance=ac_balance +(inserted.t_amount-deleted.t_amount)
	FROM account	JOIN inserted  ON account.Ac_no = inserted.ac_no
					JOIN deleted ON inserted.t_id = inserted.t_id
	If @@ROWCOUNT=0
				begin 
					print 0
				End
			else 
				begin 
					print 1
				End
end
select * from transactions
select * from account

UPDATE transactions
SET t_amount = 40
WHERE t_id = 1000000055


/*10.	Khi tác động đến bảng account (thêm, sửa, xóa), hãy kiểm tra loại tài khoản. 
Nếu ac_type = 9 (đã bị xóa) thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy các thao tác vừa thực hiện.
input: 
Output: thông báo ‘tài khoản đã bị xóa’ 
Process: ac_type = 9 (đã bị xóa), điều kiện ac_no nằm trong bảng inserted/deleted
*/

create or alter trigger ac_ktloaitaikhoan
On account
for insert, update, delete
As
begin
	declare @type char(1)
	Select @type = ac_type
	From account
	where Ac_no In (select Ac_no from inserted) or Ac_no In (select Ac_no from deleted)
	If @type='9'
		begin 
			print N'Tài khoản đã bị xoá'
			Rollback
		End
End

DELETE FROM account
WHERE Ac_no = '1000000054'

INSERT INTO account (Ac_no, ac_balance, ac_type)
VALUES ('1000000054', 1000000, '1') 

UPDATE account
SET ac_type = '9'
WHERE Ac_no = '1000000054' 

/*11.	Khi thêm mới dữ liệu vào bảng customer, kiểm tra nếu họ tên và số điện thoại đã tồn tại trong bảng thì 
đưa ra thông báo ‘đã tồn tại khách hàng’ và hủy toàn bộ thao tác.*/

Create or alter trigger cus_themdulieu
On customer
after insert
as
begin
	declare @sdt varchar(11), @ten nvarchar(50)
	Select @sdt=Cust_phone, @ten=Cust_name
	From inserted
	If @ten in (select Cust_name from customer) or @sdt  in (select Cust_phone from customer)
		begin
			print N'Đã tồn tại khách hàng'
			Rollback
		End
End
Select * from customer
INSERT INTO customer (Cust_id,Cust_name, Cust_phone)
VALUES (000001,N'Hà Công Lực', '0783388103')


/*
12.	Khi thêm mới dữ liệu vào bảng account, hãy kiểm tra mã khách hàng. Nếu mã khách hàng chưa tồn tại trong bảng customer 
thì đưa ra thông báo ‘khách hàng chưa tồn tại, hãy tạo mới khách hàng trước’ và hủy toàn bộ thao tác. 
*/

Create or alter trigger acc_ktramakh
On account
After insert
As 
begin
	declare @makh varchar(15)
	Select @makh = cust_id from inserted
	If @makh not in (select Cust_id from customer)
		begin 
			print N'Khách hàng chưa tồn tại, hãy tạo mới khách hàng trước'
			Rollback
		End
End
select * from account
INSERT INTO account (Ac_no, Ac_balance, Ac_type, Cust_id)
VALUES (0000000000, 5000000.00, '1', '000300')
