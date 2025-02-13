--bảng NCC
CREATE or alter PROCEDURE InsertData_NHACUNGCAP
AS
BEGIN
    DECLARE @i INT = 1

    WHILE @i <= 1000
    BEGIN
        INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChiNCC, SDT_NCC)
        VALUES (
            RIGHT('00000000' + CAST(@i AS VARCHAR(8)), 8),
            'Nha cung cap ' + CAST(@i AS NVARCHAR(10)),
            'Dia chi cua nha cung cap ' + CAST(@i AS NVARCHAR(10)),
            (CASE FLOOR(RAND() * 3)
                WHEN 0 THEN '09'
                WHEN 1 THEN '01'
                WHEN 2 THEN '07'
				Else '03'
            END) + RIGHT('00000000' + cast (CAST(FLOOR(RAND() * 100000000)as int) AS VARCHAR(8)), 8)
        );

        SET @i = @i + 1
    END
END
exec InsertData_NHACUNGCAP 
select * from NHACUNGCAP 

-----------------------------------------------------------------DVVC----------------------------------------------------

CREATE or alter PROCEDURE InsertData_DONVIVANCHUYEN
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        INSERT INTO DONVIVANCHUYEN (MaDVVC, TenNVC, NgayGiaoHang, SDT_NVC)
        VALUES (
            RIGHT('0000000' + CAST(@i AS VARCHAR(7)), 7),
            'Don vi van chuyen ' + CAST(@i AS NVARCHAR(10)),
            DATEADD(DAY, -FLOOR(RAND() * 1825), GETDATE()),
            (CASE FLOOR(RAND() * 3)
                WHEN 0 THEN '09'
                WHEN 1 THEN '01'
                WHEN 2 THEN '07'
				Else '03'
            END) + RIGHT('00000000' + cast (CAST(FLOOR(RAND() * 100000000)as int) AS VARCHAR(8)), 8)
        );

        SET @i = @i + 1;
    END
END;
exec InsertData_DONVIVANCHUYEN
Select * from DONVIVANCHUYEN

-----------------------------------------------------NHAN VIEN-------------------------------------------------------------
CREATE or alter PROCEDURE InsertData_NHANVIEN
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        INSERT INTO NHANVIEN (MaNV, TenNV, SDT_NV)
        VALUES (
             '2'+ RIGHT('000000' + CAST(@i AS VARCHAR(6)), 6),
            'Nhan vien ' + CAST(@i AS NVARCHAR(10)),
            (CASE FLOOR(RAND() * 3)
                WHEN 0 THEN '09'
                WHEN 1 THEN '01'
                WHEN 2 THEN '07'
				Else '03'
            END) + RIGHT('00000000' + cast (CAST(FLOOR(RAND() * 100000000)as int) AS VARCHAR(8)), 8)
        );

        SET @i = @i + 1;
    END
END;
exec InsertData_NHANVIEN
select * from NHANVIEN


-----------------------------------------------------DAT-----------------------------------------------------------
CREATE or ALTER PROCEDURE InsertData_DAT
AS
BEGIN
    DECLARE @i INT = 1,
			@MaNCC CHAR(8),
			@MaNV CHAR(8),
			@MaDVVC CHAR(7),
			@GhiChu NVARCHAR(30),
			@NgayDat DATETIME =  DATEADD(DAY, -FLOOR(RAND() * 1825), GETDATE())

    WHILE @i <= 1000
    BEGIN
        -- Chọn ngẫu nhiên MaNCC từ bảng NHACUNGCAP
        SELECT TOP 1 @MaNCC = MaNCC FROM NHACUNGCAP ORDER BY NEWID();

        -- Chọn ngẫu nhiên MaNV từ bảng NHANVIEN
        SELECT TOP 1 @MaNV = MaNV FROM NHANVIEN ORDER BY NEWID();

        -- Chọn ngẫu nhiên MaDVVC từ bảng DONVIVANCHUYEN
        SELECT TOP 1 @MaDVVC = MaDVVC FROM DONVIVANCHUYEN ORDER BY NEWID();

        -- Tạo ghi chú ngẫu nhiên: 'Khuyến mãi' hoặc NULL
        IF RAND() < 0.5
        BEGIN
            SET @GhiChu = N'Khuyến mãi'; -- 50% cơ hội ghi chú là 'Khuyến mãi'
        END
        ELSE
        BEGIN
            SET @GhiChu = NULL; -- 50% cơ hội ghi chú là NULL
        END

        -- Chèn dữ liệu vào bảng DAT, bao gồm cả MaDVVC
        INSERT INTO DAT (MaHDN, NgayDat, GhiChu, MaNCC, MaNV, MaDVVC)
        VALUES (
            'HDN'+RIGHT('000' + CAST(@i AS VARCHAR(4)), 4), -- MaHDN
            @NgayDat, -- Ngày đặt
            @GhiChu,  -- Ghi chú
            @MaNCC,   -- Mã nhà cung cấp
            @MaNV,    -- Mã nhân viên
            @MaDVVC   -- Mã đơn vị vận chuyển
        );

        SET @i = @i + 1;
    END
END;

EXEC InsertData_DAT;
select * from DAT

---------------------------------------------SAN PHAM------------------------------------------------------
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
        WHILE EXISTS (SELECT 1 FROM SANPHAM WHERE MaHangVin = @MaHangVin)
        BEGIN
            SET @i = @i + 1
            SET @MaHangVin = 'MHV' + RIGHT('00000' + CAST(@i AS VARCHAR(8)), 5)
        END

        SET @MaSP = 'SP' + RIGHT('00000000' + CAST(@i AS VARCHAR(7)), 7)

        SET @TenSP = 'San pham ' + CAST(@i AS NVARCHAR(50))

        SET @DVT = CASE FLOOR(RAND() * 4)
            WHEN 0 THEN N'Cái'
            WHEN 1 THEN N'Hộp'
            WHEN 2 THEN N'Chai'
            WHEN 3 THEN N'Túi'
            ELSE N'Thùng'  
        END

        SET @DonGiaNhap = CAST(100000 * RAND() AS DECIMAL(10, 2))
        SET @DonGiaBan = @DonGiaNhap + CAST(10000 + (RAND() * 100000) AS DECIMAL(10, 2))
        SET @KhuyenMai = CAST(FLOOR(RAND() * 100) AS DECIMAL(4,2))
        SET @HanSuDung = DATEADD(DAY, FLOOR(RAND() * 730), GETDATE())
        SET @SL_SP = FLOOR(RAND() * 1000)

        INSERT INTO SANPHAM (MaHangVin, MaSP, TenSP, DVT, DonGiaNhap, DonGiaBan, KhuyenMai, HanSuDung, Sl_SP)
        VALUES (@MaHangVin, @MaSP, @TenSP, @DVT, @DonGiaNhap, @DonGiaBan, @KhuyenMai, @HanSuDung, @SL_SP)
        SET @i = @i + 1
    END
END

EXEC InsertData_SANPHAM
Select * from SANPHAM



-------------------------------------------------DAT CHI TIET-----------------------------------------------------------
CREATE OR ALTER PROCEDURE InsertData_DAT_CHITIET
AS
BEGIN
    DECLARE @i INT = 1,@MaHDN CHAR(7),@MaHangVin CHAR(8),@SL_Nhap INT

    WHILE @i <= 1500
    BEGIN
        SELECT TOP 1 @MaHDN = MaHDN FROM DAT ORDER BY NEWID();
        SELECT TOP 1 @MaHangVin = MaHangVin FROM SANPHAM ORDER BY NEWID();
        SET @SL_Nhap = FLOOR(RAND() * 10000) + 1;
		INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, SL_Nhap)
        VALUES (@MaHDN, @MaHangVin, @SL_Nhap)
        SET @i = @i + 1;
    END
END
EXEC InsertData_DAT_CHITIET
Select * from DAT_CHITIET

-----------------------------------------------------------------------------------------------------------------------
create or alter proc spInsert50BAN
as
begin
	DECLARE @maHDB CHAR(15), @ngayban datetime, @pttt varchar(20), @manv char(8), @maKH char(8)
    DECLARE @i INT = 1

    WHILE @i <= 50
    BEGIN
        -- Tạo giá trị MaHDB char(15)
        SET @Mahdb = 'HDB' + RIGHT ('000000000000' + CAST(@i AS VARCHAR(15)), 12);
        
		DECLARE @StartDate DATETIME = '2020-01-01 00:00:00';  -- Ngày bắt đầu
		DECLARE @EndDate DATETIME = GETDATE();  -- Ngày kết thúc (ngày hiện tại)
		-- Tạo giá trị datetime ngayban ngẫu nhiên
        SET @ngayban = DATEADD(SECOND, 
               FLOOR(RAND() * DATEDIFF(SECOND, @StartDate, @EndDate)), 
               @StartDate)
        
        -- Tạo pttt
        SET @pttt =	CASE		--Rand() nó sẽ cho ra kiểu dữ liệu là float
						WHEN floor(RAND(CHECKSUM(newid())) * 2) = 0 THEN 'Tien mat'
						WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN 'QR'
						else 'ATM'
					END

		-- Tạo giá trị maNV
        SELECT TOP 1 @manv = MaNV
		FROM nhanvien
		ORDER BY NEWID(); 

		-- Tạo giá trị MakH
        SELECT TOP 1 @maKh  = MaKH
		FROM KHACHHANG
		ORDER BY NEWID();


		--kiểm tra mã KH có trùng hay không 
		IF NOT EXISTS (SELECT 1 FROM BAN WHERE MaHDB = @mahdb)
        BEGIN
			INSERT INTO BAN(maHDB, ngayban, pttt , manv , maKH )
            VALUES (@maHDB , @ngayban , @pttt , @manv , @maKH );
        END
		-- kiểm tra số diện thoại có bị trùng hay không
		else
		begin
			PRINT 'Mã HDB ' + @mahdb + ' đã tồn tại . Không thể chèn.';
			return
		end

        -- Tăng giá trị đếm
        SET @i = @i + 1;
    END;
end
exec spInsert50BAN
select * from BAN

----------------------------------------------KHÁCH HÀNG--------------------------------------------------------------------
CREATE OR ALTER PROCEDURE spInsert50KH
AS
BEGIN
    DECLARE @makh CHAR(8, @loaiKH bit, @sdtkh VARCHAR(15), @uudai decimal(4,2);
    DECLARE @i INT = 1, @kq int, @ret int


    WHILE @i <= 50
    BEGIN
        -- Tạo giá trị MaKH
        SET @Makh = '1' +RIGHT('0000000' + CAST(@i AS VARCHAR(8)), 7);
        
        -- Tạo loai khach hang
        SET @loaiKH = CASE  WHEN RAND() <= 0.5 THEN 1 
							ELSE 0                     
						END;
        
        -- Tạo số điện thoại ngẫu nhiên
        if @loaiKH = 0 
			begin
				set @sdtkh = null
				set @uudai=0
			End
		else if @loaiKH=1
			begin
				set @sdtkh=(CASE FLOOR(RAND() * 3)
								WHEN 0 THEN '09'
								WHEN 1 THEN '01'
								WHEN 2 THEN '07'
								Else '03'
							END) + RIGHT('00000000' + cast (CAST(FLOOR(RAND() * 100000000)as int) AS VARCHAR(8)), 8)
				 SET @uudai = CAST(FLOOR(RAND() * 100) AS DECIMAL(4,2));
			End
        SET @i = @i + 1;
    END;
END;
exec spInsert50KH
select * from khachhang

--------------------------------------------BÁN CHI TIẾT----------------------------------------------------------------------------
create or alter proc spInsert50BanChiTiet
as
begin
	DECLARE @maHDB CHAR(15), @MaHangVin char(😎, @sLBan int
	declare @i int = 1

	while @i <= 50
	begin
		-- Tạo giá trị maHDB
        SELECT TOP 1 @maHDB = MaHDB
		FROM BAN
		ORDER BY NEWID(); 

		-- Tạo giá trị MaHangVin
        SELECT TOP 1 @MaHangVin  = MaHangVin
		FROM SANPHAM
		ORDER BY NEWID();

		-- Tao gia tri cho so luong ban
		select @sLBan = FLOOR(RAND() * 10000);

		IF NOT EXISTS (SELECT 1 FROM BAN_CHITIET WHERE MaHangVin = @MaHangVin)
        BEGIN
			INSERT INTO BAN_CHITIET(maHDB, MaHangVin, sL_Ban )
            VALUES (@maHDB, @MaHangVin, @sLBan);
        END
		else
		begin
			PRINT 'Mã hang vin ' + @mahangvin + ' đã tồn tại . Không thể chèn.';
			return
		end
		set @i = @i  + 1
	end
end
exec spInsert50BanChiTiet
select * from BAN_CHITIET


----------------------------------------------------------MODULE XỬ LÝ------------------------------------------
/*1. trigger kiểm tra thời gian giao hàng hợp lệ của bảng DVVC. 
Thời gian hợp lệ là  thời gian giao hàng không lớn hơn thời gian hiện tại 
*/
Select * from DONVIVANCHUYEN
create or alter trigger dvvc_kiemtra_tggiaohang
on Donvivanchuyen
For insert 
As 
	declare @ngaygh datetime
begin
	select @ngaygh=NgayGiaoHang from inserted
	if @ngaygh>getdate()
	begin 
		print N'Ngày giao hàng không hợp lệ'
		rollback
	end
end
delete DONVIVANCHUYEN where MaDVVC='DVVC003'
Select * from DONVIVANCHUYEN
INSERT INTO DONVIVANCHUYEN (MaDVVC, TenNVC, NgayGiaoHang, SDT_NVC)
VALUES ('DVVC003', 'Đơn vị vận chuyển B', GETDATE() +2, '0909765432')

---
CREATE OR ALTER PROCEDURE dvvc_kiemtra_tggiaohang	(@MaDVVC NVARCHAR(10),
													@TenNVC NVARCHAR(100),
													@NgayGiaoHang DATETIME,
													@SDT_NVC NVARCHAR(15),
													@ketqua nvarchar(30)out) 
AS
BEGIN
    IF @NgayGiaoHang > GETDATE()
		BEGIN
			set @ketqua = N'Ngày giao hàng không hợp lệ'
			RETURN
		END
    else 
		Begin 
			INSERT INTO DONVIVANCHUYEN (MaDVVC, TenNVC, NgayGiaoHang, SDT_NVC)
			VALUES (@MaDVVC, @TenNVC, @NgayGiaoHang, @SDT_NVC)
			if @@rowcount <= 0
				begin
					set @ketqua = N'Dữ liệu chèn thất bại'
					return
				end
			else 
				begin
					set @ketqua = N'Dữ liệu chèn thành công'
				End
		End
END

declare @MaDVVC NVARCHAR(10),
		@TenNVC NVARCHAR(100),
		@NgayGiaoHang DATETIME,
		@SDT_NVC NVARCHAR(15),
		@ketqua nvarchar(30)
SET @MaDVVC = 'DVVC003'
SET @TenNVC = N'Đơn vị vận chuyển B';
SET @NgayGiaoHang = DATEADD(DAY, -2, GETDATE())
SET @SDT_NVC = '0909765432'
exec dvvc_kiemtra_tggiaohang @MaDVVC,@TenNVC,@NgayGiaoHang, @SDT_NVC,@ketqua out
Print @ketqua
select * from DONVIVANCHUYEN
/*Khi có dữ liệu đặt chi tiết nhập mới được thêm hoặc cập nhật hãy kiểm tra xem sản phẩm đó đã tồn tại trong danh sách sản phẩm chưa? 
Nếu đã tồn tại trong danh sách sản phẩm tiến hành cập nhật số lượng sản phẩm trong bảng sản phẩm 
(lấy số lượng sản phẩm + số lượng sản phẩm mới nhập vào). Nếu chưa thì thực hiện thêm sản phẩm vào danh sách sản phẩm.
	input:
	Output:
	process:
*/
create or alter trigger dathangchitiet_themsl
On DAT_chitiet
After insert
as 
begin
	declare @masp char (8),@mahdn char(7), @sl numeric (15,4)
	Select @masp=MaHangVin,@mahdn=MaHDN, @sl=Sl_Nhap from inserted
	if not exists (select MaHangVin from SANPHAM where MaHangVin=@masp)
		begin
			print N'Sản phẩm chưa tồn tại hãy thêm sản phẩm vào bảng SP'
			Print '0'
			Rollback
		End
	else if not exists (select MaHDN from DAT where MaHDN=@mahdn)
		begin
			print N'Mã hoá đơn không tồn tại hãy thêm mới mã hoá đơn'
			Print '0'
			Rollback
		End
	else
		begin
			update SANPHAM
			Set Sl_SP=Sl_SP+@sl
			where MaHangVin=@masp
	
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
select * from SANPHAM
select * from DAT_CHITIET
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0009', 'MHV00504', 10)
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0000', 'MHV00633', 10)


/* 
khi thêm mới một hoá đơn nhập vào, cần kiểm tra một số thông tin như sau
	mã nhà cung cấp có tồn tại không? Nếu không thì thông báo nhà cung cấp không tòn tại và dừng 
	Mã nv có tồn tại không? Nếu không thì thông báo không có nhân viên trên và dừng 
	Nếu mã dvvc không tồn tại thì thông báo thêm thông tin dvcc vào bảng dvvc
	Ngày đặt >ngày hiện tại thì thông báo ngày đặt không hợp lệ, dừng
	Nếu thoả mãn các điều kiện trên tiến hành thêm hoá đơn mới */

create or alter trigger hdn_kiemtrathemhoadon
On dat
After insert 
As 
Begin
	declare @mancc char(8), @manv char(8),@dvvc char(7),@ngaydat datetime
	select @mancc=MaNCC, @manv=MaNV,@dvvc=MaDVVC, @ngaydat=NgayDat from inserted
	if not exists (select MaNCC from NHACUNGCAP where MaNCC=@mancc)
		begin 
			print N'Nhà cung cấp chưa có trong bảng NCC'
			Rollback
			Return
		End
	else if not exists (select MaNV from NHANVIEN where MaNV=@manv)
		begin 
			print N'Nhân viên chưa có trong bảng NV'
			Rollback
			Return
		End
	else if not exists (select MaDVVC from DONVIVANCHUYEN where MaDVVC=@dvvc)
		begin 
			print N'Chưa có dvvc trong bảng dvvc '
			Rollback
			Return
		End
	else if @ngaydat>GETDATE()
		begin 
			print N'Ngày đặt không hợp lệ'
			Rollback 
			Return
		End
End
INSERT INTO DAT (MaHDN, NgayDat, MaNCC, MaNV, MaDVVC)
VALUES ('HDN1000', '2024-10-13 18:08:54.250', '00000369', '2000730', '0000383')


/* 
thêm sản phẩm mới kiểm tra nếu hạn sử dụng <= thời gian hiện tại -->ngừng thông báo 'Không thể thêm sản phẩm đã hết hạn'
*/

create or alter trigger sp_themsp
On sanpham
after insert
As
Begin 
	declare @time datetime
	select @time=HanSuDung from inserted
	If @time<=GETDATE()
		begin
			print N'Sản phẩm đã hết hạn'
			Rollback
		End
End

INSERT INTO SANPHAM (MaHangVin, TenSP, DVT,DonGiaNhap,DonGiaBan,Sl_SP, HanSuDung)
VALUES ('SP000', 'Sản phẩm hết hạn','Cái',500 ,1000,50, '2025-01-01')


/*Khi có dữ liệu đặt chi tiết nhập mới được thêm hãy kiểm tra 
	-mã hoá đơn đã tồn tại chưa? Nếu chưa thông báo 'mã hoá đơn không tồn tại' và huỷ thêm
	-mã sản phẩm đã tồn tại trong hoá đơn chưa? Nếu đã có mã sản phẩm trong hoá đơn thông báo 'mã sản phẩm đã có trong hoá đơn'
thêm. ngược lại cập nhật số lượng sản phẩm= số lượng sản phẩm + số lượng sản phẩm mới nhập vào
Process: kiểm tra mã hoá đơn có tồn tại không ->thông báo 'mã hoá đơn không tồn tại' và huỷ .
		ngược lại kiểm tra mã sản phẩm đã tồn tại trong hoá đơn chưa. Điều kiện where maHDN=@mahdn và maHangvin=@masp
		nếu đã tồn tại -->'thông báo lỗi'+rollback
		Ngược lại tiến hành thêm dữ liệu và cập nhật số lượng sản phẩm ở bảng sản phẩm =số lượng sản phẩm + số lượng nhập
*/
/*
Khi cập nhật số lượng nhập sản phẩm tron đặt chi tiết: kiểm tra mã hoá đơn đó có tồn tại trong bảng đặt không? 
kiểm tra mã sản phẩm đó có trùng khớp với sản phẩm cần cập nhật không ? Nếu không thì huỷ cập nhật. Ngược lại cập nhật lại số lượng 
sản phẩm= số lượng sản phẩm - số lượng nhập cũ + số lượng nhập mới
Process: kiểm tra mã hoá đơn có tồn tại trong bảng không nếu không tồn tại thông báo 'không tồn tại mã hoá đơn'
		ngược lại kiểm tra (count) mã sản phẩm đã tồn tại trong hoá đơn chưa. Điều kiện where maHDN=@mahdn và maHangvin=@masp
					nếu count=0 -> không tồn tại mã sản phẩm trong hoá đơn -> thông báo 'không tồn tại sản phẩm trong hoá đơn'+rollback
					Ngược lại: update số lượng sản phẩm trong bảng sản phẩm= số lượng sản phẩm -số lượng nhập cũ+ số lượng nhập mới

*/
CREATE OR ALTER TRIGGER trigger_them_capnhat_datchitiet
ON DAT_CHITIET
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @masp CHAR(8), @mahdn CHAR(7), @sl_moi NUMERIC(15, 4), @sl_cu NUMERIC(15, 4);
    SELECT @masp = MaHangVin, @mahdn = MaHDN, @sl_moi = Sl_Nhap FROM inserted;
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @sl_cu = Sl_Nhap FROM deleted
        IF NOT EXISTS (SELECT 1 FROM DAT WHERE MaHDN = @mahdn)
        BEGIN
            PRINT N'Không tồn tại mã hóa đơn'
            ROLLBACK
            RETURN
        END
        IF NOT EXISTS (SELECT 1 FROM DAT_CHITIET WHERE MaHDN = @mahdn AND MaHangVin = @masp)
        BEGIN
            PRINT N'Không tồn tại sản phẩm trong hóa đơn';
            ROLLBACK;
            RETURN;
        END
        UPDATE SANPHAM
        SET Sl_SP = Sl_SP - @sl_cu + @sl_moi
        WHERE MaHangVin = @masp;
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT N'Cập nhật không thành công'
            ROLLBACK;
        END
        ELSE
        BEGIN
            PRINT N'Cập nhật thành công'
        END
    END
	---------------------------------------------------------------------------------------------------------------
    ELSE 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM DAT WHERE MaHDN = @mahdn)
        BEGIN
            PRINT N'Mã hóa đơn không tồn tại'
            ROLLBACK
            RETURN
        END
        IF (SELECT count(*) FROM DAT_CHITIET WHERE MaHDN = @mahdn AND MaHangVin = @masp)>0
        BEGIN
            PRINT N'Mã sản phẩm đã có trong hóa đơn'
            ROLLBACK
            RETURN
        END
        UPDATE SANPHAM
        SET Sl_SP = Sl_SP + @sl_moi
        WHERE MaHangVin = @masp
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT N'Cập nhật số lượng sản phẩm không thành công'
            ROLLBACK
        END
        ELSE
        BEGIN
            PRINT N'Thêm và cập nhật thành công'
        END
    END
END


select * from SANPHAM join DAT_CHITIET on SANPHAM.MaHangVin=DAT_CHITIET.MaHangVin
select * from DAT_CHITIET
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0005', 'MHV00001', 10)
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0000', 'MHV00633', 10)
SELECT COUNT(*) FROM DAT_CHITIET WHERE MaHDN = 'HDN0002' AND MaHangVin = 'MHV00479'
UPDATE DAT_CHITIET
SET Sl_Nhap = 0
WHERE MaHDN = 'HDN1100' AND MaHangVin = 'MHV01000'

--Tính tổng tiền cho 1 hóa đơn nhập
/*
input: mã hoá đơn
Output: tổng tiền của hoá đơn được tính
Process:
		b1:tìm mã hoá đơn. Điều kiện MaHDN=@mahdn
		B2:
*/

Select * from DAT_CHITIET
where MaHDN='HDN0005'


--Kiem tra thoi gian ngay dat cua bang DAT. Thời gian hợp lệ là  thời gian giao hàng không lớn hơn thời gian hiện tại
/*
input:
Output:
Process:
*/
create or alter trigger dat_kiemtra_tgdat
on Dat
For insert 
As 
	declare @ngaydat datetime
begin
	select @ngaydat=NgayDat from inserted
	if @ngaydat>getdate()
	begin 
		print N'Ngày đặt không hợp lệ'
		rollback
	end
end
-- Trường hợp ngày đặt hợp lệ (trước ngày hiện tại)
INSERT INTO Dat (MaHDN, NgayDat, GhiChu, MaNCC, MaNV, MaDVvC)
VALUES ('HDN1001', '2023-10-15 14:30:00', N'Đặt hàng hợp lệ', '0000095', '2000046', '0000345');

-- Trường hợp ngày đặt không hợp lệ (sau ngày hiện tại)
INSERT INTO Dat (MaHDN, NgayDat, GhiChu, MaNCC, MaNV, MaDVvC)
VALUES ('HDN1112', '2025-12-01 14:30:00', N'Đặt hàng không hợp lệ', '00000092', '2000004 ', '0000339');

Select * from dat
select * from KHACHHANG
--proc cap nhat thông tin khách hàng khi khách hàng từ khách vãng lai chuyển sang khách hàng thân thiết 
/*
	input: mã khách hàng 
	Output: cập nhật thành công hay cập nhật thất bại
	Process:
			b1: kiểm tra mã khách hàng có tồn tại trong bảng không. Nếu không ngừng ->output: cập nhật thất bại
			b2: tìm loại khách hàng. điều kiện maKH=@maKH
			B3a: Nếu loại khách hàng = 1. --> Đã có thông tin khách hàng --> output: cập nhật thất bại
			B3b: Nếu loại khách hàng =0 
				-kiểm tra số điện thoại : nếu số điện thoại đã có trong bảng khách hàng --> ngừng.->output: cập nhật thất bại
				-nếu không tiến hành loại khách hàng=1,cập nhật sdt, cập nhật ưu đãi cho khách hàng thân thiết mới: 0.2 --> cập nhật thành công
*/
create or alter proc kh_capnhatkhthanthiet (@maKH char(8),@SDT varchar(15),@ketqua nvarchar(30) out)
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
					Set LoaiKH=1,SDT_KH=@SDT,UuDai=0.2
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
Exec kh_capnhatkhthanthiet '10000006','0954098252',@kq out
Print @kq
Select * from KHACHHANG

/*2.Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
	a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành (la cai giao dich dang insert). Nếu trạng thái tài khoản ac_type = 9 thì 
	đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
		i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
		ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi 
			thực hiện giao dịch < 50.000 thì đưa ra thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện. */
/*Phân tích
	bang: transactions
	loai trigger: after
	su kien: insert
	process:
		1. lay ac_no, t_type, t_amount cua bang inserted --> @ac_no, @t_type, @t_amount
		2. lay ac_type, ac_balance cua bang account --> @ac_type, @ac_balance
		3a. Neu @ac_type = 9: print ' tai khoan da bi xoa' + rollback
		3b. Nguoc lai:
			3b.1: Neu @t_type = 1: update account, cot ac_balance = ac_balance + @t_amount
									dieu kien: ac_no = @ac_no
			3b.2: Neu @t_type = 0:
				a) Neu @ac_balance - @t_amount  < 50000: print 'Khong du tien' + Rollback
				b) Nguoc lai: update account, ac_balance = ac_balance - @t_amount
								dieu kien: ac_no  @ac_no
*/
select * from BAN_CHITIET