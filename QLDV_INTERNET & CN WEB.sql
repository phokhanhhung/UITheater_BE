create database QLDV
go
use QLDV
go 
set dateformat dmy
go

create table NGUOIDUNG (
	MANGUOIDUNG varchar(5) constraint PK_NGUOIDUNG_MANGUOIDUNG primary key (MANGUOIDUNG) constraint ID_NGUOIDUNG default DBO.AUTO_MANGUOIDUNG() not null,
	NGAYSINH varchar(255),
	HOTEN nvarchar(255) not null,
	MATKHAU varchar(255) not null,
	SDT varchar(11),
	EMAIL varchar(255),
)

create table PHIM (
	MAPHIM int constraint PK_PHIM_MAPHIM primary key (MAPHIM) constraint ID_PHIM default DBO.AUTO_PHIM() not null,
	TENPHIM nvarchar(255) not null,
	MOTA nvarchar(255) not null,
	DAODIEN nvarchar(255),
	DIENVIEN nvarchar(255),
	NHAPH varchar(255),
	NGAYKC date,
	THOILUONG int not null,
	DOTUOI int not null,
)

create table THELOAI (
	MATL int constraint PK_THELOAI_MATL primary key (MATL),
	THELOAI nvarchar(255) not null,
	GHICHU nvarchar(255),
)

create table PHIM_THELOAI (
	MAPHIM int not null,
	MATL int not null,
	constraint PK_PHIM_THELOAI_MAPHIM_MATL primary key (MAPHIM, MATL),
)
go
alter table PHIM_THELOAI add constraint FK_PHIM_THELOAI_MAPHIM foreign key (MAPHIM) references PHIM(MAPHIM)
alter table PHIM_THELOAI add constraint FK_PHIM_THELOAI_MATL foreign key (MATL) references PHIM(MATL)

create table SUATCHIEU (
	MASUAT int constraint PK_SUATCHIEU_MASUAT primary key (MASUAT),
	NGAYCHIEU date,
)

create table PHONG (
	MAPHONG int constraint PK_PHONG_MAPHONG primary key (MAPHONG),
	SOPHONG int,
	SOLUONGGHE int,
)

create table LICHCHIEU (
	MALICHCHIEU int constraint PK_LICHCHIEU_MALICHCHIEU primary key (MALICHCHIEU), 
	MASUAT int,
	MAPHIM int,
	MAPHONG int,
)
alter table LICHCHIEU add constraint FK_LICHCHIEU_MASUAT foreign key (MASUAT) references SUATCHIEU(MASUAT)
alter table LICHCHIEU add constraint FK_LICHCHIEU_MAPHIM foreign key (MAPHIM) references SUATCHIEU(MAPHIM)
alter table LICHCHIEU add constraint FK_LICHCHIEU_MAPHONG foreign key (MAPHONG) references SUATCHIEU(MAPHONG)

create table GHE (
	MAGHE int constraint PK_GHE_MAGHE primary key (MAGHE),
	SOGHE int,
	HANGGHE varchar(2),
	MAPHONG int,
)
go
alter table GHE add constraint FK_GHE_MAPHONG foreign key (MAPHONG) references PHONG(MAPHONG) 

create table DATVE (
	MAVE int constraint PK_DATVE_MAVE primary key (MAVE),
	MANGUOIDUNG int,
	MALICHCHIEU int,
	MAGHE int,
	GIA money,
	NGAYDATVE datetime,
	HINHTHUCTT nvarchar(255)
)
go
alter table DATVE add constraint FK_DATVE_MANGUOIDUNG foreign key (MANGUOIDUNG) references NGUOIDUNG(MANGUOIDUNG)
alter table DATVE add constraint FK_DATVE_MALICHCHIEU foreign key (MALICHCHIEU) references LICHCHIEU(MALICHCHIEU)
alter table DATVE add constraint FK_DATVE_MAGHE foreign key (MAGHE) references GHE(MANGHE)

------------------------------------------------------
-- TẠO ID TỰ ĐỘNG
------------------------------------------------------
CREATE FUNCTION AUTO_MANGUOIDUNG()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MANGUOIDUNG) FROM NGUOIDUNG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MANGUOIDUNG, 3)) FROM NGUOIDUNG
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'ND00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'ND0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END

CREATE FUNCTION AUTO_MAPHIM()
RETURNS VARCHAR(4)
AS
BEGIN
	DECLARE @ID VARCHAR(4)
	IF (SELECT COUNT(MAPHIM) FROM PHIM) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MAPHIM, 3)) FROM PHIM
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'P00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'P0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END

DROP FUNCTION AUTO_MAPHIM

----------------------------------------------------------------
-- INSERT DỮ LIỆU
----------------------------------------------------------------
-- BẢNG PHIM
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Wonder woman', N'Wonder woman kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 180, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Lalaland', N'Những Kẻ Khờ Mộng Mơ - La La Land kể về về cô nàng Mia với công việc đầu tiên của cô để bước vào con đường điện ảnh là phục vụ đồ uống pha cà phê. Thế nhưng khi sự nghiệp của họ thành công tăng lên, họ phải đối mặt với những quyết định bắt đầu làm tình yêu của họ trở nên rắc rối hơn.', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Free guy', N'Free guy vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Aladdin', N'Aladdin kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Bàn tay diệt quỷ', N'Bàn tay diệt quỷ kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Ong nhí phiêu lưu kí', N'Ong nhí phiêu lưu kí kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)
insert into PHIM(TENPHIM, MOTA, THOILUONG, DOTUOI) values (N'Raya and The last dragon', N'Raya và Rồng Thần Cuối Cùng kể về một vương quốc huyền bí có tên là Kumandra – vùng đất mà loài rồng và con người sống hòa thuận với nhau. Nhưng rồi một thế lực đen tối bỗng đe dọa bình yên nơi đây, loài rồng buộc phải hi sinh để cứu lấy loài người...', 120, 13)






