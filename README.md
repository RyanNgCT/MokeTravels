# MokeTravels
Database for Database Module Assignment 1

The Objective of this assignment was to design a Relational Database Management System for a Travel Agency.

## Requirements
Microsoft SQL Server

## Entity Relationship Diagram:
![ER Diagram](https://user-images.githubusercontent.com/48358569/89703026-99091180-d979-11ea-8fae-89e7f7f028a4.jpg)

## Additional Queries to Test Database 
1. List the email address, contact number and the payment type that a particular organiser (“John”) uses when paying for the booking.

```
SELECT CustEmail, CustContact,PmtType 
FROM Organiser INNER JOIN
Customer ON Customer.CustID = Organiser.CustID
INNER JOIN Booking ON Organiser.CustID = Booking.CustID
INNER JOIN Payment ON Payment.BookingNo = Booking.BookingNo
WHERE CustName = 'John'
```
2. List tour departure date, tour leader name and contact number, sorted according to the tour start date.
```
SELECT DepartureDate, StaffName, StaffContact 
FROM TourLeader INNER JOIN
Staff ON Staff.StaffID = TourLeader.StaffID
INNER JOIN Contact ON Staff.StaffID = Contact.StaffID
INNER JOIN Trip ON TourLeader.StaffID = Trip.StaffID
ORDER BY DepartureDate ASC
```
3. List the SiteDesc of a particular site and its corresponding country code and duration for a particular itinerary where the duration of visit is more than 5 hours.
```
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
```

## Contributors:
Matthias Gan, Hannah Leong, Ezra Ho, Lim Shermann
