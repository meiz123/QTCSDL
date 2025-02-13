use QuanlybanhanWinMart

/*1)---------------------------------------------------------------NHÀ CUNG CẤP--------------------------------------------------------------------------------*/
--a)----------Thủ tục --------------------------
go
CREATE OR ALTER PROCEDURE spInsertData_NHACUNGCAP
AS
BEGIN
    DECLARE @mancc CHAR(8), @tenncc NVARCHAR(50), @diachincc NVARCHAR(50), @sdtncc VARCHAR(15);
    DECLARE @i INT = 1, @kq int, @ret int

    WHILE @i <= 1000
    BEGIN
        -- Tạo giá trị MaNCC
        SET @MaNCC = RIGHT('00000000' + CAST(@i AS VARCHAR(8)), 8);
        
        -- Tạo giá trị TenNCC
        SET @tenncc = N'Nhà cung cấp ' + CAST(@i AS VARCHAR(10));
        
        -- Tạo giá trị DiaChiNCC
        SET @diachincc = N'Địa chỉ của nhà cung cấp ' + CAST(@i AS VARCHAR(10));
        
        -- Tạo số điện thoại ngẫu nhiên
        SET @sdtncc =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
							else '03'
						END
                    + RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)


		INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChiNCC, SDT_NCC)
        VALUES (@mancc, @tenncc, @diachincc, @sdtncc);
        
        -- Tăng giá trị đếm
        SET @i = @i + 1;
    END;
END;
exec spInsertData_NHACUNGCAP
select * from NHACUNGCAP
-- Kiem tra xem so dien thoai trong ban NHACUNGCAP co trung khong
select sdt_ncc, count(*) from NHACUNGCAP
group by SDT_NCC

---------------END THỦ TỤC--------------------
/*-------------------------------------------------END NHÀ CUNG CẤP-----------------------------------------------------------------*/



/*2-------------------------------------------------------------ĐƠN VỊ VẬN CHUYỂN---------------------------------------------------------------*/
----------------THỦ TỤC-----------------------
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
        SET @i = @i + 1
    END
END
exec spInsertData_DONVIVANCHUYEN
Select * from DONVIVANCHUYEN
-----------------END THỦ TỤC-----------------------------
/*-------------------------------------------------------------END ĐƠN VỊ VẬN CHUYỂN---------------------------------------------------------------*/



/*3-------------------------------------------------------NHÂN VIÊN------------------------------------------------------------*/
--a)--------------THỦ TỤC-----------------
go
CREATE OR ALTER PROCEDURE spInsertData_NHANVIEN
AS
BEGIN
    DECLARE @manv CHAR(8), @tennv varchar(30), @sdtnv varchar(15)
    DECLARE @i INT = 1, @kq int, @ret int


    WHILE @i <= 1000
    BEGIN
        -- Tạo giá trị Manv
        SET @Manv = '2' + RIGHT ('0000000' + CAST(@i AS VARCHAR(8)), 7);
        
        -- Tạo giá trị TenNV
        SET @tennv = 'Nhân viên ' + CAST(@i AS VARCHAR(10));
        
        -- Tạo số điện thoại ngẫu nhiên
        SET @sdtnv =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
							else '03'
						END
                    + RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)


		INSERT INTO NHANVIEN(MaNV, TenNV, SDT_NV)
        VALUES (@MaNV, @TenNV, @SDTNV);
       
        -- Tăng giá trị đếm
        SET @i = @i + 1;
    END;
END;
exec spInsertData_NHANVIEN
select * from NHANVIEN
-- Kiem tra so dien thoai nhan vien co trung khong?
select sdt_nv, count(*) from nhanvien
group by sdt_nv

------------END THỦ TỤC---------------------
/*---------------------------------------------------END NHÂN VIÊN------------------------------------------------------------------------*/




/*4-------------------------------------------------ĐẶT---------------------------------------------------------------------*/
------THỦ TỤC------------------------
CREATE or ALTER PROCEDURE spInsertData_DAT
AS
BEGIN
    DECLARE @i INT = 1,
			@MaNCC CHAR(8),
			@MaNV CHAR(8),
			@MaDVVC CHAR(7),
			@GhiChu NVARCHAR(30),
			@NgayDat DATETIME = GETDATE()

    WHILE @i <= 1000
    BEGIN
        SELECT TOP 1 @MaNCC = MaNCC FROM NHACUNGCAP ORDER BY NEWID()

        SELECT TOP 1 @MaNV = MaNV FROM NHANVIEN ORDER BY NEWID()

        SELECT TOP 1 @MaDVVC = MaDVVC FROM DONVIVANCHUYEN ORDER BY NEWID()

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
        SET @i = @i + 1
    END
END
EXEC spInsertData_DAT
select * from DAT
-----------------------END THỦ TỤC------------------
/*------------------------------------------------------END ĐẶT-------------------------------------------------------------------------*/




/*5-------------------------------------------------------------------SẢN PHẨM-----------------------------------------------------------------------------------*/
----------------------------------------THỦ TỤC---------------------------------------
go
CREATE OR ALTER PROCEDURE spInsertData_SANPHAM
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @MaHangVin CHAR(8);
    DECLARE @MaSP CHAR(9);
    DECLARE @TenSP NVARCHAR(50);
    DECLARE @DVT NVARCHAR(10);
    DECLARE @DonGiaNhap DECIMAL(10, 2);
    DECLARE @DonGiaBan DECIMAL(10, 2);
    DECLARE @KhuyenMai DECIMAL(4, 2);
    DECLARE @HanSuDung DATE;
    DECLARE @SL_SP INT;

    WHILE @i <= 1000
    BEGIN
        -- Tạo mã hàng Vin ngẫu nhiên và kiểm tra sự trùng lặp
        SET @MaHangVin = 'MHV' + RIGHT('00000' + CAST(@i AS VARCHAR(8)), 5);
        WHILE EXISTS (SELECT 1 FROM SANPHAM WHERE MaHangVin = @MaHangVin)
        BEGIN
            SET @i = @i + 1;
            SET @MaHangVin = 'MHV' + RIGHT('00000' + CAST(@i AS VARCHAR(8)), 5);
        END;

        -- Tạo mã sản phẩm ngẫu nhiên
        SET @MaSP = 'SP' + RIGHT('00000000' + CAST(@i AS VARCHAR(7)), 7);

        -- Tạo tên sản phẩm ngẫu nhiên
        SET @TenSP = N'Sản phẩm ' + CAST(@i AS NVARCHAR(50));

        -- Chọn đơn vị tính ngẫu nhiên
        SET @DVT = CASE FLOOR(RAND() * 4)
            WHEN 0 THEN N'Cái'
            WHEN 1 THEN N'Hộp'
            WHEN 2 THEN N'Chai'
            WHEN 3 THEN N'Túi'
            ELSE N'Thùng'  
        END;

        -- Tạo giá nhập và giá bán ngẫu nhiên
        SET @DonGiaNhap = CAST(100000 * RAND() AS DECIMAL(10, 2));
        SET @DonGiaBan = @DonGiaNhap + CAST(10000 + (RAND() * 100000) AS DECIMAL(10, 2));

        -- Khuyến mãi có thể bằng 0 hoặc có giá trị ngẫu nhiên
        SET @KhuyenMai = CAST(FLOOR(RAND() * 100) AS DECIMAL(4,2));

        -- Hạn sử dụng ngẫu nhiên từ 1 đến 2 năm
        SET @HanSuDung = DATEADD(DAY, FLOOR(RAND() * 730), GETDATE());

        -- Số lượng sản phẩm ngẫu nhiên từ 0 trở lên
        SET @SL_SP = FLOOR(RAND() * 1000);

        -- Chèn dữ liệu vào bảng SANPHAM
        INSERT INTO SANPHAM (MaHangVin, MaSP, TenSP, DVT, DonGiaNhap, DonGiaBan, KhuyenMai, HanSuDung, Sl_SP)
        VALUES (@MaHangVin, @MaSP, @TenSP, @DVT, @DonGiaNhap, @DonGiaBan, @KhuyenMai, @HanSuDung, @SL_SP);

        SET @i = @i + 1;
    END
END;

EXEC spInsertData_SANPHAM;
Select * from SANPHAM
--------------------------------END THỦ TỤC----------------------------------------
/*--------------------------------------------------------------------------------END SẢN PHẨM-----------------------------------------------------------------------------------*/





/*6---------------------------------------------ĐẶT CHI TIẾT---------------------------------------------------------------------------*/
------------------THỦ TỤC-------------------------
go
CREATE OR ALTER PROCEDURE spInsertData_DATCHITIET
AS
BEGIN
    DECLARE @i INT = 1, @MaHDN CHAR(7),@MaHangVin CHAR(8),@SL_Nhap INT

    WHILE @i <= 1000
    BEGIN

        SELECT TOP 1 @MaHDN = MaHDN FROM DAT ORDER BY NEWID()

        SELECT TOP 1 @MaHangVin = MaHangVin FROM SANPHAM ORDER BY NEWID()

        SET @SL_Nhap = FLOOR(RAND() * 10000) + 1

		INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, SL_Nhap)
        VALUES (@MaHDN, @MaHangVin, @SL_Nhap)

        SET @i = @i + 1
    END
END
EXEC spInsertData_DATCHITIET
Select * from DAT_CHITIET

--- Xóa bỏ dữ liệu null
go
CREATE OR ALTER PROCEDURE hdn_hople (@kq nvarchar(50) out,@row int =0 out)
AS
BEGIN
    DELETE FROM DAT
    WHERE MaHDN NOT IN (
						SELECT DISTINCT MaHDN 
						FROM DAT_CHITIET)
	set @row=@@ROWCOUNT
    set @kq = N'Đã xóa các hóa đơn không hợp lệ'
END

Declare @ketqua nvarchar(50),@dong int
exec hdn_hople @ketqua,@dong out
Print @ketqua
Print @dong

select * from DAT left join DAT_CHITIET on DAT.MaHDN = DAT_CHITIET.MaHDN
		left join SANPHAM on SANPHAM.MaHangVin = DAT_CHITIET.MaHangVin
------------------END THỦ TỤC----------------------

/*------------------------------------------------------------END ĐẶT CHI TIẾT------------------------------------------------------------*/





/*7--------------------------------------------------------------------KHÁCH HÀNG----------------------------------------------------------------------------------------*/
--1)----------Thủ tục----------------------
	-- insert and check
go
CREATE OR ALTER PROCEDURE spInsertData_KHACHHANG
AS
BEGIN
    DECLARE @makh CHAR(8), @loaiKH bit, @sdtkh VARCHAR(15), @uudai decimal(4,2);
    DECLARE @i INT = 1, @kq int, @ret int


    WHILE @i <= 1000
    BEGIN
        -- Tạo giá trị MaKH
        SET @Makh = '1' +RIGHT('0000000' + CAST(@i AS VARCHAR(8)), 7);
        
        -- Tạo loai khach hang
        SET @loaiKH = CAST(ABS(CHECKSUM(NEWID())) % 2 AS INT);
        
        -- Tạo số điện thoại ngẫu nhiên
        SET @sdtkh =	CASE   --Rand() nó sẽ cho ra kiểu dữ liệu là float
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 0 THEN '09'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 1 THEN '01'
							WHEN floor(RAND(CHECKSUM(newid())) * 3) = 2 THEN '07'
							else '03'
						END
                    + RIGHT('00000000' + CAST(cast(floor(RAND() * 100000000) as int) AS varCHAR(10)), 8)

		-- Thiet lap gia tri uu dai
        SET @uudai = CAST(FLOOR(RAND() * 100) AS DECIMAL(4,2));

		--kiểm tra khi loại khách hàng = 0 thì sdt 'khong co' và uudai = 0
		if @loaiKH = 0
		begin
			set @sdtkh = Null
			set @uudai = 0
		end

		--kiem tra so dien thaoi co trung hay khong
		IF NOT EXISTS (SELECT 1 FROM KHACHHANg WHERE SDT_KH = @sdtkh)
        BEGIN
			INSERT INTO KHACHHANg (MaKH, LoaiKH, SDT_KH, UuDai)
            VALUES (@MaKH, @LoaiKH, @SDTKH, @UuDai);
        END
		-- kiểm tra số diện thoại có bị trùng hay không
		else
		begin
			PRINT N'Sdt ' + @sdtkh + ' đã tồn tại . Không thể chèn.';
			continue;
		end

        -- Tăng giá trị đếm
        SET @i = @i + 1;
    END;
END;

exec spInsertData_KHACHHANG
select * from khachhang
--Kiem tra so dien thoai khach hang co trung hay khong ?
select sdt_kh, count(*) from KHACHHANG
group by sdt_kh

create or alter proc spInsertData_BAN
as
begin
	DECLARE @maHDB CHAR(15), @ngayban datetime, @pttt Nvarchar(20), @manv char(8), @maKH char(8)
    DECLARE @i INT = 1

    WHILE @i <= 1000
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
						WHEN floor(RAND(CHECKSUM(newid())) * 2) = 0 THEN N'Tiền mặt'
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


		--kiểm tra mã hoa don có trùng hay không 
		IF NOT EXISTS (SELECT 1 FROM BAN WHERE MaHDB = @mahdb)
        BEGIN
			INSERT INTO BAN(maHDB, ngayban, pttt , manv , maKH )
            VALUES (@maHDB , @ngayban , @pttt , @manv , @maKH );
        END
		
		else
		begin
			PRINT N'Mã HDB ' + @mahdb + ' đã tồn tại . Không thể chèn.';
			return
		end

        -- Tăng giá trị đếm
        SET @i = @i + 1;
    END;
end
exec spInsertData_BAN
select * from BAN

go
create or alter proc spInsertData_BANCHITIET
as
begin
	DECLARE @maHDB CHAR(15), @MaHangVin char(8), @sLBan int
	declare @i int = 1

	while @i <= 1000
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

		
		INSERT INTO BAN_CHITIET(maHDB, MaHangVin, sL_Ban )
        VALUES (@maHDB, @MaHangVin, @sLBan);


		set @i = @i  + 1
	end
end
 
exec spInsertData_BANCHITIET
select * from BAN_CHITIET

-----------------------------------------------------------------------------------------------------------------------------------------
/*

*/



------------------------------------------------------------------------------------------------------------------------
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
--CREATE OR ALTER TRIGGER trigger_them_capnhat_datchitiet
--ON DAT_CHITIET
--AFTER INSERT, UPDATE
--AS
--BEGIN
--    DECLARE @masp CHAR(8), @mahdn CHAR(7), @sl_moi NUMERIC(15, 4), @sl_cu NUMERIC(15, 4);
--    SELECT @masp = MaHangVin, @mahdn = MaHDN, @sl_moi = Sl_Nhap FROM inserted;
--    IF EXISTS (SELECT 1 FROM deleted)
--    BEGIN
--        SELECT @sl_cu = Sl_Nhap FROM deleted
--        IF NOT EXISTS (SELECT 1 FROM DAT WHERE MaHDN = @mahdn)
--        BEGIN
--            PRINT N'Không tồn tại mã hóa đơn'
--            ROLLBACK
--            RETURN
--        END
--        IF NOT EXISTS (SELECT 1 FROM DAT_CHITIET WHERE MaHDN = @mahdn AND MaHangVin = @masp)
--        BEGIN
--            PRINT N'Không tồn tại sản phẩm trong hóa đơn';
--            ROLLBACK;
--            RETURN;
--        END
--        UPDATE SANPHAM
--        SET Sl_SP = Sl_SP - @sl_cu + @sl_moi
--        WHERE MaHangVin = @masp;
--        IF @@ROWCOUNT = 0
--        BEGIN
--            PRINT N'Cập nhật không thành công'
--            ROLLBACK;
--        END
--        ELSE
--        BEGIN
--            PRINT N'Cập nhật thành công'
--        END
--    END
--	---------------------------------------------------------------------------------------------------------------
--    ELSE 
--    BEGIN
--        IF NOT EXISTS (SELECT 1 FROM DAT WHERE MaHDN = @mahdn)
--        BEGIN
--            PRINT N'Mã hóa đơn không tồn tại'
--            ROLLBACK
--            RETURN
--        END
--        IF (SELECT count(*) FROM DAT_CHITIET WHERE MaHDN = @mahdn AND MaHangVin = @masp)>0
--        BEGIN
--            PRINT N'Mã sản phẩm đã có trong hóa đơn'
--            ROLLBACK
--            RETURN
--        END
--        UPDATE SANPHAM
--        SET Sl_SP = Sl_SP + @sl_moi
--        WHERE MaHangVin = @masp
--        IF @@ROWCOUNT = 0
--        BEGIN
--            PRINT N'Cập nhật số lượng sản phẩm không thành công'
--            ROLLBACK
--        END
--        ELSE
--        BEGIN
--            PRINT N'Thêm và cập nhật thành công'
--        END
--    END
--END


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




create or alter trigger dct_them_cap_sl
on dat_chitiet
after insert, update
as
begin 
	declare @mahangvin char(8), @maHDN char(7), @SLNHAP_NEW numeric(15,4), @slnhap_cu numeric(15,4), @slSp_new numeric (15,4), @slSp_old numeric (15,4)
	if (select count(*) from deleted) = 0
	begin
		select @mahangvin = MaHangVin, @maHDN = MaHDN, @SLNHAP_NEW = Sl_Nhap from inserted
		update SANPHAM
		set Sl_SP = Sl_SP + @SLNHAP_NEW
		where MaHangVin = @mahangvin

		if @@ROWCOUNT =0
			begin 
				print N'Thêm số lượng sản phẩm thất bại'
			end
		else 
			begin
				print N'Thêm số lượng sản phẩm thành công'
			end
	End
	else if (select count(*) from deleted) = 1 and (select count(*) from inserted) =  1
	begin
		select @SLNHAP_NEW = sl_nhap, @maHDN = MaHDN, @mahangvin = MaHangVin from inserted
		select @slnhap_cu = sl_nhap from deleted where MaHDN = @maHDN and MaHangVin = @mahangvin

		update SANPHAM
		set Sl_SP = Sl_SP - @slnhap_cu + @SLNHAP_NEW
		where MaHangVin = @mahangvin

		if @@ROWCOUNT =0
			begin 
				print N'Cập nhật thất bại'
				rollback
			end
		else 
			begin
				print N'Cập nhật thành công'
			end
	end
end

UPDATE DAT_CHITIET
SET Sl_Nhap = 10
WHERE MaHDN = 'HDN0420' AND MaHangVin = 'MHV00001'
select * from DAT_CHITIET join SANPHAM on SANPHAM.MaHangVin=DAT_CHITIET.MaHangVin
--304 787
delete DAT_CHITIET
where MaHDN='HDN0005' and MaHangVin='MHV00001'
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN1000', 'MHV00001', 10)
INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0000', 'MHV00633', 10)
SELECT COUNT(*) FROM DAT_CHITIET WHERE MaHDN = 'HDN0005' AND MaHangVin = 'MHV00001'

----------------------------------------------------------------------------------------------------------------------------------------------
/*Khi có sản phẩm mới được thêm vào hoá đơn nhập hãy cập nhật số lượng sản phẩm trong bảng sản phẩm. Số lượng sản phẩm = số lượng sản phẩm hiện có+
số lượng sản phẩm nhập vào
Phân tích 
Bảng dat_chitiet
Loai trigger: after
Sự kiện: insert
Process:b1 tìm số lượng nhập của sản phẩm. Điều kiện: MaHDN=@mahoadon, Mahangvin=@masanpham
		b2: Cập nhật số lượng sản phẩm cửa hàng hiện có = số lượng sản phẩm + số lượng nhập
		B3: nếu @@rowcount = 0 -> print: 'Cập nhật thất bại'+rollback
			ngược lại -> print: 'Cập nhật thành công'
*/

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
			print N'Cập nhật thất bại'
			Rollback
		End
	else 
		begin
			print N'Cập nhật thành công'
		End
End

INSERT INTO DAT_CHITIET (MaHDN, MaHangVin, Sl_Nhap)
VALUES ('HDN0002', 'MHV00427', 10)
/*
Cập nhật số lượng nhập sản phẩm trong hoá đơn nhập. 
Kiểm tra sản phẩm có trong hoá đơn không. Nếu không ngừng xử lý. Ngược lại tiến hành cập nhật số lượng sản phẩm hiện có (SL_SP bảng sản phẩm)
=số lượng sản phẩm- số lượng nhập cũ+ số lượng nhập mới.
Bảng dat_chitiet
Loai trigger: after
Sự kiện: update
Process:b1 Tìm mã hàng vin, mã hoá đơn, số lượng nhập mới trong bảng inserted
		b2:tìm số lượng nhập cũ trong bảng deleted
		b3 kiểm tra mã hoá đơn có tồn tại chưa? Nếu chưa print 'Mã hoá đơn không tồn tại'+rollback
		b4: kiểm tra mã hàng vin có trong hoá đơn nhập chi tiết chưa? Nếu chưa print'Mã hàng vin chưa có trong hoá đơn'+rollback
		B5: update số lượng sản phẩm (bảng sản phẩm)= số lượng sản phẩm - số lượng nhập cũ + số lượng nhập mới
		b6 : nếu @@rowcount =0 -> print 'Update thất bại'+rollback.Ngược lại print 'Update thành công'
*/
create or alter trigger dat_chitiet_capnhatsoluong
On dat_chitiet
After update
As
begin
	declare @mahangvin char(8), @mahoadon char(8), @soluongnhapmoi int, @soluongnhapcu int
	Select @mahangvin=MaHangVin,@mahoadon=MaHDN,@soluongnhapmoi=Sl_Nhap from inserted
	Select @soluongnhapcu=Sl_Nhap  from deleted
	if (select count(*) from DAT where MaHDN=@mahoadon)=0
		begin 
			print N'Mã hoá đơn không tồn tại'
			Rollback
			Return
		End
	else 
		begin
			if (select count(*) from DAT_CHITIET where MaHDN=@mahoadon And MaHangVin=@mahangvin)=0
				begin
					print N'Mã hàng vin chưa có trong hoá đơn'
					Rollback
					Return
				End
			else 
				begin
					update SANPHAM
						Set Sl_SP=Sl_SP-@soluongnhapcu+@soluongnhapmoi
						where MaHangVin=@mahangvin
						If @@ROWCOUNT=0 
							begin
								print N'Cập nhật thất bại'
								Rollback
							End
						else 
							begin 
								print N'Cập nhật thành công'
							end
				end
	end
End


--------------------------------------proc----------------------------------
/*Cập nhật số lượng nhập sản phẩm trong hoá đơn nhập. 
Kiểm tra sản phẩm có trong hoá đơn không. Nếu không ngừng xử lý. Ngược lại tiến hành cập nhật số lượng sản phẩm hiện có (SL_SP bảng sản phẩm)
=số lượng sản phẩm- số lượng nhập cũ+ số lượng nhập mới.*/
/*
input: mã hoá đơn, mã hàng vin, số lượng nhập
Output: Cập nhật thành công hay thất bại
Process:	b1:kiểm tra mã hoá đơn có tồn tại hay không. Nếu không ngừng xử lý -->print: 'Không tồn tại mã hoá đơn'--> output: cập nhật thất bại
			b2:kiểm tra mã hàng vin có tồn tại hoá đơn không? Nếu không ngừng xử lý -> print:'Không tồn tại sản phẩm trong hoá đơn'
			-->output: cập nhật thất bại
			B3: tìm số lượng nhập cũ. Điều kiện: mahangvin=@mahangvin và MaHDN =@mahoadon
			B4: update số lượng sản phẩm trong bảng sản phẩm =sl_sp- số lượng nhập cũ + số lượng nhập mới
			B5: nếu @@rowcount =0 --> output: cập nhật thất bại. Ngược lại output: cập nhật thành công
*/		
Go
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




--985, cũ 10, mới 5 
Select * from DAT_CHITIET
select * from SANPHAM
where MaHangVin='MHV00261'
UPDATE DAT_CHITIET
SET Sl_Nhap = 10
WHERE MaHDN = 'HDN0001' AND MaHangVin = 'MHV00261'

-------------------------------------------------------------------------------------------------------------------

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
	
	-- tinh don gia ban tu don gia nhap voi ty le 20%
	set @dongiaban = @DonGiaNhap + (@DonGiaNhap*0.2)

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

---------------------------------------------------------------------------------------------------------------------------
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
