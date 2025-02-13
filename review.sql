/*Cau 1: Hay tao module tinh ma san pham moi, quy tac nhu sau: ma san pham moi = MAX(ma san pham dang co trong bang)+1
input: không có
output: mã sản phẩm mới 
process:b1: tìm giá trị max(mã sản phẩm hiện tại đang có trong bảng).
		b2: mã sản phẩm mới = max(mã sản phẩm hiện tại)+1 ->output: mã sản phẩm mới
*/

create or alter function spsanpham_taomamoi()
Returns int
as 
Begin 
	declare @mamoi int, @malonnhathientai int
	Select  @malonnhathientai=Max(product_id) 
	from production.products
	set @mamoi=@malonnhathientai+1
	return @mamoi
End
select dbo.spsanpham_taomamoi()

/*Cau2: Hay tao module thuc hien cac cong viec liet ke duoi day neu biet: ten san pham, ma thuong hieu (brand_id), 
loai san pham (catogory_id), mau (model_year), gia(list_price)
a. Kiem tra ma thuong hieu da ton tai trong bang thuong hieu (brands) hay chua. Neu chua, thong bao loi va ket thuc.
b. Kiem tra ma loai san pham da ton tai trong bang loai san pham (categories) hay chua. Neu chua, thong bao loi va ket thuc.
c. Kiem tra mau co phai la nam trong tuong lai hay khong. Neu dung la nam trong tuong lai thi thong bao loi va ket thuc.
d. Kiem tra gia co hop le hay khong (hop le: >0). Neu khong, thong bao loi va ket thuc
e. Them moi mot san pham vao bang products vo gia tri da biet
*/
/*
input:ten san pham, ma thuong hieu (brand_id), loai san pham (catogory_id), mau (model_year), gia(list_price)
Output: trả về 0(thất bại), 1(thành công)
Process:
1. Kiem tra ma thuong hieu da ton tai trong bang thuong hieu (brands) hay chua. Neu chua, thong bao loi va ket thuc.
	1.1: tìm mã thương hiệu trong bảng brands
	1.1a: nếu mã thương hiệu tồn tại thì tiếp tục 
	1.1b: nếu không tồn tại --> output 0, kết thúc quy trình
2. Kiem tra ma loai san pham da ton tai trong bang loai san pham (categories) hay chua. Neu chua, thong bao loi va ket thuc.
	2.1: tìm ma loai san pham da ton tai trong bang loai san pham (categories)
	2.1a: nếu mã loai san pham tồn tại thì tiếp tục 
	2.1b: nếu không tồn tại --> output 0, kết thúc quy trình
3. Kiem tra mau co phai la nam trong tuong lai hay khong. Neu dung la nam trong tuong lai thi thong bao loi va ket thuc.
	3.1 so sánh year(mau) với year(getdate()) 
	3.1a: nếu  year(mau) > year(getdate()) --> output 0 ,  kết thúc quy trình 
	3.1b: nếu year(mau) <= year(getdate()) thì tiếp tục 
4. Kiem tra gia co hop le hay khong (hop le: >0). Neu khong, thong bao loi va ket thuc
	4.1a: nếu giá >0 --> tiếp tục quy trình 
	4.1b: nếu giá <=0 --> output: 0, kết thúc quy trình 
5 Tạo mã giao dịch mới 
5. Them moi mot san pham vao bang products vo gia tri da biet
	5.1 thêm sản phẩm mới vào bảng 
	5.2 nếu @@rowcount =0 -->  output: 0
	5.3 ngược lại -->output: 1
*/
Go
create or alter proc sp_themsanpham(@product_name varchar(255),
									@brand_id int, 
									@catogory_id int,
									@model_year int,
									@list_price decimal(10,2),
									@ret bit out)
As 
Begin 
	
	if @brand_id not in (select brand_id from production.brands)
		begin 
			print N'Lỗi thương hiệu'
			Set @ret=0
			Return
		End

	if @catogory_id not in (select category_id from production.categories)
		begin 
			print N'Lỗi mã sp'
			Set @ret=0
			Return
		End

	if @model_year > YEAR(getdate())
		begin
			print N'Lỗi năm'
			Set @ret=0
			Return
		End

	If @list_price <=0 
		begin 
			print N'Lỗi giá'
			Set @ret=0
			Return
		End
	--
	Declare @product_id int

	
	insert production.products (product_name,brand_id,category_id,model_year,list_price)
	Values (@product_name,@brand_id,@catogory_id,@model_year,@list_price)
	If @@ROWCOUNT =0 
		begin
			print 'Lỗi insert thất bại'
			Return
		End
	else 
		begin
			print 'TC'
		End
End
Declare @ten nvarchar(200),
		@mathuonghieu int,
		@makho int,
		@nam int,
		@gia decimal(10,2),
		@ketqua bit
set @mathuonghieu=1
Set @makho=1
Set @nam =2024
Set @gia= 55
exec sp_themsanpham 'noname',@mathuonghieu, @makho, @nam,@gia,@ketqua out
Print @ketqua

/*Cau 3: Khi them mot thuong hieu moi, hay dam bao rang ten thuong hieu nay chua ton tai trong bang thuong hieu (brands)
bang: production.brands
loai: after
su kien:insert
process:b1: kiểm tra tên thương hiệu tồn tại trong bảng thương hiệu chưa
		b2: nếu đã có tên thương hiệu trong bảng --> ngừng xử lí, output 0
		B3 thêm tên thương hiệu vào bảng 
		B4 @@rowcount =0 -->output 0 ngược lại output 1

		*/

Go
create or alter trigger tg_themthuonghieumoi
on production.brands
After insert 
As
begin
	declare @tenthuonghieu nvarchar(200)
	Select @tenthuonghieu=brand_name from inserted
	if (Select (count (*)) From production.brands where brand_name=@tenthuonghieu) >=1
		begin
			print N'Tên sản phẩm đã tồn tại'
			Rollback
		End
End
Insert production.brands (brand_name)
Values ('Electr')

--Kiểm tra tên sản phẩm hợp lệ. Tên hợp lệ: <chuỗi> - <4 chữ số>, trong đó 4 chữ số cuối có giá trị bằng với năm sản xuất"
Go
create or alter trigger sp_tenhople
On [production].[products]
After insert 
As
Begin
	declare @so int , @year int
	Select @so=cast(RIGHT(product_name,4) as int),@year=model_year from inserted
	If @so <> @year
		begin 
			print N'Lỗi'
			Rollback
		End
End
Select * from production.products
INSERT INTO production.products ( product_name, brand_id, category_id, model_year, list_price)
VALUES ( 'nam 2014', 9, 6, 2014, 379.99)

