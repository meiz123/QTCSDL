-----------------------------------------------------------TẠO DATABASE---------------------------------------------------------------------
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







--thêm cột mã hoá SDT bảng NHACUNGCAP
alter table nhacungcap
Add encryptedSDT_NCC varbinary(max)
--thêm cột mã hoá SDT bảng DONVIVANCHUYEN
Alter table DONVIVANCHUYEN
Add encryptedSDT_NVC varbinary(max)
--thêm cột mã hoá SDT bảng KHACHHANG
Alter table KHACHHANG
Add encryptedSDT_KH varbinary(max)
--thêm cột mã hoá SDT bảng NHANVIEN
Alter table NHANVIEN
Add encryptedSDT_NV varbinary(max)

--tạo master key 
Create master key encryption by password ='Ma$terK&yG4'

--tạo chứng chỉ 
create CERTIFICATE Certificate_test with subject = 'Protect my data'

--tạo khoá đối xứng 
Create symmetric key SDTProtector
with algorithm =aes_256
ENCRYPTION BY CERTIFICATE Certificate_test

--mở khoá 
OPEN SYMMETRIC KEY SDTProtector
DECRYPTION BY CERTIFICATE Certificate_test

--mã hoá 
Update NHACUNGCAP
Set encryptedSDT_NCC=ENCRYPTBYKEY(key_guid('SDTProtector'),cast(sdt_ncc as nvarchar))
Update DONVIVANCHUYEN
Set encryptedSDT_NVC=ENCRYPTBYKEY(key_guid('SDTProtector'),cast(sdt_nvc as nvarchar))
Update KHACHHANG
Set encryptedSDT_KH=ENCRYPTBYKEY(key_guid('SDTProtector'),cast(sdt_kh as nvarchar))
Update NHANVIEN
Set encryptedSDT_NV=ENCRYPTBYKEY(key_guid('SDTProtector'),cast(sdt_nv as nvarchar))

select * from NHACUNGCAP
--Xoá cột SDT_NCC
ALTER TABLE NHACUNGCAP DROP CONSTRAINT UQ__NHACUNGC__0134269A577BA900
alter table NHACUNGCAP drop column sdt_ncc 
--Xoá cột SDT_NVC
alter table DONVIVANCHUYEN DROP CONSTRAINT UQ__DONVIVAN__01377556262E1659
alter table DONVIVANCHUYEN drop column sdt_nvc 
--Xoá cột SDT_KH
alter table KHACHHANG drop column sdt_kh 
--Xoá cột SDT_NV
alter table NHANVIEN DROP CONSTRAINT UQ__NHANVIEN__DE7B0991D44051C8
alter table NHANVIEN drop column sdt_nv

select * from nhacungcap
--mở khoá đối xứng 
OPEN SYMMETRIC KEY SDTProtector
DECRYPTION BY CERTIFICATE Certificate_test
--giải mã hoá 
--Cột SDT_NCC bảng NHACUNGCAP
select	MaNCC,
		TenNCC,
		diachincc,
		encryptedSDT_NCC,
		dencryptedSDT_NCC=cast(cast(DECRYPTBYKEY(encryptedSDT_NCC) as nvarchar)as varchar(15))
from NHACUNGCAP
--Cột SDT_NCC bảng DONVIVANCHUYEN
select	MaDVVC,
		TenNVC,
		NgayGiaoHang,
		encryptedSDT_NVC,
		dencryptedSDT_NVC=cast(cast(DECRYPTBYKEY(encryptedSDT_NVC) as nvarchar)as varchar(15))
from DONVIVANCHUYEN
--Cột SDT_NCC bảng KHACHHANG
select	MaKH,
		LoaiKH,
		UuDai,
		encryptedSDT_KH,
		dencryptedSDT_KH=cast(cast(DECRYPTBYKEY(encryptedSDT_KH) as nvarchar)as varchar(15))
from KHACHHANG
--Cột SDT_NV bảng NHANVIEN
select	MaNV,
		TenNV,
		encryptedSDT_NV,
		dencryptedSDT_NV=cast(cast(DECRYPTBYKEY(encryptedSDT_NV) as nvarchar)as varchar(15))
from NHANVIEN
Select * from NHANVIEN
--đóng khoá đối xứng 
CLOSE SYMMETRIC KEY SDTProtector

----------------------------------------------Tạo khoá---------------------------------
Create or alter proc sp_taokhoa
As 
Begin 
	--tạo master key 
	Create master key encryption by password ='Ma$terK&yG4'

	--tạo chứng chỉ 
	create CERTIFICATE Certificate_test with subject = 'Protect my data'

	--tạo khoá đối xứng 
	Create symmetric key SDTProtector
	with algorithm =aes_256
	ENCRYPTION BY CERTIFICATE Certificate_test
End
exec sp_taokhoa
---------------------------------------------MÃ HOÁ--------------------------------------------------------
Go

--thêm cột mã hoá SDT bảng NHACUNGCAP
alter table nhacungcap
Add encryptedSDT_NCC varbinary(max)
--thêm cột mã hoá SDT bảng DONVIVANCHUYEN
Alter table DONVIVANCHUYEN
Add encryptedSDT_NVC varbinary(max)
--thêm cột mã hoá SDT bảng KHACHHANG
Alter table KHACHHANG
Add encryptedSDT_KH varbinary(max)
--thêm cột mã hoá SDT bảng NHANVIEN
Alter table NHANVIEN
Add encryptedSDT_NV varbinary(max)
------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_mahoa
AS
BEGIN
    -- Mở khoá
    OPEN SYMMETRIC KEY SDTProtector
    DECRYPTION BY CERTIFICATE Certificate_test

    -- Mã hoá
    UPDATE NHACUNGCAP
    SET encryptedSDT_NCC = ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(sdt_ncc AS NVARCHAR))
    UPDATE DONVIVANCHUYEN
    SET encryptedSDT_NVC = ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(sdt_nvc AS NVARCHAR))
    UPDATE KHACHHANG
    SET encryptedSDT_KH = ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(sdt_kh AS NVARCHAR))
    UPDATE NHANVIEN
    SET encryptedSDT_NV = ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(sdt_nv AS NVARCHAR))

    -- Xoá cột SDT_NCC
    DECLARE @uqncc VARCHAR(100)
    SELECT @uqncc = name
    FROM sys.objects
    WHERE type = 'UQ' AND OBJECT_NAME(parent_object_id) = N'NHACUNGCAP'

    -- Thực thi câu lệnh động để xóa ràng buộc và cột
    EXEC('ALTER TABLE dbo.NHACUNGCAP DROP CONSTRAINT ' + @uqncc)
    EXEC('ALTER TABLE dbo.NHACUNGCAP DROP COLUMN sdt_ncc')

    -- Xoá cột SDT_NVC
    DECLARE @uqnvc VARCHAR(100)
    SELECT @uqnvc = name
    FROM sys.objects
    WHERE type = 'UQ' AND OBJECT_NAME(parent_object_id) = N'DONVIVANCHUYEN'

    -- Thực thi câu lệnh động để xóa ràng buộc và cột
    EXEC('ALTER TABLE dbo.DONVIVANCHUYEN DROP CONSTRAINT ' + @uqnvc)
    EXEC('ALTER TABLE dbo.DONVIVANCHUYEN DROP COLUMN sdt_nvc')

    -- Xoá cột SDT_KH
    DECLARE @uqkh VARCHAR(100)
    SELECT @uqkh = name
    FROM sys.objects
    WHERE type = 'UQ' AND OBJECT_NAME(parent_object_id) = N'KHACHHANG'

    -- Thực thi câu lệnh động để xóa ràng buộc và cột
    EXEC('ALTER TABLE dbo.KHACHHANG DROP CONSTRAINT ' + @uqkh)
    EXEC('ALTER TABLE dbo.KHACHHANG DROP COLUMN sdt_kh')

    -- Xoá cột SDT_NV
    DECLARE @uqnv VARCHAR(100)
    SELECT @uqnv = name
    FROM sys.objects
    WHERE type = 'UQ' AND OBJECT_NAME(parent_object_id) = N'NHANVIEN'

    -- Thực thi câu lệnh động để xóa ràng buộc và cột
    EXEC('ALTER TABLE dbo.NHANVIEN DROP CONSTRAINT ' + @uqnv)
    EXEC('ALTER TABLE dbo.NHANVIEN DROP COLUMN sdt_nv')

    -- Đóng khoá
    CLOSE SYMMETRIC KEY SDTProtector
END

Exec sp_mahoa
select * from KHACHHANG

------------------------------------------------GIẢI MÃ-----------------------------------
---------------------------------KHACHHANG-----------------------------------------------
go
create or alter proc sp_giaimabangNCC
As
Begin 
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
	
	select	MaNCC,
		TenNCC,
		Diachincc,
		dencryptedSDT_NCC=cast(cast(DECRYPTBYKEY(encryptedSDT_NCC) as nvarchar)as varchar(15))
	from NHACUNGCAP
	CLOSE SYMMETRIC KEY SDTProtector
End
exec sp_giaimabangNCC
Go
--------------------DONVIVANCHUYEN---------------------------------------------
create or alter proc sp_giaimabangDVVC
As
Begin 
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
	--Cột SDT_NCC bảng DONVIVANCHUYEN
	select	MaDVVC,
			TenNVC,
			NgayGiaoHang,
			dencryptedSDT_NVC=cast(cast(DECRYPTBYKEY(encryptedSDT_NVC) as nvarchar)as varchar(15))
	from DONVIVANCHUYEN
	CLOSE SYMMETRIC KEY SDTProtector
end
exec sp_giaimabangDVVC
Go
-----------------------------KHACHHANG---------------------------------------------
create or alter proc sp_giaimabangKH
As
Begin 
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
	--Cột SDT_NCC bảng KHACHHANG
	select	MaKH,
			LoaiKH,
			UuDai,
			dencryptedSDT_KH=cast(cast(DECRYPTBYKEY(encryptedSDT_KH) as nvarchar)as varchar(15))
	from KHACHHANG
	CLOSE SYMMETRIC KEY SDTProtector
end
exec sp_giaimabangKH
----------------------------NHANVIEN-----------------------------------------------
create or alter proc sp_giaimabangNV
As
Begin 
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
	--Cột SDT_NV bảng NHANVIEN
	select	MaNV,
			TenNV,
			encryptedSDT_NV,
			dencryptedSDT_NV=cast(cast(DECRYPTBYKEY(encryptedSDT_NV) as nvarchar)as varchar(15))
	from NHANVIEN
	CLOSE SYMMETRIC KEY SDTProtector
end
Exec sp_giaimabangNV
-------------------------------------------INSERT--------------------------------------
---------------------------------------------KHACHHANG----------------------------------------------------------

Go
create or alter proc sp_themkh	@loaikh bit,
								@sdt_kh varchar(15),
								@Uudai decimal(4,2)
As
Begin
	declare @makh varchar(50)
	set @makh=(select dbo.getNewIDKH())
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test

	INSERT INTO KHACHHANG (MaKH,LoaiKH,UuDai,encryptedSDT_KH)
    VALUES (@makh, @loaikh,@Uudai,ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(@sdt_kh AS NVARCHAR)))

	CLOSE SYMMETRIC KEY SDTProtector
End
declare @loai bit,
		@sdt varchar(15),
		@ud decimal(4,2)

set	@loai=1
set	@sdt ='0367674438'
set	@ud =0.1

exec sp_themkh @loai,@sdt,@ud 
Select * from KHACHHANG
where MaKH=10001001
-------------------------------------------------NCC------------------------------------------------
Go
create or alter proc sp_themncc	@tenncc nvarchar(100),
								@diachincc nvarchar(50),
								@SDT_NCC varchar(15)
As
Begin
	declare @mancc varchar(50)
	set @mancc=(select dbo.fGetNewIDNCC())
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test

	INSERT INTO NHACUNGCAP (MaNCC,TenNCC,DiaChiNCC,encryptedSDT_NCC)
    VALUES (@mancc, @tenncc,@diachincc,ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(@sdt_ncc AS NVARCHAR)))

	CLOSE SYMMETRIC KEY SDTProtector
End

DECLARE @ten NVARCHAR(100), 
		@diachi NVARCHAR(50),
		@SDT VARCHAR(15)

set	@ten = N'Công ty TNHH A'
set	@diachi =N'Hà Nội'
set	@SDT ='0987654321'

EXEC sp_themncc @ten, @diachi, @SDT
Select * from NHACUNGCAP
where MaNCC=00001001
---------------------------------------------------------DONVIVANCHUYEN----------------------------------------------------------------
Go
create or alter proc sp_themdvvc	@tennvc nvarchar(100),
									@ngaygiaohang datetime,
									@SDT_NVC varchar(15)
As
Begin
	declare @manvc char(7)
	set @manvc=(select dbo.fGetNewIDDVVC())
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test

	INSERT INTO DONVIVANCHUYEN(MaDVVC,TenNVC,NgayGiaoHang,encryptedSDT_NVC)
    VALUES (@manvc, @tennvc,@ngaygiaohang,ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(@sdt_nvc AS NVARCHAR)))

	CLOSE SYMMETRIC KEY SDTProtector
End

DECLARE @ten NVARCHAR(100), 
		@ngaygiao datetime,
		@SDT VARCHAR(15)

set	@ten = N'Công ty van chuyen A'
set	@ngaygiao=GETDATE()-1
set	@SDT ='0312345678'

EXEC sp_themdvvc @ten, @ngaygiao, @SDT
Select * from DONVIVANCHUYEN
where MaDVVC=0001001

------------------------------------------------------NHANVIEN--------------------------------------------------------
Go
create or alter proc sp_themnv	@tennv nvarchar(100),
								@SDT_NV varchar(15)
As
Begin
	declare @manv char(8)
	set @manv=(select dbo.fGetNewIDNV())
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test

	INSERT INTO NHANVIEN(MaNV,TenNV,encryptedSDT_NV)
    VALUES (@manv, @tennv,ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(@sdt_nv AS NVARCHAR)))

	CLOSE SYMMETRIC KEY SDTProtector
End

DECLARE @ten NVARCHAR(100), 
		@SDT VARCHAR(15)
set	@ten = N'Nhan vien A'
set	@SDT =0387654321

EXEC sp_themnv @ten, @SDT
Select * from NHANVIEN
where MaNV=20001001

----------------------------------------------------------UPDATE-----------------------------------------
-----------------------------------------KHACH HANG-----------------------------------------------------
Go
CREATE OR ALTER PROCEDURE sp_updateKH	@makh VARCHAR(50),
										@loaikh BIT,
										@sdt_kh VARCHAR(15),
										@Uudai DECIMAL(4, 2)
AS
BEGIN
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
    UPDATE KHACHHANG
    SET LoaiKH = @loaikh,
        UuDai = @Uudai,
        encryptedSDT_KH = ENCRYPTBYKEY(key_guid('SDTProtector'), CAST(@sdt_kh AS NVARCHAR))
    WHERE MaKH = @makh
	CLOSE SYMMETRIC KEY SDTProtector
END

EXEC sp_updateKH '10001000', 1, '0987654321', 0.2
Select * from KHACHHANG

------------------------------------------------READ--------------------------------------------------------
Create or alter proc sp_read_KH @makh char(8)
As
Begin
	OPEN SYMMETRIC KEY SDTProtector
	DECRYPTION BY CERTIFICATE Certificate_test
 
    SELECT MaKH,LoaiKH,UuDai,cast(cast(DECRYPTBYKEY(encryptedSDT_KH) as nvarchar)as varchar(15)) as SDT_KH
    FROM KHACHHANG
    WHERE MaKH = @makh
	CLOSE SYMMETRIC KEY SDTProtector
End
Exec sp_read_KH '10001002'