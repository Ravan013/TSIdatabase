CREATE DATABASE TSI;
USE TSI;


CREATE TABLE Airlines(
	Airlines_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Airlines_Number AS 'AIRL-' + CAST(Airlines_ID AS varchar(50)), 
	Airlines_Name varchar(50) NOT NULL
);


CREATE TABLE Aeroplane(
	Aeroplane_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Aeroplane_Number AS 'AERP-' + CAST(Aeroplane_ID AS varchar(50)),
	Airplane_Model varchar(250) NOT NULL,
	Capacity int NOT NULL,
	first_class_capacity int NOT NULL,
	business_class_capacity int NOT NULL,
	Premium_economy_class_capacity int NOT NULL,
	economy_class_capacity int NOT NULL,
	Airlines_ID int FOREIGN KEY REFERENCES Airlines(Airlines_ID)
);

CREATE TABLE Age_Groups(
	Age_Group_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Group_Number AS 'AGEG-' + CAST(Age_Group_ID AS varchar(50)),
	Group_Name varchar(50),
	Age_Groups varchar(50)
);

CREATE TABLE Meal_Plan(
	Meal_Plan INT IDENTITY(1, 1) PRIMARY KEY,
	ML_Plan AS 'ML-' + CAST(Meal_Plan AS varchar(50)),
	Refreshment_Mandatory varchar(50),
	Snacks_Mandatory varchar(50),
	Meal_Type varchar(50),
	Meal_Price Money,
);

CREATE TABLE Cities(
	City_ID INT IDENTITY(1, 1) PRIMARY KEY,
	City_No AS 'CT-' + CAST(City_ID AS varchar(50)),
	City_Name varchar(50) UNIQUE,
	Airport varchar(50) UNIQUE,
	Country varchar(50) UNIQUE
);

CREATE TABLE Flights(
	Flight_ID INT IDENTITY(1, 1) PRIMARY KEY,
	FL_NO AS 'FLIGHT NO:' + CAST(Flight_ID AS varchar(50)),
	Aeroplane_ID int foreign key references Aeroplane(Aeroplane_ID),
	Airlines_ID int foreign key references Airlines(Airlines_ID),
	Flight_Type varchar(50) UNIQUE, 
	Origin varchar(50) foreign key references Cities(City_Name),
	Departing_from varchar(50) foreign key references Cities(Airport),
	Destination varchar(50) foreign key references Cities(City_Name),
	Lands_At varchar(50) foreign key references Cities(Airport),
	Flight_Duration_hours int,
	Flight_Time Time,
	Flight_Date Date,
	Flight_status varchar(20) DEFAULT ('ON TIME'),
	Postponed_to DATE
);


USE TSI

CREATE TABLE class(
	Class_ID int identity(1,1) primary key,
	CL_NO AS 'Class-' + CAST(Class_ID AS varchar(50)),
	Class_Name varchar(50)
);


CREATE TABLE Fare(
	Fare_ID int identity(1,1)  primary key,
	FR_No AS 'FARE-No' + CAST(Fare_ID AS varchar(50)),
	Fare_Type varchar(20),
	Cost money,
	Flight_ID int foreign key references Flights(Flight_ID)
);


CREATE TABLE Passengers(
	Passenger_ID int IDENTITY(1,1) PRIMARY KEY,
	Psngr_ID AS 'PSNGR-' + CAST(Passenger_ID AS varchar(50)),
	P_Name varchar(50),
	P_Age int,
	P_Gender varchar(50),
	P_Phone varchar(15),
	P_Email varchar(250),
);

CREATE TABLE Airline_Services(
	Service_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Servc_ID AS 'SERVICE-' + CAST(Service_ID AS varchar(50)), 
	Servc_Name varchar(50),
	Service_cost money
);

ALTER TABLE Airline_Services ADD Airlines_ID int FOREIGN KEY REFERENCES Airlines(Airlines_ID);

CREATE TABLE Booking(
	Booking_ID INT IDENTITY(1, 1) PRIMARY KEY,
	BOOK_ID AS 'BOOK-' + CAST(Booking_ID AS varchar(50)), 
	Booked_at_date DATE,
	Booked_for_date DATE,
	Booking_Expiring_on DATE,
	Passenger_ID int foreign key references Passengers(Passenger_ID),
	Booked_by varchar(250),
	Passports_no varchar(250) UNIQUE,
	no_of_adult_seats int,
	infant_seats int,
	Smallest_Age_Group_on_list int foreign key references Age_Groups(Age_Group_ID),
	Flight_ID int foreign key references Flights(Flight_ID),
	Class_ID int foreign key references class(Class_ID),
	Service_ID int Foreign key references Airline_Services(Service_ID),
	Meal_Plan int Foreign key references Meal_Plan(Meal_Plan),
	Meal_Cost money,
	Seats_No varchar(250),
	Age_groups varchar(250),
	Fare_rate int foreign key references Fare(Fare_ID),
	Discount int,
	Total_Cost money
);


CREATE TABLE Cancellation(
	Cancellation_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Cancel_ID AS 'Cancel-' + CAST(Cancellation_ID AS varchar(50)), 
	Booking_ID int foreign key references Booking(Booking_ID),
	Booked_at_date DATE,
	Booked_for_date DATE,
	Booking_Expiring_on DATE,
	Passenger_ID int foreign key references Passengers(Passenger_ID),
	Booked_by varchar(250),
	Cancellation_date Date,
	Money_Returned money
);

CREATE TABLE Rescheduling(
	Rescheduling_ID INT IDENTITY(1, 1) PRIMARY KEY,
	Resched_ID AS 'RESCHED-' + CAST(Rescheduling_ID  AS varchar(50)),
	Booking_ID int foreign key references Booking(Booking_ID),
	Booked_at_date DATE,
	Booked_for_date DATE,
	Booking_Expiring_on DATE,
	New_Booked_at_date DATE,
	New_Booked_for_date DATE,
	New_Booking_Expiring_on DATE,
	Passenger_ID int foreign key references Passengers(Passenger_ID),
	Booked_by varchar(250),
	Passports_no varchar(250) UNIQUE,
	no_of_adult_seats int,
	infant_seats int,
	Smallest_Age_Group_on_list int foreign key references Age_Groups(Age_Group_ID),
	Flight_ID int foreign key references Flights(Flight_ID),
	Class_ID int foreign key references class(Class_ID),
	Service_ID int Foreign key references Airline_Services(Service_ID),
	Meal_Plan int Foreign key references Meal_Plan(Meal_Plan),
	Meal_Cost money,
	Seats_No varchar(250),
	Age_groups varchar(250),
	Fare_rate int foreign key references Fare(Fare_ID),
	Discount int,
	Reschedule_charge money,
	Total_Cost money
);

															/*Triggers*/
/*Trigger for member 1*/
SELECT * FROM sys.triggers;

CREATE TRIGGER delay_trigger
ON Flights
INSTEAD OF DELETE
AS
BEGIN
RAISERROR('Flight has been postponed due to technical issues. Please Wait until Further Notice. THANK YOU!!',16,10)
SELECT * FROM Flights
update Flights 
SET flight_Status ='Postpone'
FROM Flights inner join Deleted on Flights.Flight_ID= deleted.Flight_ID
END
GO

select*from Flights
Delete from Flights where Flights.Flight_ID=2


/*Trigger for member 2*/
SELECT * FROM sys.triggers;
SELECT * FROM Booking;

SELECT * FROM Cancellation;

CREATE Trigger On_Cancellation 
ON Booking	
AFTER DELETE
AS 
BEGIN SET NOCOUNT ON;
DECLARE		 @Booking_ID int,
			 @Booked_at_date date,
			 @Booked_for_date date,
			 @Booking_Expiring_on date,
			 @Passenger_ID int,
			 @Booked_by varchar(50),
			 @Cancellation_date date,
			 @Money_Returned money

SELECT       @Booking_ID= deleted.Booking_ID,			 
			 @Booked_at_date  = deleted.Booked_at_date,
			 @Booked_for_date = deleted.Booked_for_date,
			 @Booking_Expiring_on = deleted.Booking_Expiring_on,
			 @Passenger_ID = deleted.Passenger_ID,
			 @Booked_by = deleted.Booked_by,
			 @Cancellation_date = GETDATE(),
			 @Money_Returned = deleted.Total_Cost*0.8
FROM deleted

		insert into Cancellation(Booking_ID,Booked_at_date,Booked_for_date,Booking_Expiring_on, Passenger_ID, Booked_by,Cancellation_date, 
		Money_Returned)
		values(@Booking_id,@Booked_at_date,@Booked_for_date,@Booking_Expiring_on,@Passenger_ID,@Booked_by,GETDATE(),@Money_Returned)
		Print('Booking Cancelled')

		END

Delete from Booking where Booking_ID=2;

select * from Cancellation 


/*Member 3: Reschuduling Trigger */
CREATE Trigger On_Rescheduling 
ON Booking	
AFTER UPDATE
AS 
BEGIN SET NOCOUNT ON;
DECLARE		 @Booking_ID int,
			 @Booked_at_date date,
			 @Booked_for_date date,
			 @Booking_Expiring_on date,
			 @New_Booked_at_date date,
			 @New_Booked_for_date date,
			 @New_Booking_Expiring_on date,
			 @Passenger_ID int,
			 @Booked_by varchar(50),
			 @Reschedule_charge money,
			 @Total_Cost money

SELECT       @Booking_ID= inserted.Booking_ID,			 
			 @Booked_at_date  = inserted.Booked_at_date,
			 @Booked_for_date = inserted.Booked_for_date,
			 @Booking_Expiring_on = inserted.Booking_Expiring_on,
			 /*@New_Booked_at_date ,
			 @New_Booked_for_date = 
			 @New_Booking_Expiring_on*/
			 @Passenger_ID = inserted.Passenger_ID,
			 @Booked_by = inserted.Booked_by,
			 @Reschedule_charge= 0.2,
			 @Total_Cost = inserted.Total_Cost*0.2
FROM inserted
IF UPDATE(Booked_at_date)
		insert into Rescheduling(Booking_ID,Booked_at_date,Booked_for_date,Booking_Expiring_on,New_Booked_at_date,New_Booked_for_date, New_Booking_Expiring_on, Passenger_ID, 
		Booked_by,Reschedule_charge, Total_Cost)
		values(@Booking_id,@Booked_at_date,@Booked_for_date,@Booking_Expiring_on,'','','',@Passenger_ID,@Booked_by,'0.2',@Total_Cost)
		Print('Booking Rescheduled')
		END

	SELECT * FROM Rescheduling;
														/*Store Procedures*/
/*Member 1 Store Procedure*/
CREATE PROCEDURE Booking_limit @booking_limit int
AS 
	SELECT Booking.Booking_ID, Booking.Passenger_ID, (Booking.Children_no + Booking.no_of_adult_seats + Booking.infant_seats) AS totalseats 
	FROM Booking 
	WHERE ((Booking.Children_no+Booking.infant_seats+Booking.no_of_adult_seats)>@booking_limit) 
	GROUP BY Booking.Passenger_ID
GO


EXEC Booking_limit @booking_limit=5


/*Member 2 Store Procedure*/
USE TSI;

CREATE PROCEDURE PassengerPassport @passport varchar(50)
	AS 
		SELECT Booking.Passenger_ID, Booking.Booked_by, Booking.Passports_no 
		FROM Booking
		WHERE Booking.Passports_no =@passport
	GO

EXEC PassengerPassport  'PassportNO'


/*Member 3 Store Procedure*/
CREATE PROCEDURE Seats_Booked_on_Date @Flights_seats int
AS
	BEGIN

		SELECT Booking.Flight_ID, 
		Booking.Booked_by, 
		Booking.Booked_at_date, 
		Booking.Seats_No 
		FROM Booking 
		WHERE Booking.Flight_ID = @Flights_seats
		ORDER BY Flight_ID Asc
	END
GO

EXEC Booking_seats @Seats_on_Flight='1'


												/*Queries Solved*/
/*Member-1 Queires*/


  /*Question i*/

  SELECT [Flight_ID],[Flight_Date],[Origin], [Destination] FROM Flights WHERE Flights.Flight_date='2023-01-01' 

/*Question 2
Create a query which shows aircraft code, class code, AND expected revenue for each class code, along with the total revenue of each aircraft for a given airline in a one-way flight.   */

SELECT [Aeroplane_ID],[Aeroplane_Number], Class_Name, [Fare_Type], ([Class_Cost]+[Cost]) AS total_Estimated_Revenue 
FROM Airlines,Aeroplane,fare,class 
WHERE Airlines.Airlines_Name='NY Airlines' AND Fare.Fare_Type='One Way';


Use TSI

/*Question 3
Create a query which shows all passenger numbers with their corresponding descriptions of reservation status for a specific airline.*/

SELECT[Passenger_ID], Airlines_Name, Origin, Destination, Flight_Type, Flight_Date FROM Booking, Airlines,Fare,Flights 
WHERE Airlines.Airlines_Name='NY Airlines' 
AND Flight_Date='2023-01-01'
AND [Flights].[Origin]='NYC' AND [Flights].[Destination]='Kathmandu'
AND Fare.Fare_Type='One Way'; 

/*Queston 4
Create a query which shows the name of airline that has been most frequently 
travelled through by the passengers for specified source AND destination in given range of dates.*/

SELECT count(Flights.Flight_ID) AS noftravell, Airlines.Airlines_Name, Flights.Origin, Flights.Destination FROM Flights, Fare, Airlines, Aeroplane
WHERE Flights.Flight_Date BETWEEN '2022-12-18' AND '2023-01-18' AND
Flights.Origin ='NYC' AND Flights.Destination='Kathmandu' 
GROUP BY Airlines.Airlines_Name, Flights.Origin,Flights.Destination ORDER BY noftravell DESC

/*Question 5
Create a query which provides, for each age category of passengers, the following information:
The total number of infants, children, youths, adults & seniors travelling through specified flight in a single journey operated by a specified airline in given date. 
Result should contain both detailed breakup & summary for above mentioned categories along with overall summary.
*/
 SELECT CASE WHEN Passengers.P_Age <= 1 THEN 'Infants' 
	WHEN Passengers.P_Age <=12 THEN 'Children' 
	WHEN Passengers.P_Age <=17 THEN 'Youths'
	WHEN Passengers.P_Age <=54 THEN 'Adults'
	WHEN Passengers.P_Age >=55 THEN 'Seniors' ELSE 'UNKNOWN' END, 
count(CASE WHEN Passengers.P_Age <= 1 THEN 'Infants' 
	WHEN Passengers.P_Age <=12 THEN 'Children' 
	WHEN Passengers.P_Age <=17 THEN 'Youths'
	WHEN Passengers.P_Age <=54 THEN 'Adults'
	WHEN Passengers.P_Age >=55 THEN 'Seniors' ELSE 'UNKNOWN' END ) FROM Booking,Passengers WHERE Passenger_ID=Passengers.Passenger_ID AND Booking.Flight_ID 
IN (SELECT Flights.Flight_ID FROM Flights,Fare, Aeroplane,Airlines, Booking
WHERE Booking.Fare_rate=Fare.Fare_ID AND Fare.Fare_Type='One Way' AND 
Flights.Flight_Date='2023-01-01' AND Aeroplane.Aeroplane_ID=Aeroplane.Aeroplane_ID AND 
Aeroplane.Airlines_ID=Airlines.Airlines_ID AND Airlines.Airlines_Name='NY International Airlines')
GROUP BY CASE WHEN Passengers.P_Age<=1 THEN 'Infants' WHEN Passengers.P_Age <=12 
THEN 'Children' 
WHEN Passengers.P_Age <=17 THEN 'Youths' WHEN Passengers.P_Age <=54 THEN 
'Adult' WHEN Passengers.P_Age>=55 THEN 'Seniors'
ELSE 'Unknown' 
END


/*Question 6*/
SELECT count (f.flight_id) AS noofjourney,a.airline_name,ff.departure_city_id, 
ff.destination_city_id FROM flight f, fare ff
inner join airlines a ON a.airline_name = a.airline_name
GROUP BY a.airline_name,f.flight_id,ff.departure_city_id,ff.destination_city_id
ORDER BY noofjourney DESC


/*Question 7 Develop one additional query of your own which provides information that would be useful for the business. 
Marks will be awarded depending on the technical skills shown and the relevance of the query.*/

SELECT Airlines.Airlines_Name,Airlines_Number, Airplane_Model, Flights.Origin, Flights.Destination FROM Airlines, Flights, Aeroplane  
WHERE Flights.Aeroplane_ID IN (SELECT Aeroplane_ID FROM Flights); 


/*Member 2 */
/*vii. Create a query which displays flight details, such as, the aircraft code, regular fare, and discounted fare for the first class. 
A 25% discount is being offered. 
Label the columns as Aircraft, Regular First Class fare, and Discounted First Class fare. 2 */
SELECT Aeroplane.Aeroplane_Number As Aircraft, 
Fare.Cost As First_Class_Regular,
Fare.Cost*0.75 As First_Class_Discounted
From Aeroplane, Fare; 


/*ix. Create a query which displays the sorted details of flights to given city code with the least duration flight displayed first.*/
SELECT * FROM Flights
update Flights SET Flight_Duration_hours= 10 WHERE Flight_ID= 2
SELECT Flights.Flight_Date, Flights.Flight_Time, Flights.Origin, Flights.Destination,Flights.Flight_Duration_hours FROM
Flights ORDER BY Flight_Duration_hours ASC;


/*x. Create a query which displays the types of non-vegetarian meals offered on flights.*/
select * from Meal_Plan;
select Meal_Plan, Refreshment_Mandatory, Snacks_Mandatory, Meal_Type, Meal_Price from Meal_Plan where Meal_Type='Chicken';


/*xi. Create a query which shows the names of countries to which TSI provides flight reservations. 
Ensure that duplicate country names are eliminated from the list.*/
USE TSI
SELECT Distinct City_ID AS Country_ID, Country  from Cities
ORDER BY Country_ID



/*xii. Create a query which provides, for each airline, the following information:

	The total number of flights scheduled in a given date. 
	Result should contain both detailed breakup & summary for flights for each airline along with overall summary.*/

	SELECT count(Flights.Flight_ID) AS NoofFlights, Airlines.Airlines_Name, Flights.Flight_Date	FROM Flights, Airlines 
	GROUP BY Airlines.Airlines_Name, Flights.Flight_Date
	ORDER BY Flight_Date; 

	/*xiii. Create a query which shows the names of the meal options available on the given airline.*/

	SELECT Meal_Plan.Meal_Type, Airlines.Airlines_Name FROM Flights, Meal_Plan, Airlines, Aeroplane where Meal_Plan;

	/*xiv. Develop one additional query of your own which provides information that would be useful for the business. 
	Marks will be awarded depending on the technical skills shown and the relevance of the query.*/

	SELECT Booking.Passenger_ID, Flights.Flight_Date, Booking.Booked_by, Booking.Booking_Expiring_on from Booking, Flights 
	where Booking.Booking_Expiring_on <= Flights.Flight_Date;

	/*xv. Create a query which shows the minimum, maximum, and average journey hours for flights to given city code. Display column headings as, Minimum duration, Maximum duration, and Average duration respectively.
		*/
			
			SELECT MIN(Flight_Duration_hours) AS Minimum_Duration,
			MAX(Flight_Duration_hours) AS Maximum_Duration,
			AVG(Flight_Duration_hours) AS Average_Duration
			FROM Flights where Flights.Destination='KATHMANDU';

	/*xvi. Create a query which shows the journey date, number of booked seats, and class name for given passenger.*/

	SELECT * from Booking;
	SELECT Booking.Flight_ID, (no_of_adult_seats+infant_seats) AS number_of_booked_seats, Booking.Class_ID, Booking.Booked_by
	FROM Booking, class
	WHERE Booking.Passenger_ID='1' 


	/*xvii. Create a query which shows the names of meals not requested by any passenger.*/

	SELECT Meal_Plan.Meal_Type 
	from Booking, Meal_Plan
	where not exists (
    select * from Booking
        where Booking.Meal_Plan= Meal_Plan.Meal_Plan
          )


	/*xviii. Create a query which shows the details of passengers booked through a specified airline in a given date for multi-city flights.*/

	SELECT Passengers.Passenger_ID, Passengers.P_Name, Passengers.P_Gender, Passengers.P_Age, Passengers.P_Phone, Passengers.P_Email, [Passports_no], 
	Booking.Flight_ID, Fare.[Fare_Type]
	FROM Passengers, Booking, Fare where Booking.Fare_rate='2' and Fare.Fare_Type='Two Way' and Booking.Booked_for_date='2023-02-01'; 

 

/*xix Create a query which provides, for each airline, the following information:

	The total number of unaccompanied children travelling in a given date. 
	Result should contain both detailed breakup & summary for unaccompanied children for each airline along with overall summary.
*/

SELECT Booking.Flight_ID, Airlines.Airlines_ID, Airlines.Airlines_Name, sum(Children_No) as Unaccompanied_Children 
FROM Booking 
INNER JOIN Flights on Booking.Flight_ID = Flights.Flight_ID
INNER JOIN Airlines on Flights.Flight_ID = Airlines.Airlines_ID
where Booking.no_of_adult_seats='0'and Booking.Children_No='0' and Booking.Booked_for_date='2023-03-08' 
GROUP BY Airlines.Airlines_ID;


/*xx. Create a query which shows the details of passengers who have availed any extra services for a given flight on specified date. */
select Booking.Passenger_ID, Booking.Booked_by, Passports_No, Booking.Flight_ID, Passengers.P_Age, Passengers.P_Gender, Passengers.P_Phone, 
Airline_Services.Servc_Name
from Booking
INNER JOIN Passengers ON Booking.[Passenger_ID]=[Passengers].[Passenger_ID]
INNER JOIN Airline_Services ON Booking.Service_ID= Airline_Services.Service_ID
Where Booking.Service_ID != '1' and Booking.Booked_for_date='2023-03-08';




/*xxi. Develop one additional query of your own which provides information that would be useful for the business. 
Marks will be awarded depending on the technical skills shown and the relevance of the query.*/

SELECT Booking.Booking_ID, Booking.BOOK_ID AS Valid_Tickets, Booked_by, Booked_at_date 
FROM BOOKING
WHERE Booking.Booking_Expiring_on > GETDATE();
