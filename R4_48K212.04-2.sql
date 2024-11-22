-----------------------------------------------------------TẠO DATABASE---------------------------------------------------------------------
USE master;  
GO  
IF DB_ID (N'QuanlybanhangWinMart') IS NOT NULL  
DROP DATABASE QuanlybanhangWinMart;  
GO  
CREATE DATABASE QuanlybanhangWinMart  
go
use QuanlybanhangWinMart
go

-- CREATE TABLE NHA CUNG CAP
CREATE TABLE NHACUNGCAP (
	MaNCC		CHAR(8) PRIMARY KEY,
	TenNCC		Nvarchar(100) not null,
	DiaChiNCC	Nvarchar(50) not null,
	SDT_NCC		varchar(15) unique
)

--Create table DON VI VAN CHUYEN
CREATE TABLE DONVIVANCHUYEN (
	MaDVVC	char(7) primary key,
	TenNVC	Nvarchar(30) Not null,
	NgayGiaoHang datetime not null,
	SDT_NVC	varchar(15) Unique
)

--Create table NHAN VIEN
CREATE TABLE NHANVIEN (
	MaNV	char(8) primary key,
	TenNV	Nvarchar(30) not null,
	SDT_NV	varchar(15) Unique
)

-- Create table DAT
CREATE TABLE DAT (
	MaHDN	char(8) primary key,
	NgayDat	datetime not null,
	GhiChu	Nvarchar(30),
	MaNCC	char(8),
	MaNV	char(8),
	MaDVVC	char(7),
	FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP (MaNCC) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MaNV) REFERENCES NHANVIEN (MaNV) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MaDVVC) REFERENCES DONVIVANCHUYEN (MaDVVC) ON DELETE CASCADE ON UPDATE CASCADE
)

-- Create table SANPHAM
CREATE TABLE SANPHAM (
	MaHangVin	char(8) primary key,  -- sua code hang vin tu 7 sang 8
	MaSP		char(9) Unique,
	TenSP		Nvarchar(50) not null,
	DVT			Nvarchar(10) not null,
	DonGiaNhap	decimal(10,2) check (DonGiaNhap > 0) not null,
	DonGiaBan	decimal(10,2) check (DonGiaBan > 0) not null,
	KhuyenMai	Decimal(4,2) check(KhuyenMai >= 0) not null ,  -- sua code cho nay tu default 0 thanh check >= 0
	HanSuDung	date not null,
	Sl_SP		int check (SL_SP >= 0) not null
)

-- Create table DAT_CHI TIET
CREATE TABLE DAT_CHITIET (
	MaHDN		char(8),
	MaHangVin	char(8),
	Sl_Nhap		int check (SL_Nhap > 0) not null,
	PRIMARY KEY (MaHDN, MaHangVin),
	FOREIGN KEY (MaHDN) REFERENCES DAT (MaHDN) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MaHangVin) REFERENCES SANPHAM (MaHangVin) ON DELETE CASCADE ON UPDATE CASCADE
)

-- create table KHACH HANG
CREATE TABLE KHACHHANG (
	MaKH	char(8) primary key,
	LoaiKH	bit not null,
	SDT_KH	varchar(15), -- sua code tu unique thanh khong co unique
	UuDai	Decimal (4,2) check (UuDai >= 0) not null  -- su tu default 0 thanh check >= 0
)

-- create table BAN
CREATE TABLE BAN (
	MaHDB	char(15) primary key,
	NgayBan datetime not null,
	PTTT	Nvarchar(20) not null,
	MaNV	char(8),
	MaKH	char (8),
	FOREIGN KEY (MaNV) REFERENCES NHANVIEN (MaNV) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MaKH) REFERENCES KHACHHANG (MaKH) ON DELETE CASCADE ON UPDATE CASCADE
)

-- create table BAN_CHI TIET
CREATE TABLE BAN_CHITIET (
	MaHDB		char(15),
	MaHangVin	char(8),
	SL_Ban		int check (SL_Ban > 0) not null,
	PRIMARY KEY (MaHDB, MaHangVin),
	FOREIGN KEY (MaHDB) REFERENCES BAN (MaHDB) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MaHangVin) REFERENCES SANPHAM (MaHangVin) ON DELETE CASCADE ON UPDATE CASCADE
)

--create table Account 
CREATE TABLE ACCOUNT (
	Ac_no		INT IDENTITY (1, 1) PRIMARY KEY,
	TenTK		varchar(30),
	LoaiTK		varchar(20),
	MatKhau		varchar(20)
)
Insert into account
values	('ThanhSang', 'admin','123123'),
		('ThanhBinh', 'user','123@@@'),
		('DoanDiem', 'admin','456456'),
		('NgoThinh', 'user','123456'),
		('ThuyDuong', 'user','abcdef')
select * from ACCOUNT
----------------------------------------------------------END TẠO DATABASE--------------------------------------------------------------------



-------------------------------------------------------------DATA DUMP-------------------------------------------------------------------------

/*1)---------------------------------------------------------------NHÀ CUNG CẤP--------------------------------------------------------------------------------*/
go
CREATE OR ALTER PROCEDURE spInsertData_NHACUNGCAP
AS
BEGIN
    DECLARE @mancc CHAR(8), 
			@tenncc NVARCHAR(50), 
			@diachincc NVARCHAR(50), 
			@sdtncc VARCHAR(15), 
			@i INT = 1, 
			@kq int, 
			@ret int

    WHILE @i <= 1000
		BEGIN
 
			SET @MaNCC = RIGHT('00000000' + CAST(@i AS VARCHAR(8)), 8)
  
			-- Tạo giá trị TenNCC
			SET @tenncc = N'Nhà cung cấp ' + CAST(@i AS VARCHAR(10));
        
			-- Tạo giá trị DiaChiNCC
			SET @diachincc = N'Địa chỉ của nhà cung cấp ' + CAST(@i AS VARCHAR(10))
        
			-- Tạo số điện thoại ngẫu nhiên
			SET @sdtncc =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
								else '03'
							END
						+ RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)

			INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChiNCC, SDT_NCC)
			VALUES (@mancc, @tenncc, @diachincc, @sdtncc)
			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End
			-- Tăng giá trị đếm
			SET @i = @i + 1
		END
END
exec spInsertData_NHACUNGCAP
select * from NHACUNGCAP
/*-------------------------------------------------END NHÀ CUNG CẤP-----------------------------------------------------------------*/

/*2-------------------------------------------------------------ĐƠN VỊ VẬN CHUYỂN---------------------------------------------------------------*/
go
CREATE or alter PROCEDURE spInsertData_DONVIVANCHUYEN
AS
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 1000
		BEGIN
			INSERT INTO DONVIVANCHUYEN (MaDVVC, TenNVC, NgayGiaoHang, SDT_NVC)
			VALUES (
				RIGHT('0000000' + CAST(@i AS VARCHAR(7)), 7),
				N'Đơn vị vận chuyển ' + CAST(@i AS NVARCHAR(10)),
				DATEADD(DAY, -FLOOR(RAND() * 1825), GETDATE()),
				(CASE FLOOR(RAND() * 3)
					WHEN 0 THEN '09'
					WHEN 1 THEN '01'
					WHEN 2 THEN '07'
					Else '03'
				END) + RIGHT('00000000' + cast (CAST(FLOOR(RAND() * 100000000)as int) AS VARCHAR(8)), 8)
			)

			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			SET @i = @i + 1
		END
END
exec spInsertData_DONVIVANCHUYEN
Select * from DONVIVANCHUYEN
/*-------------------------------------------------------------END ĐƠN VỊ VẬN CHUYỂN---------------------------------------------------------------*/


/*3-------------------------------------------------------NHÂN VIÊN------------------------------------------------------------*/
go
CREATE OR ALTER PROCEDURE spInsertData_NHANVIEN
AS
BEGIN
    DECLARE @manv CHAR(8), 
			@tennv varchar(30), 
			@sdtnv varchar(15), 
			@i INT = 1, @kq int, 
			@ret int
    WHILE @i <= 1000
		BEGIN
			-- Tạo giá trị Manv
			SET @Manv = '2' + RIGHT ('0000000' + CAST(@i AS VARCHAR(8)), 7)
        
			-- Tạo giá trị TenNV
			SET @tennv = 'Nhân viên ' + CAST(@i AS VARCHAR(10))
        
			-- Tạo số điện thoại ngẫu nhiên
			SET @sdtnv =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
								else '03'
							END
						+ RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)

			INSERT INTO NHANVIEN(MaNV, TenNV, SDT_NV)
			VALUES (@MaNV, @TenNV, @SDTNV)
			
			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			-- Tăng giá trị đếm
			SET @i = @i + 1
		END
END
exec spInsertData_NHANVIEN
select * from NHANVIEN

/*---------------------------------------------------END NHÂN VIÊN------------------------------------------------------------------------*/

/*4-------------------------------------------------ĐẶT---------------------------------------------------------------------*/
go
CREATE or ALTER PROCEDURE spInsertData_DAT
AS
BEGIN
    DECLARE @i INT = 1,
			@MaNCC CHAR(8),
			@MaNV CHAR(8),
			@MaDVVC CHAR(7),
			@GhiChu NVARCHAR(30),
			@NgayDat DATETIME 

    WHILE @i <= 1000
    BEGIN
        SELECT TOP 1 @MaNCC = MaNCC FROM NHACUNGCAP ORDER BY NEWID()

        SELECT TOP 1 @MaNV = MaNV FROM NHANVIEN ORDER BY NEWID()

        SELECT TOP 1 @MaDVVC = MaDVVC FROM DONVIVANCHUYEN ORDER BY NEWID()

		Set @NgayDat= DATEADD(DAY, -FLOOR(RAND() * 1825), GETDATE())
        IF RAND() < 0.5
			BEGIN
				SET @GhiChu = N'Khuyến mãi'
			END
        ELSE
			BEGIN
				SET @GhiChu = NULL
			END

        INSERT INTO DAT (MaHDN, NgayDat, GhiChu, MaNCC, MaNV, MaDVVC)
        VALUES (
            'HDN'+RIGHT('000' + CAST(@i AS VARCHAR(4)), 4), @NgayDat, @GhiChu, @MaNCC,@MaNV, @MaDVVC)

		If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End
        SET @i = @i + 1
    END
END
EXEC spInsertData_DAT
select * from DAT

/*------------------------------------------------------END ĐẶT-------------------------------------------------------------------------*/


/*5--------------------------------------------------SẢN PHẨM-----------------------------------------------------------------*/
go
CREATE OR ALTER PROCEDURE InsertData_SANPHAM
AS
BEGIN
    DECLARE @i INT = 1,
			@MaHangVin CHAR(8),
			@MaSP CHAR(9),
			@TenSP NVARCHAR(50),
			@DVT NVARCHAR(10),
			@DonGiaNhap DECIMAL(10, 2),
			@DonGiaBan DECIMAL(10, 2),
			@KhuyenMai DECIMAL(4, 2),
			@HanSuDung DATE,
			@SL_SP INT

    WHILE @i <= 1000
		BEGIN
			SET @MaHangVin = 'MHV' + RIGHT('00000' + CAST(@i AS VARCHAR(8)), 5)
		
			SET @MaSP = 'SP' + RIGHT('00000000' + CAST(@i AS VARCHAR(7)), 7)

			SET @TenSP = N'Sản phẩm ' + CAST(@i AS NVARCHAR(50))
   
			SET @DVT =	CASE FLOOR(RAND() * 4)
							WHEN 0 THEN N'Cái'
							WHEN 1 THEN N'Hộp'
							WHEN 2 THEN N'Chai'
							WHEN 3 THEN N'Kg'
							ELSE N'Thùng'  
						END

			DECLARE @ThapPhanDauTien INT
			
			Set @DonGiaNhap = CAST(800 * RAND() AS DECIMAL(10, 2))
			set @ThapPhanDauTien = CAST((@DonGiaNhap * 10) % 10 AS INT)

			IF @ThapPhanDauTien < 5
				begin
					SET @DonGiaNhap = FLOOR(@DonGiaNhap)  
				End
			ELSE
				begin
					SET @DonGiaNhap = FLOOR(@DonGiaNhap) + 0.99
				End

			SET @DonGiaBan = @DonGiaNhap + (@DonGiaNhap*0.02)

			SET @KhuyenMai = CASE WHEN RAND() < 0.3 THEN 0 ELSE CAST(Round(RAND(),2)  AS DECIMAL(4, 2)) END

			SET @HanSuDung = DATEADD(DAY, FLOOR(RAND() * 730), GETDATE())
    
			SET @SL_SP = FLOOR(RAND() * 1000)

			INSERT INTO SANPHAM (MaHangVin, MaSP, TenSP, DVT, DonGiaNhap, DonGiaBan, KhuyenMai, HanSuDung, Sl_SP)
			VALUES (@MaHangVin, @MaSP, @TenSP, @DVT, @DonGiaNhap, @DonGiaBan, @KhuyenMai, @HanSuDung, @SL_SP)

			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			SET @i = @i + 1
		END
END
EXEC InsertData_SANPHAM
Select * from SANPHAM

/*--------------------------------------------------------------------------------END SẢN PHẨM-----------------------------------------------------------------------------------*/


/*6---------------------------------------------ĐẶT CHI TIẾT---------------------------------------------------------------------------*/
go
CREATE OR ALTER PROCEDURE spInsertData_DATCHITIET
AS
BEGIN
    DECLARE @i INT = 1, @MaHDN CHAR(7),@MaHangVin CHAR(8),@SL_Nhap INT
    WHILE @i <= 2000
		BEGIN

			SELECT TOP 1 @MaHDN = MaHDN FROM DAT ORDER BY NEWID()

			SELECT TOP 1 @MaHangVin = SANPHAM.MaHangVin FROM SANPHAM ORDER BY NEWID()

			SET @SL_Nhap = FLOOR(RAND() * 1000) + 1 -- vi luong khong duoc <= 0
			INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, SL_Nhap)
			VALUES (@MaHDN, @MaHangVin, @SL_Nhap)
			
			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			SET @i = @i + 1
		END
END
EXEC spInsertData_DATCHITIET
Select * from DAT_CHITIET 


/*------------------------------------------------------------END ĐẶT CHI TIẾT------------------------------------------------------------*/

/*7--------------------------------------------------------------------KHÁCH HÀNG----------------------------------------------------------------------------------------*/
go
CREATE OR ALTER PROCEDURE spInsertData_KHACHHANG
AS
BEGIN
    DECLARE @makh CHAR(8), 
			@loaiKH bit, 
			@sdtkh VARCHAR(15), 
			@uudai decimal(4,2), 
			@i INT = 1, @kq int, 
			@ret int

    WHILE @i <= 1000
		BEGIN
			-- Tạo giá trị MaKH
			SET @Makh = '1' +RIGHT('0000000' + CAST(@i AS VARCHAR(8)), 7)
        
			-- Tạo loai khach hang
			SET @loaiKH = CAST(ABS(CHECKSUM(NEWID())) % 2 AS INT)
        
			-- Tạo số điện thoại ngẫu nhiên
			SET @sdtkh =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
								WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
								else '03'
							END
						+ RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)

			-- Thiet lap gia tri uu dai
			SET @uudai = CASE WHEN RAND() < 0.3 THEN 0 ELSE CAST(Round(RAND(),2)  AS DECIMAL(4, 2)) END

			--kiểm tra khi loại khách hàng = 0 thì sdt 'khong co' và uudai = 0
			if @loaiKH = 0
			begin
				set @sdtkh = Null
				set @uudai = 0
			end

			--kiem tra so dien thaoi co trung hay khong
			IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE SDT_KH = @sdtkh)
			BEGIN
				INSERT INTO KHACHHANG (MaKH, LoaiKH, SDT_KH, UuDai)
				VALUES (@MaKH, @LoaiKH, @SDTKH, @UuDai)
			END
			-- kiểm tra số diện thoại có bị trùng hay không
			else
			begin
				PRINT N'Sdt ' + @sdtkh + ' đã tồn tại . Không thể chèn.'
				continue
			end

			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			-- Tăng giá trị đếm
			SET @i = @i + 1
		END
END

exec spInsertData_KHACHHANG
select * from khachhang

/*-------------------------------------------------END KHÁCH HÀNG-----------------------------------------------------------------*/

/*8------------------------------------------------------------------BÁN---------------------------------------------------------------------------------------*/
go
create or alter proc spInsertData_BAN
as
begin
	DECLARE @maHDB CHAR(15), 
			@ngayban datetime, 
			@pttt Nvarchar(20), 
			@manv char(8), 
			@maKH char(8),
			@i INT = 1

    WHILE @i <= 1000
		BEGIN
			-- Tạo giá trị MaHDB char(15)
			SET @Mahdb = 'HDB' + RIGHT ('000000000000' + CAST(@i AS VARCHAR(15)), 12)
        
			DECLARE @StartDate DATETIME = '2020-01-01 00:00:00', -- Ngày bắt đầu
					@EndDate DATETIME = GETDATE()  -- Ngày kết thúc (ngày hiện tại)
			-- Tạo giá trị datetime ngayban ngẫu nhiên
			SET @ngayban = DATEADD(SECOND,FLOOR(RAND() * DATEDIFF(SECOND, @StartDate, @EndDate)), @StartDate)
        
			-- Tạo pttt
			SET @pttt =	CASE		--Rand() nó sẽ cho ra kiểu dữ liệu là float
							WHEN floor(RAND(CHECKSUM(newid())) * 2) = 0 THEN N'Tiền mặt'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN 'QR'
							else 'ATM'
						END

			-- Tạo giá trị maNV
			SELECT TOP 1 @manv = MaNV
			FROM nhanvien
			ORDER BY NEWID()

			-- Tạo giá trị MakH
			SELECT TOP 1 @maKh = MaKH
			FROM KHACHHANG
			ORDER BY NEWID()

			INSERT INTO BAN(maHDB, ngayban, pttt , manv , maKH )
			VALUES (@maHDB , @ngayban , @pttt , @manv , @maKH )

			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End

			-- Tăng giá trị đếm
			SET @i = @i + 1
		END
end
exec spInsertData_BAN
select * from BAN
delete ban
where [MaHDB]='HDB000000000002'
/*--------------------------------------------------------------END BÁN-----------------------------------------------------------------------------------------------------------------*/



/*9-------------------------------------------------------------------BÁN CHI TIẾT----------------------------------------------------------------------------------------------------------------*/
go
create or alter proc spInsertData_BANCHITIET
as
begin
	DECLARE @maHDB CHAR(15), 
			@MaHangVin char(8), 
			@sLBan int,
			@i int = 1

	while @i <= 2000
		begin
			-- Tạo giá trị maHDB
			SELECT TOP 1 @maHDB = MaHDB
			FROM BAN
			ORDER BY NEWID()

			-- Tạo giá trị MaHangVin
			SELECT TOP 1 @MaHangVin  = MaHangVin
			FROM SANPHAM
			ORDER BY NEWID()
			

			-- Tao gia tri cho so luong ban
			select @sLBan = FLOOR(RAND() * 20) + 1

			INSERT INTO BAN_CHITIET(maHDB, MaHangVin, sL_Ban )
			VALUES (@maHDB, @MaHangVin, @sLBan)

			If @@ROWCOUNT=0
				begin 
					set @i=@i
					Continue
				End
			set @i = @i  + 1
		end
end
 
exec spInsertData_BANCHITIET
select * from BAN_CHITIET


/*-------------------------------------------------------------END DATA DUMP--------------------------------------------------------------------------------*/





/*--------------------------------------------------------------------------MODULE-----------------------------------------------------------------------------*/

/*1)------------------------------------------------------------------------NHÀ CUNG CẤP-----------------------------------------------------------------------------*/
---------------------------THỦ TỤC------------------------------------
go
create or alter proc spChkNCC	@tenncc Nvarchar(40),
								@diachiNCC Nvarchar(50),
								@sdt_ncc varchar(15),
								@kq bit out
as
begin
	set @kq = 1
	-- kiem tra sdt 
	if len(@sdt_ncc) > 10 or len(@sdt_ncc) < 10 
	begin
		print N'Số điện thoại chỉ chứa 10 ký tự!'
		set @kq = 0
		return
	end

	--insert into
	if @kq = 1
	begin
		insert into NHACUNGCAP (MaNCC,TenNCC,DiaChiNCC,SDT_NCC)
		values (dbo.fGetNewIDNCC(), @tenncc, @diachiNCC, @sdt_ncc)
	end
end

declare	@tenncc Nvarchar(40),
		@diachiNCC Nvarchar(50),
		@sdt_ncc varchar(15),
		@kq bit
set @tenncc = N'Nhà cung cấp 1002'
set @diachiNCC = N'Địa chỉ nhà cung cấp 1002'
set @sdt_ncc = '09036784922'
exec spChkNCC	@tenncc,
				@diachiNCC,
				@sdt_ncc,
				@kq out
print @kq
--------------------------END THỦ TỤC---------------------------------

-----------------------------HÀM-------------------------------
--tao ma moi cho nha cung cap
go 
create or alter function fGetNewIDNCC()
returns varchar(10)
as
begin
	declare @maxID varchar(10)
	declare @NewID varchar(10)
	select @maxID = max(mancc) from nhacungcap 
	set @NewID = @maxID +1
	set @NewID = right('00000000' + @NewID,8)
	return @NewID 
end
select dbo.fGetNewIDNCC()

-------------------------END HÀM---------------------------------
/*-------------------------------------------------------------------------END NHÀ CUNG CẤP----------------------------------------------------------------------------*/


/*2)---------------------------------------------------------------------ĐƠN VỊ VẬN CHUYỂN-----------------------------------------------------------------------------*/
------------------------THỦ TỤC-------------------------------
go
create or alter proc spChkDVVC	@tennvc nvarchar(50),
								@ngayGiaoHang datetime,
								@Sdt_nvc varchar(15),
								@kq bit out
as
begin
	set @kq = 1
	-- kiem tra ngay giao hang
	if @ngayGiaoHang > getdate() or (cast(@ngayGiaoHang as Date) = cast(getdate() as date) and cast(@ngayGiaoHang as time) > cast(getdate() as time))
	begin
		print N'Ngày giao hàng không hợp lệ!'
		set @kq = 0
		return
	end

	--Kiem tra ky tu cua so dien thoai
	if len(@sdt_nvc) > 10 or len(@sdt_nvc) < 10
	begin
		print N'Số điện thoại không hợp lệ!'
		set @kq = 0
		return
	end

	--insert
	if @kq = 1
	begin
		insert into DONVIVANCHUYEN (MaDVVC, TenNVC, NgayGiaoHang,SDT_NVC)
		values (dbo.fGetNewIDDVVC(), @tennvc, @ngayGiaoHang, @Sdt_nvc)
	end
end

declare @tennvc nvarchar(50),
		@ngayGiaoHang datetime,
		@Sdt_nvc varchar(15),
		@kq bit
set @tennvc = N'Nhà cung cấp 1001'
set @ngayGiaoHang = '2024-10-19'
set @Sdt_nvc = '09356950120'
exec spChkDVVC @tennvc, @ngayGiaoHang, @sdt_nvc, @kq out
print @kq
----------------------------END THỦ TỤC----------------------------------

-------------------------------HÀM-----------------------------------------
--tao ma dvvc tu dong
go
create or alter function fGetNewIDDVVC()
returns varchar(20)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(MaDVVC) from DONVIVANCHUYEN  --MHV 00001

	select @newID = right('0000000' + cast(@oldID + 1 as varchar(10)),7)

	return @newID
end
select dbo.fGetNewIDDVVC()
-------------------------END HÀM-----------------------------------------

/*---------------------------------------------------------------------END ĐƠN VỊ VẬN CHUYỂN-----------------------------------------------------------------------------*/



/*3)---------------------------------------------------------------------NHÂN VIÊN--------------------------------------------------------------------------------*/
------------------------THỦ TỤC------------------------------
-- Kiem tra du lieu cua bang Nhan vien
create or alter proc spChkNV	@tenNv nvarchar(40),
								@sdt_nv varchar(15),
								@kq bit out
as
begin
	set @kq = 1
	-- Kiem tra sdt nhan vien
	if len(@sdt_nv) > 10 or len(@sdt_nv) < 10 
	begin
		print N'Số điện thoại chỉ chứa 10 ký tự!'
		set @kq = 0
		return
	end

	--insert into
	if @kq = 1
	begin
		insert into NHANVIEN (MaNV, TenNV, SDT_NV)
		values (dbo.fGetNewIDNV(), @tenNv, @sdt_nv)
	end
end

declare @tenNv nvarchar(40),
		@sdt_nv varchar(15),
		@kq bit
set @tenNv = 'abc'
set @sdt_nv = '09934275670'
exec spChkNV @tennv, @sdt_nv, @kq out
print @kq
------------------------------END THỦ TỤC----------------------

----------------------------HÀM-----------------------------------
--Tạo mã id nhana viên mới
go 
create or alter function fGetNewIDNV()
returns varchar(10)
as
begin
	declare @maxID varchar(10)
	declare @NewID varchar(10)
	select @maxID = max(manv) from nhanvien
	set @NewID = @maxID +1
	set @NewID = '2' + right('0000000' + @NewID,7)
	return @NewID 
end
select dbo.fGetNewIDNV()


--------------------------END HÀM------------------------------------
/*---------------------------------------------------------------------END NHÂN VIÊN-------------------------------------------------------------------------------*/



/*4)---------------------------------------------------------------------ĐẶT-----------------------------------------------------------------------------*/
--------------------------THỦ TỤC-----------------------------------
go
create or alter proc spChkDat	@ngayDat datetime,
								@Ghichu nvarchar(50),
								@mancc varchar(10),
								@manv varchar(10),
								@madvvc varchar(10),
								@kq bit out
as
begin
	set @kq = 1
	-- Kiem tra ngay dat co hop le hya khong
	if @ngayDat > getdate() or (cast(@ngayDat as Date) = cast(getdate() as date) and cast(@ngayDat as time) > cast(getdate() as time))
	begin
		print N'Ngày đặt hàng không hợp lệ!'
		set @kq = 0
		return
	end

	-- Kiem tra ma nha cung co ton tai hay khong
	if not exists (select 1 from NHACUNGCAP where MaNCC = @mancc)
	begin
		print N'Mã nhà cung cấp không tồn tại!'
		set @kq = 0
		return
	end

	-- Kiem tra ma nhan vien co ton tai hay khong
	if not exists (select 1 from NHANVIEN where MaNV = @manv)
	begin
		print N'Mã nhân viên không tồn tại!'
		set @kq = 0
		return
	end

	-- Kiem tra ma dvvc co ton tai hay khoong
	if not exists (select 1 from DONVIVANCHUYEN where MaDVVC = @madvvc)
	begin
		print N'Mã đơn vị vận chuyển không tồn tại!'
		set @kq = 0
		return
	end

	--insert
	if @kq = 1
	begin
		insert into DAT (maHDN, NgayDat, GhiChu, MaNCC, MaNV, MaDVVC)
		values (dbo.getNewIDNhap(), @ngayDat, @Ghichu, @mancc, @manv, @madvvc)

		if @@rowcount <= 0
		begin
			print 'insert that bai'
			set @kq = 0
			return
		end

	end
end


declare		@ngayDat datetime,
			@Ghichu nvarchar(50),
			@mancc varchar(10),
			@manv varchar(10),
			@madvvc varchar(10),
			@kq bit
set @ngayDat ='2024-10-17'
set @Ghichu = ''
set @mancc = '00001002'
set @manv = '20000222'
set @madvvc = '0000917'
exec spChkDat	@ngayDat,
				@Ghichu,
				@mancc,
				@manv,
				@madvvc,
				@kq out
print @kq

select * from DAT	

-- Cho phép xóa dữ liệu của hóa đơn nhập khi không có trong bảng đặt chi tiết
go
create or alter proc tDeleteHDN @mahdn varchar(15), @thongbao nvarchar(100) out
as
begin
	declare @soLuongMaHDN int

	set @soLuongMaHDN = (select count(*) 
						from DAT_CHITIET
						where DAT_CHITIET.MaHDN = @mahdn)

	if @soLuongMaHDN > 0
	begin
		set @thongbao = N'Đơn nhập hàng đã được nhập trong chi tiết' + N'. Không thể xóa đơn hàng!'
		return
	end
	else
	begin
		delete DAT
		where MaHDN = @mahdn
	end 
end

declare	 @mahdn varchar(15), @thongbao nvarchar(100)
set @mahdn = 'HDN00006'
exec tDeleteHDN  @mahdn , @thongbao out 
print @thongbao
select * from DAT_CHITIET
-----------------------------END THỦ TỤC--------------------------------

------------------------HÀM-------------------------------
-- Tao ra ma id moi cho bang DAT	
go
create or alter function getNewIDNhap ()
returns varchar(15)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(MaHDN) from DAT  --MHV 00001

	select @newID = 'HDN' + right('00000' + cast(right(@oldID, len(@oldId) - 3) + 1 as varchar(15)), 5)

	return @newID
end
select dbo.getNewIDNhap()

----------------------END HÀM---------------------------

/*---------------------------------------------------------------------END ĐẶT-----------------------------------------------------------------------------*/




/*5)------------------------------------------------------------------SẢN PHẨM-----------------------------------------------------------------------------*/
---------------------Thủ Tục---------------------------
go
create or alter proc spChkSP	@tensp Nvarchar(40),
								@DVT Nvarchar(20),
								@DonGiaNhap decimal(10,2),
								@khuyenMai decimal (4,2),
								@hanSuDung date,
								@sl_sp int,
								@kq bit out

	
as
begin
	declare @dongiaban decimal(10,2)
	set @kq = 1
	
	-- tinh don gia ban tu don gia nhap voi ty le 2%
	set @dongiaban = @DonGiaNhap + (@DonGiaNhap*0.02)

	-- Kiem tra han su dung ( hop le khi han su dung >= getdate())
	if @hanSuDung < GETDATE() 
	begin
		print N'Sản phẩm đã hết hạn'
		set @kq = 0;
		return
	end
	else

	-- insert into
	if @kq = 1
	begin
		insert into SANPHAM (MaHangVin, MaSP, TenSP, DVT, DonGiaNhap, DonGiaBan,KhuyenMai,HanSuDung,Sl_SP)
		values(dbo.getNewIDHangVin(), dbo.getNewIDSanPham(), @tensp, @DVT, @DonGiaNhap, @DongiaBan, @khuyenMai, @hanSuDung, @sl_sp)

		if @@rowcount <= 0
		begin
			print 'insert that bai'
			set @kq = 0
			return
		end

	end
end

declare @tensp Nvarchar(40),
		@DVT Nvarchar(20),
		@DonGiaNhap decimal(10,2),
		@DongiaBan decimal(10,2),
		@khuyenMai decimal (4,2),
		@hanSuDung date,
		@sl_sp int,
		@kq bit
set @tensp = N'Sản phẩm 1001'
set @DVT = N'Hộp'
set @DonGiaNhap = 50.99
set @khuyenMai = 0.45
set @hanSuDung = '2024-12-19'
set @sl_sp = 100
exec spChkSP @tensp,
			@DVT,
			@DonGiaNhap,
			@khuyenMai ,
			@hanSuDung ,
			@sl_sp ,
			@kq out
print @kq
select * from SANPHAM


--------------End Thủ Tục---------------------------------

-------------------HÀM-------------------------------
--- Tinh tong cho hoa don
go
create or alter function getTotalHD(@maHD varchar(15))
returns numeric(20,2)
as
begin
	declare @soLuongBan int,
			@soLuongNhap int, 
			@giaBan decimal(10,2), 
			@giaNhap decimal (10,2), 
			@khuyenmai decimal (4,2),
			@uudai decimal (4,2),
			@tongTien float = 0,
			@rowCount int,
			@index int;


	if left(@maHD,3) = 'HDB'
	begin
		select @rowCount = count(*) from BAN_CHITIET where MaHDB = @maHD
		set @index = 1
		while @index <= @rowCount
		begin
			SELECT @soLuongBan = Sl_ban, @giaBan = dongiaban, @khuyenmai = khuyenmai, @uudai = uudai
			FROM (
				SELECT sl_ban,DonGiaBan, SANPHAM.KhuyenMai, KHACHHANG.UuDai, ROW_NUMBER() OVER (ORDER BY BAN_chitiet.MaHDB ASC) AS RowNum
				FROM Ban join BAN_CHITIET on Ban.MaHDB = BAN_CHITIET.MaHDB join SANPHAM on BAN_CHITIET.MaHangVin = SANPHAM.MaHangVin
						join KHACHHANG on KhachHang.maKH = BAN.MaKH
				where ban_chitiet.MaHDB = @maHD
			) AS OrderedData
			WHERE OrderedData.RowNum = @index;
			
			if @khuyenmai = 0 and @uudai <> 0
			BEGIN 
				set @tongTien = @tongTien + (@giaBan * @soLuongBan * @uudai )
			END
			else if @khuyenmai <> 0  and @uudai = 0
			begin
				set @tongTien = @tongTien + (@giaBan * @soLuongBan *@khuyenmai)
			end
			ELSE
			BEGIN
				set @tongTien = @tongTien + (@giaBan * @soLuongBan *@khuyenmai * @uudai )
			END
			set @index = @index + 1
		end
	end

	else if left(@maHD,3) = 'HDN'
	begin
		select @rowCount = count(*) from BAN_CHITIET where MaHDB = @maHD	
		set @index = 1
		while @index <= @rowCount
		begin
			SELECT @soLuongNhap = Sl_nhap, @giaNhap = dongianhap, @khuyenmai = khuyenmai
			from (	SELECT sl_nhap,DonGianhap,SANPHAM.KhuyenMai, ROW_NUMBER() OVER (ORDER BY DAT_chitiet.MaHDN ASC) AS RowNum
					FROM DAT join DAT_chitiet on DAT.MaHDN = DAT_chitiet.MaHDN join SANPHAM on DAT_chitiet.MaHangVin = SANPHAM.MaHangVin
					where dat_chitiet.MaHDN = @maHD
				 )	AS OrderedData
				WHERE OrderedData.RowNum = @index;
			if @khuyenmai <> 0
			begin
				set @tongTien = @tongTien + (@giaBan * @soLuongBan * @khuyenmai) 
			end
			else 
			begin
				set @tongTien = @tongTien + (@giaBan * @soLuongBan) 
			end
			
			set @index = @index + 1
		end
	end
	return @tongTien
end

declare @mahd varchar(20)
set @mahd = 'HDB000000000012'
if left(@maHD,3) = 'HDB'
begin
	select ban_chitiet.mahdb,sanpham.mahangvin,dongiaban, sl_ban, (dongiaban * sl_ban) as thanhtien, khuyenmai, uudai,dbo.getTotalHD(@mahd) as TongTien
	from Ban join BAN_CHITIET on Ban.MaHDB = BAN_CHITIET.MaHDB join SANPHAM on BAN_CHITIET.MaHangVin = SANPHAM.MaHangVin
			join KHACHHANG on KhachHang.maKH = BAN.MaKH
	where BAN_CHITIET.MaHDB = @mahd
end
else if left(@maHD,3) = 'HDN'
begin
	select  dat_chitiet.mahdn,sanpham.mahangvin, dongianhap, sl_nhap,(dongianhap * sl_nhap) as thanhtien, khuyenmai,dbo.getTotalHD(@mahd) as TongTien
	FROM DAT join DAT_chitiet on DAT.MaHDN = DAT_chitiet.MaHDN join SANPHAM on DAT_chitiet.MaHangVin = SANPHAM.MaHangVin
	where dat_CHITIET.MaHDn = @mahd
end

select * from BAN_CHITIET

-- hoa don:HDB000000000005; co 2 san pham: sl1: 122, sl2: 301 ; giaban1: 8821.97, giaban 2: 2375.57, khuyen mai1: 0.84, khuyen mai2: 0.71 --> 1411768.55
select * from BAN_CHITIET join SANPHAM on SANPHAM.MaHangVin = BAN_CHITIET.MaHangVin 
order by MaHDB


-- Tao ma hang vin moi
go
create or alter function getNewIDHangVin ()
returns varchar(15)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(mahangvin) from SANPHAM  --MHV 00001

	select @newID = 'MHV' + right('00000' + cast(right(@oldID, len(@oldId) - 3) + 1 as varchar(15)), 5)

	return @newID
end
select dbo.getNewIDHangVin()

-- Tao ma san pham moi
go
create or alter function getNewIDSanPham ()
returns varchar(15)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(MaSP) from SANPHAM

	select @newID = 'SP' + right('0000000' + cast(right(@oldID, len(@oldId) - 2) + 1 as varchar(15)), 7)

	return @newID
end
select dbo.getNewIDSanPham()

select * from SANPHAM
----------------END HÀM-------------------
/*------------------------------------------------------------------END SẢN PHẨM-------------------------------------------------------------------------------------*/




/*6)------------------------------------------------------------------ĐẶT CHI TIẾT-----------------------------------------------------------------------------*/

-------------------------------------TRIGGER-------------------------------------
--Khi thêm dữ liệu mới có số lượng nhập mới mới thì phải cập nhập lại số lượng sp bằng slsp = slsp + slnhap mới
go
create or alter trigger datchitiet_themsanphamvaohoadon
On dat_chitiet
After insert 
As
begin
	declare @mahoadon char(8),@masanpham char(8),  @soluongnhap int
	select @mahoadon=MaHDN, @masanpham=MaHangVin, @soluongnhap=Sl_Nhap from inserted
	Update SANPHAM
	Set Sl_SP=Sl_SP+@soluongnhap
	where MaHangVin=@masanpham
	If @@ROWCOUNT=0 
		begin
			print N'Thêm thất bại'
			Rollback
		End
	else 
		begin
			print N'Thêm thành công'
		End
End

INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0002', 'MHV00427', 10)
select * from dat_chitiet
-------------------------------------END TRIGGER-------------------------------------
------------------------------THỦ TỤC--------------------------------------
-- khi cập nhật lại số lượng nhập mới, thì slsp cũng phải thay đổi bằng slsp = slsp - slnhap cũ + slnhap mới
go
create or alter proc datchitiet_capnhatsoluongsp(@mahdn char(8), @mahangvin char(8), @soluongnhapmoi int, @ret nvarchar(30)out)
As
begin
	declare @soluongnhapcu int
	If @mahdn not in (select MaHDN from DAT)
		BEGIN 
			print N'Không tồn tại mã hoá đơn'
			Set @ret=N'Cập nhật thất bại'
			Return
		End
	if @mahangvin not in (select MaHangVin from DAT_CHITIET where MaHDN=@mahdn And MaHangVin=@mahangvin)
		BEGIN 
			print N'Không tồn tại sản phẩm trong hoá đơn'
			Set @ret=N'Cập nhật thất bại'
			Return
		End
	select @soluongnhapcu=Sl_Nhap from DAT_CHITIET where MaHDN=@mahdn And MaHangVin=@mahangvin
	Update SANPHAM
	Set Sl_SP=Sl_SP-@soluongnhapcu+@soluongnhapmoi
	where MaHangVin=@mahangvin
	if @@ROWCOUNT=0
		begin 
			Set @ret=N'Cập nhật thất bại'
		End
	else 
		begin
			Set @ret=N'Cập nhật thành công'
		End
End

DECLARE @check NVARCHAR(30),@ma char (8), @sp char(8), @sl int
set @ma='HDN0001'
Set @sp='MHV00000'
Set @sl=5
Exec datchitiet_capnhatsoluongsp @ma,@sp,@sl,@check out
print @check

------------------------------END THỦ TỤC-----------------------------------

/*---------------------------------------------------------------------END ĐẶT CHI TIẾT-----------------------------------------------------------------------------*/




/*7)-----------------------------------------------------------------------KHÁCH HÀNG-----------------------------------------------------------------------------*/
------------------------THỦ TỤC---------------------------
-- Kiem tra du lieu khi insert
go
create or alter proc spChkKH	@loaiKH bit,
								@sdt_kh varchar(15),
								@uuDai decimal(4,2),
								@kq bit out
as
begin
	set @kq = 1;
	--a) Kiem tra them vao neu loai KH = 1 ma sdt la null --> phai co sdt
	if @loaiKH = 1 and @sdt_kh is null
	begin
		print N'Không bỏ trống số điện thoại!'
		set @kq= 0
		return
	end
	--b) Kiem tra neu them vao loai kh = 0 va co sdt --> khong co so dien thoai
	if @loaiKh = 0 and @sdt_kh is not null
	begin
		print N'Số điện thoại không hợp lệ với loại khách hàng!'
		set @kq= 0
		return
	end

	--c) Kiểm tra số diện thoại 
	if exists (select 1 from KHACHHANG where SDT_KH = @sdt_kh)
	begin
		print N'Số điện thoại đã tồn tại!'
		set @kq= 0
		return
	end
	else if len(@sdt_kh) <> 10
	begin 
		print N'Số điện thoại không hợp lệ!'
		set @kq = 0
		return
	end

	--d)kiem tra khi insert uudai < 0
	if @uudai < 0
	begin
		print N'Ưu đãi không hợp lệ!'
		set @kq= 0
		return
	end

	-- Insert vào bảng Khách Hàng
	if @kq = 1
	begin
		insert into khachhang(MaKH,LoaiKH,SDT_KH,UuDai)
		values (dbo.getNewIDKH(),@loaiKH,@sdt_kh,@uuDai)

		if @@rowcount <= 0
		begin
			print 'insert that bai'
			set @kq = 0
			return
		end
	end
end

--test
declare @loaiKH bit,
		@sdt_kh varchar(15),
		@uuDai decimal(4,2),
		@kq bit 
set @loaiKH = 1
set @sdt_kh = '0935699402'
set @uuDai = -1.00

exec spChkKH	@loaiKH,
				@sdt_kh,
				@uuDai,
				@kq out
print @kq
select * from KHACHHANG


-- Cap nhat du lieu cho loai khach hang tu 0 -> 1 hoac tu 1 -> 0 ( 0 -> 1: phai co sdt, 1->0: sdt bi xoa) --> chua lam
go
create or alter proc kh_capnhatkhthanthiet	@maKH char(8),
											@SDT varchar(15),
											@ketqua nvarchar(30) out
as 
begin
	declare @type bit 
	--
	Select @type=LoaiKH 
	From KHACHHANG
	where MaKH=@maKH 
	--
	If @maKH not in (select MaKH from KHACHHANG)
		begin
			print N'Mã KH không tồn tại'
			set @ketqua= N'Cập nhật thất bại'
			Return
		End
	--
	If @type=1 
		begin
			Print N'Thông tin khách hàng đã tồn tại'
			set @ketqua= N'Cập nhật thất bại'
			Return
		End
	else 
		begin 
			if @SDT in (select SDT_KH from KHACHHANG)
				begin
					print N'Số điện thoại đã tồn tại'
					set @ketqua= N'Cập nhật thất bại'
					Return
				end
			else
				begin
					update KHACHHANG
					Set LoaiKH = 1, SDT_KH = @SDT, UuDai = 0.2
					where MaKH=@maKH

					If @@ROWCOUNT =0 
						begin
							set @ketqua =N'Update that bai'
						End
					else 
						begin
							set @ketqua =N'Update thanh cong'
						End
				End
		End
End

declare @maKH char(8), @sdt varchar(15), @kq nvarchar(30) 
set @maKH ='10000006'
set @SDt = '0954098252'
Exec kh_capnhatkhthanthiet @maKH, @SDt, @kq out
Print @kq


--------------------------END THỦ TỤC----------------------------

---------------------------------HÀM---------------------------
-- Tao ma id moi cho bang KHACH HANG
go
create or alter function getNewIDKH ()
returns varchar(15)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(MaKH) from KHACHHANG  

	select @newID = right('000000000000' + @oldID, 8) + 1

	return @newID
end
select dbo.getNewIDKH()

-- Kiem tra
-----------------------------END HÀM------------------------------

/*------------------------------------------------------------------END KHÁCH HÀNG-----------------------------------------------------------------------------*/


/*8)------------------------------------------------------------------------BÁN-----------------------------------------------------------------------------*/
---------------------------------THỦ TỤC-----------------------------------------------
-- Kiem tra du lieu khi insert cho bang BAN
	go
	create or alter proc spChkBan	@ngayban datetime,
									@PTTT Nvarchar(20),
									@manv varchar(20),
									@maKH varchar(20),
									@kq bit out
	as
	begin
		set @kq = 1;
		--a)Kiem tra du lieu cua cot ngay ban ( hop le khi ngay lon hon ngay hien tai)
		if @ngayban > getdate() or (cast(@ngayban as Date) = cast(getdate() as date) and cast(@ngayban as time) > cast(getdate() as time))
		begin
			print N'Thời gian không hợp lệ!'
			set @kq= 0
			return
		end

		--b) Xu ly PTTT: chỉ có tiền mặt, QR, atm
		if @PTTT not in ('QR','ATM','Tiền mặt')
		begin
			print N'PTTT không hợp lệ!'
			set @kq= 0
			return
		end
	
		--c) Kiem tra ma nhan vien
		if not exists (select 1 from NHANVIEN where MaNV = @manv)
		begin
			print N'Mã nhân viên không hợp lệ!'
			set @kq= 0
			return
		end

		--d) Kiem tra ma khach hang
		if not exists (select 1 from KHACHHANG where MaKH = @maKH)
		begin
			print N'Mã khách hàng không hợp lệ!'
			set @kq= 0
			return
		end

		--e) Insert into BAN
		if @kq = 1
		begin
			insert into BAN (MaHDB, NgayBan, PTTT, MaNV, MaKH)
			values (dbo.getNewIDBan(),'2024-10-20 21:32:00','QR','20000001','10000002')

			if @@rowcount <= 0
			begin
				print 'insert that bai'
				set @kq = 0
				return
			end
		end
	end

	--test
	declare @ngayban datetime,
			@PTTT Nvarchar(20),
			@manv varchar(20),
			@maKH varchar(20),
			@kq bit
	set @ngayban = '2024-10-18'
	set @PTTT = 'Tiền mặt'
	set @manv = '20000009'
	set @maKH = '10001003'

	exec spChkBan	@ngayban,
					@PTTT,
					@manv ,
					@maKH,
					@kq out
	print @kq

	select * from BAN
	select * from KHACHHANG
	select * from nhanvien

----- Cho phép xóa dữ liệu của hóa đơn ban khi không có trong bảng ban chi tiết
go
create or alter proc tDeleteHDB @mahdB varchar(20), @thongbao nvarchar(100) out
as
begin
	declare @soLuongMaHDB int

	set @soLuongMaHDB = (select count(*) 
						from BAN_CHITIET
						where BAN_CHITIET.MaHDB = @mahdB)

	if @soLuongMaHDB > 0
	begin
		set @thongbao = N'Đơn bán hàng đã được nhập trong chi tiết' + N'. Không thể xóa đơn hàng!'
		return
	end
	else
	begin
		delete BAN
		where MaHDB = @mahdB
	end 
end

declare	 @mahdB varchar(20), @thongbao nvarchar(100)
set @mahdB = 'HDB000000000001'
exec tDeleteHDB  @mahdB , @thongbao out 
print @thongbao

select * from BAN_CHITIET

------------------------------------END THỦ TỤC---------------------------------

--------------------------------------------------------HÀM----------------------------------------------------------
-- TINH RA MA HDB BAN MOI
go
create or alter function getNewIDBan ()
returns varchar(15)
as
begin
	declare @newID varchar(15), @oldID varchar(15)

	select @oldID = max(MaHDB) from BAN  --MHV 00001

	select @newID = 'HDB' + right('000000000000' + cast(right(@oldID, len(@oldId) - 3) + 1 as varchar(15)), 12)

	return @newID
end
select dbo.getNewIDBan()
-----------------------------------------------------END HÀM-------------------------------------------------------

/*------------------------------------------------------------------END BÁN-----------------------------------------------------------------------------*/



/*9)------------------------------------------------------------------BÁN CHI TIẾT-----------------------------------------------------------------------------*/
---------------------------------THỦ TỤC----------------------------------------------
go
create or alter proc spChekBanChiTiet	@mahdb varchar(20),
										@mahangvin varchar(20),
										@sl_ban int,
										@kq bit out
as
begin
	declare @sl_sp int
	set @kq = 1
	-- Kiem tra ma hoa don
	if not exists (select 1 from Ban where MaHDB = @mahdb)
	begin
		print N'Mã hóa đơn không hợp lệ!'
		set @kq= 0
		return
	end
	
	-- Kiem tra ma hang vin
	if not exists (select 1 from SANPHAM where MaHangVin = @mahangvin)
	begin
		print N'Mã sản phẩm không hợp lệ!'
		set @kq= 0
		return
	end

	-- Kiem tra so luong ban
	select @sl_sp = sl_sp from SANPHAM where MaHangVin = @mahangvin
	
	if @sl_ban > @sl_sp
	begin
		print N'Số lượng bán lớn hơn số lượng sản phẩm đang có!'
		set @kq= 0
		return
	end

	--insert into
	if @kq = 1
	begin
		insert into BAN_CHITIET (MaHDB, MaHangVin,SL_Ban)
		values (@mahdb, @mahangvin, @sl_ban) 

		if @@rowcount <= 0
		begin
			print 'insert that bai'
			set @kq = 0
			return
		end
	end
end
 
declare @mahdb varchar(20),
		@mahangvin varchar(20),
		@sl_ban int,
		@kq bit 
set @mahdb = 'HDB000000000016'
set @mahangvin = 'MHV00286' --> slsp = 127
set @sl_ban = '100'
exec spChekBanChiTiet	@mahdb,
						@mahangvin,
						@sl_ban,
						@kq out
print @kq

select * from BAN join BAN_CHITIET on ban.MaHDB = BAN_CHITIET.MaHDB
				join SANPHAM on SANPHAM.MaHangVin = BAN_CHITIET.MaHangVin

-------------------------END THỦ TỤC----------------------------------------------

-- Cap nhat so luong ban ( thong bao loix khi so luong ban > sl sp)
------------------------------TRIGGER-------------------------------
go
create or alter trigger tCheckSLBanSLSp
on ban_chitiet
for UPDATE
as
begin
	declare @mahangvin char(15), @slsp int, @slban int
	-- SU KIEN INSERT
	select @slban = sl_ban,@mahangvin = mahangvin from inserted
	select @slsp = sl_sp from SANPHAM where Mahangvin = @mahangvin

	if @slban > @slsp
	begin
		print N'Số lượng bán lớn hơn số lượng sản phẩm đang có'
		rollback
	end
end

UPDATE BAN_CHITIET
SET SL_Ban = 1000
WHERE MaHangVin = '00000005' --> OK , TH FAILED
UPDATE BAN_CHITIET
SET SL_Ban = 930
WHERE MaHangVin = 'MHV00001' --> OK, TH PASS -> SL_SP = 958


select * from SANPHAM join BAN_CHITIET ON SANPHAM.MaHangVin = BAN_CHITIET.MaHangVin
WHERE SANPHAM.MaHangVin = 'MHV00001'
SELECT * FROM BAN_CHITIET
----------------------------------END TRIGGER-------------------------------------

/*------------------------------------------------------------------END BÁN CHI TIẾT-----------------------------------------------------------------------------*/




/*Tìm ra tất cả mã san phẩm (mã hàng vin), tên sản phẩm, đơn giá bán, hạn sử dụng và số lượng
sản phẩm khi biết mã hóa đơn bán*/
go
create or alter function fGetListSpHDB(@mahdb varchar(20))
returns @ListSP table (	mahangvin varchar(15),
						tenSP nvarchar(50),
						DongiaBan decimal(10,2),
						HSD date,
						Sl_SP int)
as
begin
	insert into @ListSP
	select sanpham.mahangvin, tenSP, dongiaban, HanSuDung, sl_sp
	from sanpham join BAN_CHITIET on sanpham.mahangvin = BAN_CHITIET.MaHangVin
				join ban on ban_chitiet.mahdb = ban.mahdb
	where ban.mahdb = @mahdb

	return 
end
select * from dbo.fGetListSpHDB('HDB000000000007')

select * from sanpham join BAN_CHITIET on sanpham.mahangvin = BAN_CHITIET.MaHangVin
				join ban on ban_chitiet.mahdb = ban.mahdb

				-- mahoadon: HDB000000000007, co 3 ma hang vin MHV00007,MHV00608,MHV00784

/*Tìm ra tất cả mã sản phẩm (mã hàng vin), tên sản phẩm, đơn giá bán, hạn sử dụng và số lượng
sản phẩm khi biết mã hóa đơn nhập*/
go
create or alter function fGetListSpHDN(@mahdn varchar(20))
returns @ListSP table (	mahangvin varchar(15),
						tenSP nvarchar(50),
						DongiaNhap decimal(10,2),
						HSD date,
						Sl_SP int)
as
begin
	insert into @ListSP
	select sanpham.mahangvin, tenSP, dongiaban, HanSuDung, sl_sp
	from sanpham join dat_CHITIET on sanpham.mahangvin = dat_CHITIET.MaHangVin
				join dat on dat_chitiet.mahdn = dat.mahdn
	where dat.mahdn = @mahdn

	return 
end
select * from dbo.fGetListSpHDN('HDN0002')
/*-------------------------------------------------------------END MODULE-----------------------------------------------------------------------------*/