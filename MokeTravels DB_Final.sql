--create database MokeTravels

create table Customer (
CustID varchar(10) NOT NULL,
CustName varchar(70) NOT NULL,
PRIMARY KEY (CustID)
);
 

create table Itinerary (
ItineraryNo varchar(10) NOT NULL,
Duration float NULL,
ItineraryDesc varchar(150) NULL,
PRIMARY KEY (ItineraryNo)
);


create table Staff (
StaffID varchar(10) NOT NULL,
StaffName varchar(50) NOT NULL
PRIMARY KEY (StaffID)
);


create table Trip (
StaffID varchar(10) NOT NULL,
ItineraryNo varchar(10) NOT NULL,
DepartureDate date UNIQUE NOT NULL,
DepartureTime time NOT NULL,
AdultPrice smallmoney NOT NULL,
ChildPrice smallmoney NOT NULL,
Status varchar(20) NOT NULL,
MaxNoofParticipants int NOT NULL,
constraint fk_Trip_StaffID
foreign key (StaffID) references Staff(StaffID),
constraint fk_Trip_ItineraryNo
foreign key (ItineraryNo) references Itinerary(ItineraryNo),
primary key(DepartureDate,StaffID,ItineraryNo),
CONSTRAINT CK_Trip_AdultPrice CHECK (AdultPrice >= 0),
CONSTRAINT CK_Trip_ChildPrice CHECK (ChildPrice >= 0),
);


create table Booking (
BookingNo varchar(10) NOT NULL,
BookingDate smalldatetime NOT NULL,
StaffID varchar(10) NOT NULL,
CustID varchar(10) NOT NULL,
DepartureDate date NOT NULL,
PRIMARY KEY (BookingNo),
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
FOREIGN KEY (CustID) REFERENCES Customer(CustID),
FOREIGN KEY (DepartureDate) REFERENCES Trip(DepartureDate),
);


create table Contact (
StaffID varchar(10) NOT NULL,
StaffContact varchar(20) NOT NULL,
PRIMARY KEY(StaffID),
Foreign KEY (StaffID) REFERENCES Staff(StaffID)
);


create table TravelAdvisor (
StaffID varchar(10) NOT NULL,
PRIMARY KEY (StaffID),
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);


create table TourLeader (
StaffID varchar(10) NOT NULL,
LicenseNo varchar(20) NOT NULL,
LicenseExpiryDate date NOT NULL,
PRIMARY KEY (StaffID),
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

create table Country (
CountryCode varchar(10) NOT NULL,
CountryDesc char(100) NOT NULL,
PRIMARY KEY (CountryCode)
);

create table City (
CityCode varchar(10) NOT NULL,
CityDesc varchar(100) NULL,
CountryCode varchar(10) NOT NULL,
PRIMARY KEY (CityCode),
FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
);

create table Site (
SiteID varchar(10) NOT NULL,
SiteDesc varchar(100) NULL,
CityCode varchar(10) NOT NULL,
PRIMARY KEY (SiteID),
FOREIGN KEY (CityCode) REFERENCES City(CityCode)
);

create table Visits (
ItineraryNo varchar(10) NOT NULL,
SiteID varchar(10) NOT NULL,
CONSTRAINT PK_SiteID_ItineraryNo PRIMARY KEY NONCLUSTERED (SiteID, ItineraryNo),
FOREIGN KEY (SiteID) REFERENCES Site(SiteID),
FOREIGN KEY (ItineraryNo) REFERENCES Itinerary(ItineraryNo)
);

create table Hotel (
HotelID varchar(20) NOT NULL,
HotelName varchar(100) NOT NULL,
HotelCategory varchar(20) NOT NULL,
PRIMARY KEY (HotelID)
);

--
create table StaysIn (
HotelID varchar(20) NOT NULL,
DepartureDate date NOT NULL,
ItineraryNo varchar(10) NOT NULL,
CheckInDate smalldatetime NOT NULL,
CheckOutDate smalldatetime NOT NULL,
CONSTRAINT PK_HotelID_DepartureDate_ItineraryNo PRIMARY KEY NONCLUSTERED (HotelID, DepartureDate, ItineraryNo),
FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
FOREIGN KEY (DepartureDate) REFERENCES Trip(DepartureDate),
FOREIGN KEY (ItineraryNo) REFERENCES Itinerary(ItineraryNo)
);
 
create table Flight (
FlightNo varchar(10) NOT NULL,
Airline varchar(30) NOT NULL,
Origin varchar(30) NOT NULL,
Destination varchar(30) NOT NULL,
FlightTime time NOT NULL,
PRIMARY KEY (FlightNo)
);

create table FliesOn (
DepartureDate date NOT NULL,
ItineraryNo varchar(10) NOT NULL,
FlightNo varchar(10) NOT NULL,
FlightDate smalldatetime NOT NULL,
CONSTRAINT PK_FlightNo_DepartureDate_ItineraryNo PRIMARY KEY NONCLUSTERED (FlightNo, DepartureDate, ItineraryNo),
FOREIGN KEY (FlightNo) REFERENCES Flight(FlightNo),
FOREIGN KEY (DepartureDate) REFERENCES Trip(DepartureDate),
FOREIGN KEY (ItineraryNo) REFERENCES Itinerary(ItineraryNo)
);


create table Passenger (
BookingNo varchar(10) NOT NULL,
CustID varchar(10) NOT NULL,
Age varchar(5) NOT NULL,
Nationality varchar(50) NOT NULL,
PassportNo varchar(15) NOT NULL,
PassportExpiry date NOT NULL,
Gender char (1) NULL CHECK (Gender IN ('M','F')),
PricePaid float,
PRIMARY KEY NONCLUSTERED(BookingNo, CustID),
FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

-- 
create table RoomType (
RmTypeID varchar(10) NOT NULL,
RmDesc varchar(100) NOT NULL,
PRIMARY KEY (RmTypeID)
);

create table Requires(
RmTypeID varchar(10) NOT NULL,
BookingNo varchar(10) NOT NULL,
NoOfExtraBeds int NOT NULL,
NoOfRooms int NOT NULL,
CONSTRAINT PK_Requires_RmTypeID PRIMARY KEY NONCLUSTERED (RmTypeID, BookingNo),
FOREIGN KEY (RmTypeID) REFERENCES RoomType(RmTypeID)
);

create table Promotion (
PromoCode varchar(10) NOT NULL,
Discount float NOT NULL,
PromoDesc varchar(30) NULL,
PRIMARY KEY (PromoCode)
);

-- 
create table AppliesTo (
PromoCode varchar(10) NOT NULL,
DepartureDate date NOT NULL,
ItineraryNo varchar(10) NOT NULL,
CONSTRAINT PK_PromoCode_DepartureDate_ItineraryNo PRIMARY KEY NONCLUSTERED (PromoCode, DepartureDate, ItineraryNo),
FOREIGN KEY (PromoCode) REFERENCES Promotion(PromoCode),
FOREIGN KEY (DepartureDate) REFERENCES Trip(DepartureDate),
FOREIGN KEY (ItineraryNo) REFERENCES Itinerary(ItineraryNo)
);


create table Payment (
PmtNo varchar(10) NOT NULL,
ChequeNo varchar(20) NULL,
CreditCardNo varchar(50)  NULL,
PmtDate smalldatetime NOT NULL,
PmtType char(10) NOT NULL,
PmtAmt float NOT NULL,
PmtMethod char(10) NOT NULL,
BookingNo varchar(10) NOT NULL,
PRIMARY KEY (PmtNo),
FOREIGN KEY (BookingNo) REFERENCES Booking(BookingNo)
);

create table Enjoys (
CustID varchar(10) NOT NULL,
BookingNo varchar(10) NOT NULL,
PromoCode varchar(10) NOT NULL,
CONSTRAINT PK_CustID_PromoCode PRIMARY KEY NONCLUSTERED (CustID, PromoCode),
FOREIGN KEY (CustID) REFERENCES Customer(CustID),
FOREIGN KEY (PromoCode) REFERENCES Promotion(PromoCode)
);


create table Organiser (
CustID varchar(10) NOT NULL,
CustEmail varchar(255) NOT NULL,
CustContact int NOT NULL,
PRIMARY KEY (CustID),
FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

INSERT INTO Country VALUES ('CC001','Peoples Republic of China')
INSERT INTO Country VALUES ('CC002','Malaysia')
INSERT INTO Country VALUES ('CC003','Hong Kong SAR')
INSERT INTO Country VALUES ('CC004','Thailand')
INSERT INTO Country VALUES ('CC005','Vietnam')
INSERT INTO Country VALUES ('CC006','Republic of Korea')
INSERT INTO Country VALUES ('CC007','United States of America')
INSERT INTO Country VALUES ('CC008','Mauritius')
INSERT INTO Country VALUES ('CC009','Switzerland')
INSERT INTO Country VALUES ('CC010','Sweden')
INSERT INTO Country VALUES ('CC011','United Kingdom')
INSERT INTO Country VALUES ('CC012','France')
INSERT INTO Country VALUES ('CC013','Netherlands')
INSERT INTO Country VALUES ('CC014','Australia')
INSERT INTO Country VALUES ('CC015','South Africa')


INSERT INTO City VALUES ('CT001','Shanghai','CC001')
INSERT INTO City VALUES ('CT002','Kuala Lumpur','CC002')
INSERT INTO City VALUES ('CT003','Beijing','CC001')
INSERT INTO City VALUES ('CT004','Hong Kong SAR','CC003')
INSERT INTO City VALUES ('CT005','Hanoi','CC005')
INSERT INTO City VALUES ('CT006','Ho Chi Minh','CC005')
INSERT INTO City VALUES ('CT007','New York','CC007')
INSERT INTO City VALUES ('CT008','Paris','CC012')
INSERT INTO City VALUES ('CT009','Amsterdam','CC013')
INSERT INTO City VALUES ('CT010','London','CC011')
INSERT INTO City VALUES ('CT011','San Francisco','CC007')
INSERT INTO City VALUES ('CT012','Sydney','CC011')
INSERT INTO City VALUES ('CT013','Cape Town','CC015')
INSERT INTO City VALUES ('CT014','Seoul','CC006')
INSERT INTO City VALUES ('CT015','Geneva','CC009')


INSERT INTO Site VALUES ('ST001','Big Ben','CT010')
INSERT INTO Site VALUES ('ST002','Louvre Museum','CT008')
INSERT INTO Site VALUES ('ST003','Ocean Park','CT004')
INSERT INTO Site VALUES ('ST004','Statue of Liberty National Monument','CT007')
INSERT INTO Site VALUES ('ST005','Alcatraz Island','CT011')
INSERT INTO Site VALUES ('ST006','Van Gogh Museum','CT009')
INSERT INTO Site VALUES ('ST007','Sydney Opera House','CT012')
INSERT INTO Site VALUES ('ST008','Ben Thanh Market','CT006')
INSERT INTO Site VALUES ('ST009','Petronas Towers','CT002')
INSERT INTO Site VALUES ('ST010','Yu Garden','CT001')
INSERT INTO Site VALUES ('ST011','Cape of Good Hope','CT013')
INSERT INTO Site VALUES ('ST012','Thăng Long Imperial Citadel','CT005')
INSERT INTO Site VALUES ('ST013','Great Wall of China','CT003')
INSERT INTO Site VALUES ('ST014','Gyeongbokgung Palace','CT014')

INSERT INTO Itinerary VALUES ('IT001', 5.5,'10-Day Shanghai Tour')
INSERT INTO Itinerary VALUES ('IT002', 4.5,'3-Day Kuala Lumpur Tour')
INSERT INTO Itinerary VALUES ('IT003', 6,'5-Day Hong Kong SAR Tour')
INSERT INTO Itinerary VALUES ('IT004', 6.5,'8-Day Ho Chi Minh Tour')
INSERT INTO Itinerary VALUES ('IT005', 3.5,'14-Day New York Tour')
INSERT INTO Itinerary VALUES ('IT006', 3,'7-Day London Tour')
INSERT INTO Itinerary VALUES ('IT007', 3.5,'10-Day Sydney Tour')
INSERT INTO Itinerary VALUES ('IT008', 3.5,'14-Day Paris Tour')
INSERT INTO Itinerary VALUES ('IT009', 4,'12-Day Amsterdam Tour')
INSERT INTO Itinerary VALUES ('IT010', 4.5,'14-Day San Francisco Tour')

INSERT INTO Staff VALUES ('S0001','Andy Ng')
INSERT INTO Staff VALUES ('S0002','Sun Lei')
INSERT INTO Staff VALUES ('S0003','Tan Hock Guan')
INSERT INTO Staff VALUES ('S0004','Liew Yoon Hin')
INSERT INTO Staff VALUES ('S0005','Ismail Ahmed Fulu')
INSERT INTO Staff VALUES ('S0006','Charis Tang')
INSERT INTO Staff VALUES ('S0007','Choo Cheng How')
INSERT INTO Staff VALUES ('S0008','Fabian Ng')
INSERT INTO Staff VALUES ('S0009','Teo Chea Wan')
INSERT INTO Staff VALUES ('S0010','Steven Ong')
INSERT INTO Staff VALUES ('S0011','David Tan')
INSERT INTO Staff VALUES ('S0012','Seth Wong')
INSERT INTO Staff VALUES ('S0013','Davis Eng')
INSERT INTO Staff VALUES ('S0014','Tanya Sing')
INSERT INTO Staff VALUES ('S0015','Lee Kuan Yew')
INSERT INTO Staff VALUES ('S0016','Amos Yee')
INSERT INTO Staff VALUES ('S0017','Lee Hsien Loong')
INSERT INTO Staff VALUES ('S0018','Gerry Lim')
INSERT INTO Staff VALUES ('S0019','Wesley Ang')
INSERT INTO Staff VALUES ('S0020','Tharun Rawisangar')

INSERT INTO Contact VALUES ('S0001','98765432')
INSERT INTO Contact VALUES ('S0002','93647268')
INSERT INTO Contact VALUES ('S0003','87654321')
INSERT INTO Contact VALUES ('S0004','88726374')
INSERT INTO Contact VALUES ('S0005','97273816')
INSERT INTO Contact VALUES ('S0006','96371862')
INSERT INTO Contact VALUES ('S0007','84527328')
INSERT INTO Contact VALUES ('S0008','96272815')
INSERT INTO Contact VALUES ('S0009','82637183')
INSERT INTO Contact VALUES ('S0010','82632718')
INSERT INTO Contact VALUES ('S0011','84567234')
INSERT INTO Contact VALUES ('S0012','92343454')
INSERT INTO Contact VALUES ('S0013','85234456')
INSERT INTO Contact VALUES ('S0014','93423344')
INSERT INTO Contact VALUES ('S0015','88890543')
INSERT INTO Contact VALUES ('S0016','93434564')
INSERT INTO Contact VALUES ('S0017','80986748')
INSERT INTO Contact VALUES ('S0018','85685325')
INSERT INTO Contact VALUES ('S0019','92345067')
INSERT INTO Contact VALUES ('S0020','83466783')


INSERT INTO TourLeader VALUES ('S0001','LN0001','2020-01-01')
INSERT INTO TourLeader VALUES ('S0002','LN0002','2021-02-20')
INSERT INTO TourLeader VALUES ('S0003','LN0003','2020-09-06')
INSERT INTO TourLeader VALUES ('S0004','LN0004', '2019-08-17')
INSERT INTO TourLeader VALUES ('S0005','LN0005','2022-01-11')
INSERT INTO TourLeader VALUES ('S0006','LN0006','2022-11-01')
INSERT INTO TourLeader VALUES ('S0007','LN0007','2021-07-31')
INSERT INTO TourLeader VALUES ('S0008','LN0008', '2020-04-24')
INSERT INTO TourLeader VALUES ('S0009','LN0009', '2022-06-11')
INSERT INTO TourLeader VALUES ('S0010','LN0010', '2020-05-13')



INSERT INTO TravelAdvisor VALUES ('S0011')
INSERT INTO TravelAdvisor VALUES ('S0012')
INSERT INTO TravelAdvisor VALUES ('S0013')
INSERT INTO TravelAdvisor VALUES ('S0014')
INSERT INTO TravelAdvisor VALUES ('S0015')
INSERT INTO TravelAdvisor VALUES ('S0016')
INSERT INTO TravelAdvisor VALUES ('S0017')
INSERT INTO TravelAdvisor VALUES ('S0018')
INSERT INTO TravelAdvisor VALUES ('S0019')
INSERT INTO TravelAdvisor VALUES ('S0020')

INSERT INTO Customer VALUES ('C0001','Lihua')
INSERT INTO Customer VALUES ('C0002','John')
INSERT INTO Customer VALUES ('C0003','Cindy')
INSERT INTO Customer VALUES ('C0004','Samuel')
INSERT INTO Customer VALUES ('C0005','Chai')
INSERT INTO Customer VALUES ('C0006','Ben')
INSERT INTO Customer VALUES ('C0007','Kiki')
INSERT INTO Customer VALUES ('C0008','Ada')
INSERT INTO Customer VALUES ('C0009','Glenn')
INSERT INTO Customer VALUES ('C0010','Danny')



INSERT INTO Trip VALUES ('S0001','IT001','2020-02-17','20:30:00',400,250,'Available',30)
INSERT INTO Trip VALUES ('S0002','IT002','2020-04-23','19:30:00',350,200,'Full',20)
INSERT INTO Trip VALUES ('S0003','IT003','2020-10-15','23:30:00',500,250,'Available',30)
INSERT INTO Trip VALUES ('S0004','IT004','2020-12-23','00:00:00',550,270,'Full',40)
INSERT INTO Trip VALUES ('S0005','IT005','2020-02-18','07:30:00',300,200,'Cancelled',35)
INSERT INTO Trip VALUES ('S0006','IT006','2020-06-10','20:30:00',400,250,'Full',40)
INSERT INTO Trip VALUES ('S0007','IT007','2020-12-11','22:30:00',400,150,'Available',30)
INSERT INTO Trip VALUES ('S0008','IT008','2020-12-20','23:00:00',450,265,'Full',35)
INSERT INTO Trip VALUES ('S0009','IT009','2020-01-20','05:30:00',300,200,'Unavailable',40)
INSERT INTO Trip VALUES ('S0010','IT010','2020-11-30','23:30:00',400,250,'Available',40)

INSERT INTO Booking VALUES ('B0001','2020-01-01 00:00:00','S0011','C0001','2020-02-17')
INSERT INTO Booking VALUES ('B0002','2019-12-01 00:00:00','S0012','C0003','2020-04-23')
INSERT INTO Booking VALUES ('B0003','2019-11-01 00:00:00','S0013','C0004','2020-10-15')
INSERT INTO Booking VALUES ('B0004','2019-09-01 00:00:00','S0013','C0005','2020-12-23')
INSERT INTO Booking VALUES ('B0005','2020-01-10 00:00:00','S0014','C0006','2020-02-17')
INSERT INTO Booking VALUES ('B0006','2020-01-18 00:00:00','S0011','C0007','2020-06-10')
INSERT INTO Booking VALUES ('B0007','2020-01-18 00:00:00','S0018','C0001','2020-12-11')
INSERT INTO Booking VALUES ('B0008','2020-01-06 00:00:00','S0020','C0002','2020-12-20')
INSERT INTO Booking VALUES ('B0009','2019-12-04 00:00:00','S0011','C0009','2020-01-20')
INSERT INTO Booking VALUES ('B0010','2020-01-29 00:00:00','S0015','C0008','2020-11-30')


INSERT INTO Payment VALUES ('PN001',NULL , '4234324209982984','2020-01-01 13:00:00','Balance', 500,'Card','B0001')
INSERT INTO Payment VALUES ('PN002','CN001', NULL,'2019-12-01 09:00:00','Deposit', 500,'Cheque','B0002')
INSERT INTO Payment VALUES ('PN003','CN002', NULL,'2019-11-01 11:00:00','Balance', 400,'Cheque','B0003')
INSERT INTO Payment VALUES ('PN004', NULL, '5747334645642675','2019-09-01 16:00:00','Balance', 550,'Card','B0004')
INSERT INTO Payment VALUES ('PN005','CN003', NULL,'2020-01-21 21:00:00','Balance', 600,'Cheque','B0005')
INSERT INTO Payment VALUES ('PN006', NULL, '685562356361544','2020-01-18 22:00:00','Balance', 530,'Card','B0006')
INSERT INTO Payment VALUES ('PN007','CN004', NULL,'2020-01-18 14:00:00','Deposit', 400,'Cheque','B0007')
INSERT INTO Payment VALUES ('PN008', NULL, '9087564246742334','2020-01-06 16:00:00','Balance', 550,'Card','B0008')
INSERT INTO Payment VALUES ('PN009',NULL, '6764245656736543','2020-01-04 22:00:00','Balance', 450,'Card','B0009')
INSERT INTO Payment VALUES ('PN010','CN005', NULL,'2020-01-29 12:00:00','Deposit', 510,'Cheque','B0010')

INSERT INTO RoomType VALUES ('RT001','Double Queen Bed')
INSERT INTO RoomType VALUES ('RT002','Double King Bed')
INSERT INTO RoomType VALUES ('RT003','Single Queen Bed')
INSERT INTO RoomType VALUES ('RT004','Single King Bed')
INSERT INTO RoomType VALUES ('RT005','Double Single Bed')
INSERT INTO RoomType VALUES ('RT006','Loft Apartment')
INSERT INTO RoomType VALUES ('RT007','Ensuite')
INSERT INTO RoomType VALUES ('RT008','Joint Room')
INSERT INTO RoomType VALUES ('RT009','Queen Bed + Single Bed')
INSERT INTO RoomType VALUES ('RT010','2 Single Beds')

INSERT INTO Requires VALUES ('RT001','B0001', 2, 40)
INSERT INTO Requires VALUES ('RT002','B0001', 3, 45)
INSERT INTO Requires VALUES ('RT003','B0002', 2, 40)
INSERT INTO Requires VALUES ('RT001','B0002', 5, 40)
INSERT INTO Requires VALUES ('RT002','B0003', 2, 60)
INSERT INTO Requires VALUES ('RT003','B0003', 2, 65)
INSERT INTO Requires VALUES ('RT004','B0004', 10, 56)
INSERT INTO Requires VALUES ('RT005','B0004', 6, 40)
INSERT INTO Requires VALUES ('RT004','B0005', 2, 45)
INSERT INTO Requires VALUES ('RT004','B0006', 2, 40)
INSERT INTO Requires VALUES ('RT003','B0007', 1, 40)
INSERT INTO Requires VALUES ('RT010','B0008', 2, 45)
INSERT INTO Requires VALUES ('RT008','B0009', 1, 45)
INSERT INTO Requires VALUES ('RT004','B0010', 2, 40)
INSERT INTO Requires VALUES ('RT005','B0010', 2, 40)

INSERT INTO Organiser VALUES ('C0001','Lihua@gmail.com',01065529988)
INSERT INTO Organiser VALUES ('C0002','John@gmail.com',89929301)
INSERT INTO Organiser VALUES ('C0003','Cindy@gmail.com', 01062783892)
INSERT INTO Organiser VALUES ('C0004','Samuel@gmail.com', 50299506)
INSERT INTO Organiser VALUES ('C0005','Chai@gmail.com', 022590391)
INSERT INTO Organiser VALUES ('C0006','Ben@gmail.com', 90480934)
INSERT INTO Organiser VALUES ('C0007','Kiki@gmail.com', 063-985932)
INSERT INTO Organiser VALUES ('C0008','Ada@gmail.com', 0655425904)
INSERT INTO Organiser VALUES ('C0009','Glenn@gmail.com', 87069053)
INSERT INTO Organiser VALUES ('C0010','Danny@gmail.com',93043902)


INSERT INTO Passenger VALUES ('B0001','C0001', 40,'Peoples Republic of China','C8329833','2022-12-13','F', 500)
INSERT INTO Passenger VALUES ('B0002','C0002', 50,'Singapore','S29833','2022-12-13','F', 500)
INSERT INTO Passenger VALUES ('B0003','C0003', 69,'Peoples Republic of China','C1283792','2022-12-09','F', 400)
INSERT INTO Passenger VALUES ('B0004','C0004', 20 ,'Malaysia','M198623','2021-11-21','M', 550)
INSERT INTO Passenger VALUES ('B0005','C0005', 38,'Thailand','T13425','2021-10-20','M', 600)
INSERT INTO Passenger VALUES ('B0006','C0006', 54,'Singapore','S23890','2021-12-01','M',530)
INSERT INTO Passenger VALUES ('B0007','C0007', 27,'Cambodia','K2234835','2023-05-24','F', 400)
INSERT INTO Passenger VALUES ('B0008','C0008', 29,'Germany','G8171235','2022-11-15','F', 550)
INSERT INTO Passenger VALUES ('B0009','C0009', 33,'Malaysia','M928347','2021-07-04','M', 450)
INSERT INTO Passenger VALUES ('B0010','C0010', 58,'Singapore','S20387','2023-02-27','M', 510)

INSERT INTO Flight VALUES ('FL0001','Singapore Airlines','Singapore','London','13:15')
INSERT INTO Flight VALUES ('FL0002','Singapore Airlines','Singapore','Paris','13:00')
INSERT INTO Flight VALUES ('FL0003','KLM','Singapore','Amsterdam','12:30')
INSERT INTO Flight VALUES ('FL0004','Singapore Airlines','Singapore','Kuala Lumpur','18:30')
INSERT INTO Flight VALUES ('FL0005','Qantas','Singapore','Sydney','07:30')
INSERT INTO Flight VALUES ('FL0006','Air France','Singapore','Paris','13:00')
INSERT INTO Flight VALUES ('FL0007','Singapore Airlines','Singapore','Hong Kong','04:00')
INSERT INTO Flight VALUES ('FL0008','Singapore Airlines','Singapore','Shanghai','05:15')
INSERT INTO Flight VALUES ('FL0009','Singapore Airlines','Shanghai','Singapore','13:15')
INSERT INTO Flight VALUES ('FL0010','Singapore Airlines','London','Singapore','13:15')
INSERT INTO Flight VALUES ('FL0011','Singapore Airlines','Hong Kong','Singapore','4:00')
INSERT INTO Flight VALUES ('FL0012','KLM','Amsterdam', 'Singapore','12:30')
INSERT INTO Flight VALUES ('FL0013','Qantas','Sydney', 'Singapore','7:30')
INSERT INTO Flight VALUES ('FL0014','Singapore Airlines','Paris','Singapore','13:00')
INSERT INTO Flight VALUES ('FL0015','Air France','Paris','Singapore','13:00')
INSERT INTO Flight VALUES ('FL0016','Singapore Airlines','New York','Singapore','18:30')
INSERT INTO Flight VALUES ('FL0017','Singapore Airlines','Singapore','Cape Town','10:30')
INSERT INTO Flight VALUES ('FL0018','Singapore Airlines','Cape Town','Singapore','10:30')
INSERT INTO Flight VALUES ('FL0019','Singapore Airlines','Singapore','San Francisco','15:30')
INSERT INTO Flight VALUES ('FL0020','Singapore Airlines','San Francisco','Singapore','15:30')
INSERT INTO Flight VALUES ('FL0021','SilkAir','Singapore','Ho Chi Minh','14:30')
INSERT INTO Flight VALUES ('FL0022','SilkAir','Ho Chi Minh','Singapore','18:30')
INSERT INTO Flight VALUES ('FL0023','Singapore Airlines','Singapore','New York','06:30')



INSERT INTO FliesOn VALUES('2020-04-23','IT002','FL0004','2020-04-23')

INSERT INTO FliesOn VALUES('2020-10-15','IT003','FL0007','2020-10-15')

INSERT INTO FliesOn VALUES('2020-12-23','IT004','FL0021','2020-12-23')

INSERT INTO FliesOn VALUES('2020-02-17','IT005','FL0023','2020-02-17')

INSERT INTO FliesOn VALUES('2020-06-10','IT006','FL0001','2020-06-10')

INSERT INTO FliesOn VALUES('2020-12-11','IT007','FL0005','2020-12-11')

INSERT INTO FliesOn VALUES('2020-12-20','IT008','FL0006','2020-12-20')

INSERT INTO FliesOn VALUES('2020-01-20','IT009','FL0003','2020-01-20')

INSERT INTO FliesOn VALUES('2020-11-30','IT010','FL0019','2020-11-30')



INSERT INTO Hotel VALUES ('HL001','St Regis New York','6 Stars')
INSERT INTO Hotel VALUES ('HL002','Kempinski London','6 Stars')
INSERT INTO Hotel VALUES ('HL003','Hilton New York','4 Stars')
INSERT INTO Hotel VALUES ('HL004','Holiday Inn Cape Town','3 Stars')
INSERT INTO Hotel VALUES ('HL005','Marriott London','4 Stars')
INSERT INTO Hotel VALUES ('HL006','Four Seasons Amsterdam','4 Stars')
INSERT INTO Hotel VALUES ('HL007','Hyatt San Francisco','4 Stars')
INSERT INTO Hotel VALUES ('HL008','Sands Las Vegas','4 Stars')
INSERT INTO Hotel VALUES ('HL009','The Shard London','5 Stars')
INSERT INTO Hotel VALUES ('HL010','Hilton Paris','4 Stars')
INSERT INTO Hotel VALUES ('HL011','Marriott Paris','4 Stars')
INSERT INTO Hotel VALUES ('HL012','Crowne Plaza Sydney','3 Stars')
INSERT INTO Hotel VALUES ('HL013','Hyatt Paris','4 Stars')
INSERT INTO Hotel VALUES ('HL014','St Regis Shanghai','6 Stars')
INSERT INTO Hotel VALUES ('HL015','Shangri La Shanghai','5 Stars')


INSERT INTO StaysIn VALUES ('HL001','2020-02-17','IT001','2020-02-18','2020-02-27')
INSERT INTO StaysIn VALUES ('HL002','2020-04-23','IT002','2020-04-24','2020-04-26')
INSERT INTO StaysIn VALUES ('HL003','2020-10-15','IT003','2020-10-15','2020-10-20')
INSERT INTO StaysIn VALUES ('HL004','2020-12-23','IT004','2020-12-24','2021-12-31')
INSERT INTO StaysIn VALUES ('HL005','2020-02-17','IT005','2020-02-17','2020-03-03')
INSERT INTO StaysIn VALUES ('HL006','2020-06-10','IT006','2020-06-11','2020-05-17')
INSERT INTO StaysIn VALUES ('HL007','2020-12-11','IT007','2020-12-12','2020-12-21')
INSERT INTO StaysIn VALUES ('HL008','2020-12-20','IT008','2020-12-21','2021-01-04')
INSERT INTO StaysIn VALUES ('HL009','2020-01-20','IT009','2020-01-20','2020-02-02')
INSERT INTO StaysIn VALUES ('HL010','2020-11-30','IT010','2020-12-01','2020-12-12')


INSERT INTO Promotion VALUES ('PC001',0.25 ,'Chinese New Year Sale')
INSERT INTO Promotion VALUES ('PC002',0.5 ,'Anniversary Sale')
INSERT INTO Promotion VALUES ('PC003',0.25 ,'Christmas Sale')
INSERT INTO Promotion VALUES ('PC004',0.25 ,'December School Holiday Sale')
INSERT INTO Promotion VALUES ('PC005',0.25 ,'Great Singapore Sale')
INSERT INTO Promotion VALUES ('PC006',0.25 ,'Hari Raya Sale')
INSERT INTO Promotion VALUES ('PC007',0.35 ,'Mid Autumn Festival Sale')
INSERT INTO Promotion VALUES ('PC008',0.15 ,'June School Holiday Sale')
INSERT INTO Promotion VALUES ('PC009',0.35 ,'Deepavali Sale')
INSERT INTO Promotion VALUES ('PC010',0.25 ,'Vesak Day Sale')

INSERT INTO Enjoys VALUES ('C0001', 'B0001','PC008')
INSERT INTO Enjoys VALUES ('C0001', 'B0001','PC002')
INSERT INTO Enjoys VALUES ('C0003', 'B0003','PC004')
INSERT INTO Enjoys VALUES ('C0004', 'B0004','PC005')
INSERT INTO Enjoys VALUES ('C0004', 'B0004','PC007')
INSERT INTO Enjoys VALUES ('C0005', 'B0005','PC008')
INSERT INTO Enjoys VALUES ('C0006', 'B0006','PC007')
INSERT INTO Enjoys VALUES ('C0007', 'B0007','PC002')
INSERT INTO Enjoys VALUES ('C0007', 'B0007','PC001')
INSERT INTO Enjoys VALUES ('C0009', 'B0009','PC001')
INSERT INTO Enjoys VALUES ('C0009', 'B0009','PC010')

INSERT INTO AppliesTo VALUES ('PC002','2020-02-17','IT001')
INSERT INTO AppliesTo VALUES ('PC003','2020-04-23','IT002')
INSERT INTO AppliesTo VALUES ('PC004','2020-10-15','IT003')
INSERT INTO AppliesTo VALUES ('PC007','2020-12-23','IT004')
INSERT INTO AppliesTo VALUES ('PC007','2020-02-17','IT005')
INSERT INTO AppliesTo VALUES ('PC009','2020-06-10','IT006')
INSERT INTO AppliesTo VALUES ('PC003','2020-12-11','IT007')
INSERT INTO AppliesTo VALUES ('PC001','2020-12-20','IT008')
INSERT INTO AppliesTo VALUES ('PC004','2020-01-20','IT009')
INSERT INTO AppliesTo VALUES ('PC005','2020-11-30','IT010')


INSERT INTO Visits VALUES ('IT001','ST010')
INSERT INTO Visits VALUES ('IT002','ST009')
INSERT INTO Visits VALUES ('IT003','ST003')
INSERT INTO Visits VALUES ('IT004','ST008')
INSERT INTO Visits VALUES ('IT005','ST004')
INSERT INTO Visits VALUES ('IT006','ST001')
INSERT INTO Visits VALUES ('IT007','ST007')
INSERT INTO Visits VALUES ('IT008','ST002')
INSERT INTO Visits VALUES ('IT009','ST006')
INSERT INTO Visits VALUES ('IT010','ST005')

SELECT * FROM Staff
SELECT * FROM TourLeader
SELECT * FROM TravelAdvisor
SELECT * FROM Trip
SELECT * FROM Customer
SELECT * FROM Organiser
SELECT * FROM Passenger
SELECT * FROM Booking
SELECT * FROM Promotion
SELECT * FROM RoomType
SELECT * FROM Payment
SELECT * FROM Hotel
SELECT * FROM Flight
SELECT * FROM Itinerary
SELECT * FROM Site
SELECT * FROM City
SELECT * FROM Country
SELECT * FROM StaysIn
SELECT * FROM FliesOn
SELECT * FROM Requires
SELECT * FROM Enjoys
SELECT * FROM AppliesTo
SELECT * FROM Visits
SELECT * FROM Contact

SELECT CustEmail, CustContact,PmtType 
FROM Organiser INNER JOIN
Customer ON Customer.CustID = Organiser.CustID
INNER JOIN Booking ON Organiser.CustID = Booking.CustID
INNER JOIN Payment ON Payment.BookingNo = Booking.BookingNo
WHERE CustName = 'John'

SELECT DepartureDate, StaffName, StaffContact 
FROM TourLeader INNER JOIN
Staff ON Staff.StaffID = TourLeader.StaffID
INNER JOIN Contact ON Staff.StaffID = Contact.StaffID
INNER JOIN Trip ON TourLeader.StaffID = Trip.StaffID
ORDER BY DepartureDate ASC

SELECT SiteDesc, Country.CountryCode, Duration
FROM Site INNER JOIN City 
ON Site.CityCode =  City.CityCode
INNER JOIN Country 
ON City.CountryCode = Country.CountryCode
INNER JOIN Visits 
ON Visits.SiteID = Site.SiteID
INNER JOIN Itinerary
ON Visits.ItineraryNo = Itinerary.ItineraryNo
WHERE Duration > 5





