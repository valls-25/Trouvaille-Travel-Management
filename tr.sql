create database trouvaille;
use trouvaille;

-- table1
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    FullName VARCHAR(101), -- Composite attribute
    DOB DATE,
    Gender VARCHAR(10),
    Nationality VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Address TEXT,
    Username VARCHAR(50) UNIQUE
);
DELIMITER //

CREATE TRIGGER set_fullname_before_insert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
  SET NEW.FullName = CONCAT(NEW.FirstName, ' ', NEW.LastName);
END;
//

DELIMITER ;
DELIMITER //
CREATE TRIGGER update_fullname_before_update
BEFORE UPDATE ON Users
FOR EACH ROW
BEGIN
  SET NEW.FullName = CONCAT(NEW.FirstName, ' ', NEW.LastName);
END;
//
DELIMITER ;
INSERT INTO Users (FirstName, LastName, DOB, Gender, Nationality, Email, PhoneNumber, Address, Username)
VALUES ('John', 'Doe', '2000-05-15', 'Male', 'USA', 'john.doe@example.com', '1234567890', '123 Main St', 'johndoe123');
SELECT * FROM Users;

truncate table Users;

-- table2
CREATE TABLE Destinations (
    DestinationID INT UNSIGNED NOT NULL AUTO_INCREMENT, -- Unique identifier for each destination
    Country VARCHAR(100) NOT NULL,                     -- Name of the country
    City VARCHAR(100) NOT NULL,                        -- Name of the city
    PRIMARY KEY (DestinationID)                        -- Define DestinationID as the primary key
);

-- table 3
CREATE TABLE Hotels (
    HotelId INT PRIMARY KEY AUTO_INCREMENT,       -- Unique ID for each hotel
    DestinationID INT UNSIGNED NOT NULL,          -- Not null foreign key referencing Destinations
    Name VARCHAR(100),                            -- Name of the hotel
    Location VARCHAR(255),                        -- Address or locality
    Rating DECIMAL(2,1),                          -- Rating (e.g., 4.5)
    Images TEXT,                                  -- URLs or filenames of hotel images
    Room_Type ENUM('Deluxe', 'Suite'), -- Room type (e.g., Suite, Deluxe)
    Price_Per_Night DECIMAL(10,2),                -- Cost per night
    Amenities TEXT,                               -- Amenities (e.g., "WiFi, Pool")
    Availability_Status VARCHAR(20),              -- Availability (e.g., "Available", "Full")

    -- Foreign key with cascading delete
    FOREIGN KEY (DestinationID)
        REFERENCES Destinations(DestinationID)
        ON DELETE CASCADE
);

-- table 4
CREATE TABLE Flights (
    FlightID INT UNSIGNED NOT NULL AUTO_INCREMENT, -- Unique identifier for each specific flight instance
    SourceAirport VARCHAR(100) NOT NULL,           -- Name or code of the source airport (Consider FK to an Airports table)
    DestinationAirport VARCHAR(100) NOT NULL,      -- Name or code of the destination airport (Consider FK to an Airports table)
    Airline VARCHAR(100) NOT NULL,                 -- Name of the airline (Consider FK to an Airlines table)
    FlightNumber VARCHAR(10) NOT NULL,             -- Airline-specific flight number (e.g., 'BA287')
    DepartureDateTime DATETIME NOT NULL,           -- Scheduled departure date and time
    ArrivalDateTime DATETIME NOT NULL,             -- Scheduled arrival date and time
    DurationMinutes INT UNSIGNED NULL,             -- Flight duration in minutes (can be calculated, hence potentially NULL)
    TicketClass ENUM('Economy', 'Business', 'First') NOT NULL, -- Class of service for this specific price/availability entry
    Price DECIMAL(10, 2) UNSIGNED NOT NULL,        -- Price for this ticket class on this flight
    Availability INT UNSIGNED NOT NULL DEFAULT 0,  -- Number of available seats for this specific class and price
    PRIMARY KEY (FlightID)                         -- Define FlightID as the primary key
    /* Indexes for common lookups: 
    INDEX idx_departure_datetime (DepartureDateTime),
    INDEX idx_source_dest (SourceAirport, DestinationAirport),
    INDEX idx_airline_flight_num (Airline, FlightNumber) */
);


-- table 5
CREATE TABLE Cruises (
    CruiseID INT PRIMARY KEY AUTO_INCREMENT,       -- Unique ID for each cruise
    CruiseName VARCHAR(100) NOT NULL,              -- Name of the cruise
    SourcePort VARCHAR(100) NOT NULL,              -- Departure port
    DestinationPort VARCHAR(100) NOT NULL,         -- Arrival port
    DepartureDateTime DATETIME NOT NULL,           -- Departure date and time
    ArrivalDateTime DATETIME NOT NULL,             -- Arrival date and time
    Duration INT,                                   -- Duration in hours or days
    CabinType ENUM('Standard', 'Deluxe', 'Balcony'), -- Valid cabin types
    Price DECIMAL(10,2),                            -- Base price
    Availability VARCHAR(20)                       -- 'Available', 'Full', etc.
);

-- table 6
CREATE TABLE Rental (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,              -- Unique identifier for each rental
    SourceLocation VARCHAR(100) NOT NULL,                 -- Pickup location
    DestinationLocation VARCHAR(100) NOT NULL,            -- Drop-off location
    RentalType ENUM('Car', 'Bike', 'Scooter') NOT NULL, -- Type of vehicle
    RentalCompany VARCHAR(100) NOT NULL,                  -- Company offering the rental
    PricePerDay DECIMAL(10,2) NOT NULL,                   -- Daily rental price
    Availability VARCHAR(20)                              -- e.g., 'Available', 'Not Available'
);

-- table 7
CREATE TABLE Trains (
    TrainID INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- Unique identifier for each specific train offering
    SourceStation VARCHAR(150) NOT NULL,           -- Name of the source station 
    DestinationStation VARCHAR(150) NOT NULL,      -- Name of the destination station 
    TrainName VARCHAR(100) NULL,                   -- Descriptive name of the train service (e.g., "InterCity Express"), can be NULL if not applicable
    TrainNumber VARCHAR(20) NOT NULL,              -- Official train number assigned by the operator (e.g., '12951', 'EC172')
    DepartureDateTime DATETIME NOT NULL,           -- Scheduled departure date and time
    ArrivalDateTime DATETIME NOT NULL,             -- Scheduled arrival date and time
    DurationMinutes INT UNSIGNED NULL,             -- Journey duration in minutes (can be calculated, hence potentially NULL)
    TicketClass VARCHAR(50) NOT NULL,              -- Class of service (e.g., 'First Class', 'Second Class', 'Sleeper', 'AC Chair Car'). Using VARCHAR for flexibility, but ENUM could also work if classes are strictly defined.
    Price DECIMAL(10, 2) UNSIGNED NOT NULL,        -- Price for this ticket class on this train journey
    Availability INT UNSIGNED NOT NULL DEFAULT 0,  -- Number of available seats/berths for this specific class and price
    PRIMARY KEY (TrainID)                          -- Define TrainID as the primary key
    /*
    -- Optional but recommended indexes for common searches:
    INDEX idx_departure_datetime (DepartureDateTime),
    INDEX idx_source_dest (SourceStation, DestinationStation),
    INDEX idx_train_num (TrainNumber)
    */
);

-- table 8
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,      -- Unique ID for each review
    UserID INT NOT NULL,                          -- Foreign key referencing the Users table
    Rating DECIMAL(2,1) NOT NULL,                 -- Rating score, e.g., 4.5

    -- Set up the foreign key constraint
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- table 9
CREATE TABLE Packages (
    PackageID INT PRIMARY KEY AUTO_INCREMENT,                   -- Unique ID for each package
    PackageName ENUM('Solo Traveller', 'Luxuria') NOT NULL,     -- Type of package
    DestinationID INT UNSIGNED NOT NULL,                        -- Foreign key to Destinations table
    Description TEXT,                                           -- Description of the package
    Price DECIMAL(10,2) UNSIGNED NOT NULL,                      -- Non-negative price of the package

    -- Foreign key constraint
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- table 10
CREATE TABLE Activities (
    ActivityID INT PRIMARY KEY AUTO_INCREMENT,              -- Unique ID for each activity or event
    DestinationID INT UNSIGNED NOT NULL,                    -- Foreign key referencing Destinations table
    ActivityName VARCHAR(100) NOT NULL,                     -- Name of the event or activity
    ActivityDate DATE NOT NULL,                             -- Date of the event or activity
    ActivityType VARCHAR(50),                               -- Type of activity (e.g., Cultural, Adventure, Show)
    Description TEXT,                                       -- Details about the activity
    TicketPrice DECIMAL(10,2) UNSIGNED,                     -- Non-negative ticket price

    -- Foreign key constraint
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- table 11
CREATE TABLE CustomerSupport (
    SupportID INT UNSIGNED NOT NULL AUTO_INCREMENT,    -- Unique identifier for each support query/ticket
    UserID INT NOT NULL,                     -- Foreign key linking to the Users table
    QueryType VARCHAR(100) NOT NULL,                  -- Type/category of the query (e.g., 'Billing', 'Technical', 'Booking Inquiry', 'Feedback')
    QueryDescription TEXT NOT NULL,                    -- The detailed description of the user's query or issue
    QueryDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Date and time when the query was submitted
    ResolutionStatus ENUM('Open', 'In Progress', 'Resolved', 'Closed', 'Waiting for Customer', 'Escalated') NOT NULL DEFAULT 'Open', -- Current status of the support ticket

    PRIMARY KEY (SupportID),                          -- Define SupportID as the primary key

    -- Define the foreign key constraint (assuming you have a Users table)
    CONSTRAINT fk_support_user_ref -- Renamed constraint for clarity
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID)     -- ** IMPORTANT: Replace 'Users' and 'UserID' with your actual user table name and its primary key column name **
        ON DELETE RESTRICT          -- Prevent deleting a user if they have associated support tickets
        ON UPDATE CASCADE

    /*-- Optional indexes for performance
    INDEX idx_support_user (UserID),                   -- Index on the foreign key
    INDEX idx_support_status (ResolutionStatus),       -- Index for filtering by status
    INDEX idx_support_query_type (QueryType),          -- Index for filtering by query type
    INDEX idx_support_query_date (QueryDate)           -- Index for sorting/filtering by date*/
);

-- table 12
CREATE TABLE Weather (
    DestinationID INT UNSIGNED NOT NULL,         -- Foreign key referencing Destinations table
    WeatherDate DATE NOT NULL,                   -- Date for the weather record
    Temperature DECIMAL(4,1),                    -- Temperature in Celsius (e.g., 32.5)
    Conditions ENUM(
        'Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy',
        'Stormy', 'Snowy', 'Windy', 'Foggy'
    ),                                           -- Standardized weather condition
    Humidity TINYINT UNSIGNED,                   -- Humidity percentage (0-100)
    Precipitation DECIMAL(4,1),                  -- Precipitation in mm
    WindSpeed DECIMAL(4,1),                      -- Wind speed in km/h or m/s
    UVIndex TINYINT UNSIGNED,                    -- UV Index (typically 0–11+)
    AQI SMALLINT UNSIGNED,                       -- Air Quality Index (0–500)

    -- Composite Primary Key (one record per destination per date)
    PRIMARY KEY (DestinationID, WeatherDate),

    -- Foreign key constraint
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- table 13
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,          -- Unique ID for each payment
    UserID INT,                                        -- Foreign key referencing Users
    BankDetails VARCHAR(255),                          -- Bank or card info (masked)
    PaymentMethod VARCHAR(50),                         -- e.g., UPI, Credit Card, etc.
    TransactionDate DATE,                              -- Date of transaction
    TransactionAmount DECIMAL(10, 2),                  -- Transaction amount
    PaymentStatus ENUM('Pending', 'Completed', 'Failed', 'Refunded', 'Cancelled'),  -- Payment status
    BookingID INT,                                     -- Optional link to Booking
    
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

-- table 14
CREATE TABLE Refunds (
    RefundID INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each refund
    UserID INT,                                      -- Foreign key referencing Users
    RefundReason VARCHAR(255),                       -- Reason for the refund (e.g., "Flight cancelled")
    RefundAmount DECIMAL(10, 2),                     -- Amount refunded
    RefundDate DATE,                                 -- Date the refund was issued
    RefundStatus VARCHAR(50),                        -- Status like 'Processed', 'Pending', 'Rejected'

    -- Link to Users table with cascade on delete
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
ALTER TABLE Refunds
MODIFY COLUMN RefundStatus ENUM('Processed', 'Pending', 'Rejected');
-- table 15
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY AUTO_INCREMENT,        -- Unique ID for each insurance
    UserID INT,                                        -- Foreign key referencing Users
    InsuranceProvider VARCHAR(100),                    -- Name of the provider
    PolicyNumber VARCHAR(100),                         -- Unique policy number
    CoverageAmount DECIMAL(10, 2),                     -- Coverage value
    InsuranceStatus ENUM('Active', 'Expired', 'Pending', 'Cancelled'),  -- Status of insurance
    BookingID INT,                                     -- Optional link to Booking

    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

ALTER TABLE Insurance
MODIFY COLUMN InsuranceStatus ENUM('Active', 'Expired', 'Pending', 'Cancelled');

-- table 16
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each booking
    UserID INT NOT NULL,                              -- User who made the booking
    DestinationID INT UNSIGNED NOT NULL,              -- Destination booked
    HotelBookingID INT,                               -- Optional hotel booking
    FlightsBookingID INT UNSIGNED,                    -- Optional flight booking
    TrainsBookingID INT UNSIGNED,                     -- Optional train booking
    CruisesBookingID INT,                             -- Optional cruise booking
    RentalBookingID INT,                              -- Optional rental service
    ItineraryID INT,                                  -- Optional itinerary reference
    PaymentID INT,                                    -- Will be linked later via ALTER
    InsuranceID INT,                                  -- Will be linked later via ALTER
    RefundID INT,                                     -- Will be linked later via ALTER

    -- Foreign key constraints to various booking types
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE,
    FOREIGN KEY (HotelBookingID) REFERENCES Hotels(HotelID) ON DELETE SET NULL,
    FOREIGN KEY (FlightsBookingID) REFERENCES Flights(FlightID) ON DELETE SET NULL,
    FOREIGN KEY (TrainsBookingID) REFERENCES Trains(TrainID) ON DELETE SET NULL,
    FOREIGN KEY (CruisesBookingID) REFERENCES Cruises(CruiseID) ON DELETE SET NULL,
    FOREIGN KEY (RentalBookingID) REFERENCES Rental(RentalID) ON DELETE SET NULL
    -- Payment, Insurance, and Refund foreign keys are added via ALTER statements
);

-- Add link between Refunds and Bookings
ALTER TABLE Refunds
ADD COLUMN BookingID INT,                                   
ADD CONSTRAINT fk_refund_booking 
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE;

-- table 17
CREATE TABLE Feedback (
  FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
  Username VARCHAR(50),
  Comment TEXT NOT NULL,
  SubmittedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
select * from Feedback;
DELETE F
FROM Feedback F
JOIN (SELECT MAX(FeedbackID) AS max_id FROM Feedback) AS subquery
ON F.FeedbackID = subquery.max_id;

-- Deletes the row with the maximum FeedbackID using a JOIN 
-- with the subquery that identifies the max FeedbackID inserting values

INSERT INTO Users (FirstName, LastName, DOB, Gender, Nationality, Email, PhoneNumber, Address, Username) VALUES
('Rachel', 'Green', '1995-04-12', 'Female', 'USA', 'rachel.green@centralperk.com', '15551234', '90 Bedford St, New York, NY', 'rachel_g'),
('Ross', 'Geller', '1990-08-22', 'Male', 'USA', 'ross.geller@museum.com', '15555678', '10 Washington Square, NY', 'rossg'),
('Monica', 'Geller', '1992-12-05', 'Female', 'USA', 'monica.geller@chefmail.com', '15558765', '345 Grove St, NY', 'monica_g'),
('Chandler', 'Bing', '1988-03-19', 'Male', 'USA', 'chandler.bing@wecusemail.com', '15559012', '55 Commerce St, NY', 'chandlrb'),
('Joey', 'Tribbiani', '1997-07-14', 'Male', 'USA', 'joey.tribbiani@howudoing.tv', '15552345', '234 Jump St, NY', 'joeyt'),
('Phoebe', 'Buffay', '1993-11-25', 'Female', 'USA', 'phoebe.buffay@smellycat.org', '15554321', '202 Bleecker St, NY', 'phoebe_b'),
('Jim', 'Halpert', '1991-06-30', 'Male', 'USA', 'jim.halpert@dundermifflin.com', '15557777', 'Scranton, PA', 'big_tuna'),
('Pam', 'Beesly', '1996-01-09', 'Female', 'USA', 'pam.beesly@dundermifflin.com', '15558888', 'Scranton, PA', 'pam_bee'),
('Dwight', 'Schrute', '1994-10-10', 'Male', 'USA', 'dwight.schrute@beetfarm.biz', '15559999', 'Schrute Farms, PA', 'dwight_kgb'),
('Michael', 'Scott', '1989-05-03', 'Male', 'USA', 'michael.scott@dundermifflin.com', '15550000', 'Scranton, PA', 'worldsbestboss'),
('Jake', 'Peralta', '1998-09-27', 'Male', 'USA', 'jake.peralta@nypd99.gov', '15551111', 'Brooklyn, NY', 'noice99'),
('Amy', 'Santiago', '1990-02-15', 'Female', 'USA', 'amy.santiago@nypd99.gov', '15552222', 'Brooklyn, NY', 'amys99'),
('Terry', 'Jeffords', '1993-05-18', 'Male', 'USA', 'terry.jeffords@nypd99.gov', '15553333', 'Brooklyn, NY', 'terrylove'),
('Kendall', 'Roy', '1992-07-20', 'Male', 'USA', 'kendall.roy@waystar.com', '15554444', 'Manhattan, NY', 'kendall_r'),
('Shiv', 'Roy', '1995-03-11', 'Female', 'USA', 'shiv.roy@waystar.com', '15555555', 'Manhattan, NY', 'shivroy');

SELECT * FROM Users;

INSERT INTO Destinations (Country, City) VALUES
('France', 'Paris'),
('Italy', 'Venice'),
('Japan', 'Kyoto'),
('Greece', 'Santorini'),
('USA', 'New York'),
('Brazil', 'Rio de Janeiro'),
('Thailand', 'Bangkok'),
('Spain', 'Barcelona'),
('Australia', 'Sydney'),
('Morocco', 'Marrakech'),
('Canada', 'Vancouver'),
('Switzerland', 'Zurich'),
('Netherlands', 'Amsterdam'),
('UAE', 'Dubai'),
('South Africa', 'Cape Town');
SELECT * FROM Destinations;


INSERT INTO Hotels (DestinationID, Name, Location, Rating, Images, Room_Type, Price_Per_Night, Amenities, Availability_Status) VALUES
(1, 'Eiffel Elegance Hotel', '7 Rue de l’Amour, Paris', 4.8, 'eiffel1.jpg', 'Suite', 320.00, 'WiFi, Spa, Rooftop Bar, Concierge', 'Available'),
(2, 'Venetian Dreams Resort', 'Canal View, Venice', 4.6, 'venice2.jpg', 'Deluxe', 280.00, 'WiFi, Gondola Dock, Romantic Dinners', 'Available'),
(3, 'Zen Garden Inn', 'Philosopher’s Path, Kyoto', 4.7, 'kyoto3.jpg', 'Suite', 250.00, 'WiFi, Onsen, Tea Room', 'Available'),
(4, 'Santorini Sunset Villas', 'Cliffside, Santorini', 4.9, 'santorini4.jpg', 'Suite', 450.00, 'WiFi, Infinity Pool, Sea View', 'Full'),
(5, 'Empire Bliss Hotel', '5th Avenue, New York', 4.5, 'ny5.jpg', 'Deluxe', 300.00, 'WiFi, Gym, Rooftop Lounge', 'Available'),
(6, 'Copacabana Charm Inn', 'Beachfront, Rio de Janeiro', 4.4, 'rio6.jpg', 'Suite', 220.00, 'WiFi, Beach Access, Samba Nights', 'Available'),
(7, 'Lotus Palace', 'Riverside, Bangkok', 4.3, 'bangkok7.jpg', 'Deluxe', 180.00, 'WiFi, Floating Market Tours', 'Available'),
(8, 'Gaudí Garden Hotel', 'La Rambla, Barcelona', 4.6, 'barcelona8.jpg', 'Suite', 260.00, 'WiFi, Art Tours, Tapas Bar', 'Available'),
(9, 'Harbor Lights Inn', 'Circular Quay, Sydney', 4.7, 'sydney9.jpg', 'Deluxe', 330.00, 'WiFi, Opera House View', 'Available'),
(10, 'Sahara Starlight Hotel', 'Old Medina, Marrakech', 4.5, 'marrakech10.jpg', 'Suite', 200.00, 'WiFi, Hammam, Rooftop Dining', 'Available'),
(11, 'Maple Leaf Suites', 'Waterfront, Vancouver', 4.4, 'vancouver11.jpg', 'Deluxe', 240.00, 'WiFi, Ski Packages, Spa', 'Available'),
(12, 'Alpine Romance Chalet', 'Mountain View, Zurich', 4.9, 'zurich12.jpg', 'Suite', 370.00, 'WiFi, Fireplace, Chocolate Basket', 'Full'),
(13, 'Tulip Inn Amsterdam', 'Canal Side, Amsterdam', 4.3, 'amsterdam13.jpg', 'Deluxe', 210.00, 'WiFi, Bike Rental, Breakfast Included', 'Available'),
(14, 'Skyline Pearl', 'Palm Jumeirah, Dubai', 4.8, 'dubai14.jpg', 'Suite', 500.00, 'WiFi, Private Beach, Butler Service', 'Available'),
(15, 'Cape Romance Retreat', 'Table Mountain View, Cape Town', 4.6, 'capetown15.jpg', 'Suite', 290.00, 'WiFi, Safari Bookings, Wine Tastings', 'Available');
SELECT * FROM Hotels;

INSERT INTO Flights (
    SourceAirport, DestinationAirport, Airline, FlightNumber, DepartureDateTime,
    ArrivalDateTime, DurationMinutes, TicketClass, Price, Availability
) VALUES
('JFK', 'CDG', 'Air France', 'AF011', '2025-05-01 19:00:00', '2025-05-02 08:00:00', 420, 'Business', 1350.00, 20),
('LAX', 'HND', 'Japan Airlines', 'JL061', '2025-05-03 12:30:00', '2025-05-04 16:45:00', 675, 'Economy', 900.00, 45),
('LHR', 'DXB', 'Emirates', 'EK002', '2025-05-05 22:00:00', '2025-05-06 07:20:00', 500, 'First', 3000.00, 5),
('SYD', 'AKL', 'Qantas', 'QF143', '2025-05-07 09:00:00', '2025-05-07 14:00:00', 180, 'Economy', 250.00, 60),
('FCO', 'JFK', 'Delta', 'DL243', '2025-05-08 10:15:00', '2025-05-08 13:45:00', 570, 'Business', 1700.00, 18),
('DXB', 'BOM', 'Emirates', 'EK506', '2025-05-09 03:30:00', '2025-05-09 08:10:00', 280, 'Economy', 480.00, 55),
('CDG', 'CPT', 'Air France', 'AF870', '2025-05-10 21:50:00', '2025-05-11 08:00:00', 730, 'Business', 1950.00, 10),
('JNB', 'NBO', 'Kenya Airways', 'KQ765', '2025-05-11 07:00:00', '2025-05-11 09:15:00', 135, 'Economy', 220.00, 40),
('HND', 'SIN', 'Singapore Airlines', 'SQ633', '2025-05-12 00:10:00', '2025-05-12 06:30:00', 380, 'First', 2800.00, 8),
('SFO', 'LHR', 'British Airways', 'BA284', '2025-05-13 15:45:00', '2025-05-14 09:05:00', 640, 'Business', 2000.00, 12),
('YYZ', 'MEX', 'Air Canada', 'AC991', '2025-05-14 13:30:00', '2025-05-14 18:45:00', 315, 'Economy', 420.00, 35),
('MIA', 'HAV', 'American Airlines', 'AA817', '2025-05-15 11:15:00', '2025-05-15 12:25:00', 70, 'Economy', 199.00, 70),
('IST', 'ATH', 'Turkish Airlines', 'TK1843', '2025-05-16 09:20:00', '2025-05-16 11:00:00', 100, 'Economy', 150.00, 45),
('BKK', 'HKG', 'Thai Airways', 'TG638', '2025-05-17 14:30:00', '2025-05-17 18:45:00', 255, 'Business', 720.00, 25),
('LAX', 'SYD', 'Qantas', 'QF12', '2025-05-18 22:00:00', '2025-05-20 06:15:00', 900, 'First', 3600.00, 6);
SELECT * FROM Flights;


INSERT INTO Cruises (
    CruiseName, SourcePort, DestinationPort, DepartureDateTime, ArrivalDateTime,
    Duration, CabinType, Price, Availability
) VALUES
('Mediterranean Magic', 'Barcelona', 'Athens', '2025-06-01 16:00:00', '2025-06-07 08:00:00', 144, 'Deluxe', 1299.99, 'Available'),
('Caribbean Escape', 'Miami', 'Bahamas', '2025-06-03 12:00:00', '2025-06-06 10:00:00', 70, 'Balcony', 999.50, 'Available'),
('Baltic Bliss', 'Copenhagen', 'St. Petersburg', '2025-06-10 18:00:00', '2025-06-15 09:00:00', 115, 'Standard', 890.00, 'Full'),
('Pacific Romance', 'Los Angeles', 'Vancouver', '2025-06-05 15:30:00', '2025-06-08 07:45:00', 64, 'Balcony', 1150.75, 'Available'),
('Alaskan Dream', 'Seattle', 'Juneau', '2025-06-09 13:00:00', '2025-06-13 11:00:00', 94, 'Deluxe', 1450.25, 'Available'),
('Adriatic Love Voyage', 'Venice', 'Dubrovnik', '2025-06-14 17:00:00', '2025-06-18 08:30:00', 87, 'Standard', 770.00, 'Available'),
('Romantic Nile Cruise', 'Luxor', 'Aswan', '2025-06-20 08:00:00', '2025-06-23 10:00:00', 74, 'Deluxe', 650.00, 'Full'),
('Scandinavian Wonder', 'Stockholm', 'Oslo', '2025-06-25 10:00:00', '2025-06-29 09:00:00', 95, 'Balcony', 980.90, 'Available'),
('Island Serenity', 'Singapore', 'Bali', '2025-07-01 14:00:00', '2025-07-05 06:00:00', 88, 'Standard', 1020.00, 'Available'),
('Amazon River Whisper', 'Manaus', 'Belém', '2025-07-03 09:00:00', '2025-07-08 17:00:00', 128, 'Deluxe', 1355.00, 'Full'),
('Heart of the Fjords', 'Bergen', 'Geiranger', '2025-07-06 11:00:00', '2025-07-09 12:30:00', 73, 'Balcony', 1100.00, 'Available'),
('Indian Ocean Retreat', 'Male', 'Colombo', '2025-07-10 16:00:00', '2025-07-13 07:00:00', 63, 'Standard', 780.50, 'Available'),
('Greek Island Odyssey', 'Santorini', 'Mykonos', '2025-07-15 13:00:00', '2025-07-19 10:00:00', 91, 'Deluxe', 1185.00, 'Full'),
('South China Sea Romance', 'Hong Kong', 'Da Nang', '2025-07-20 17:00:00', '2025-07-25 08:00:00', 115, 'Balcony', 1270.40, 'Available'),
('Panama Canal Passion', 'San Diego', 'Miami', '2025-07-28 12:00:00', '2025-08-03 14:00:00', 150, 'Deluxe', 1599.99, 'Available');

SELECT * FROM Cruises;

INSERT INTO Rental (
    SourceLocation, DestinationLocation, RentalType, RentalCompany, PricePerDay, Availability
) VALUES
('New York', 'Boston', 'Car', 'Hertz', 65.00, 'Available'),
('Los Angeles', 'San Diego', 'Bike', 'Zoom Rentals', 20.00, 'Available'),
('Chicago', 'Chicago', 'Scooter', 'RideNow', 15.50, 'Not Available'),
('Houston', 'Dallas', 'Car', 'Enterprise', 58.75, 'Available'),
('Miami', 'Orlando', 'Car', 'Avis', 70.00, 'Available'),
('San Francisco', 'Los Angeles', 'Bike', 'CityWheels', 18.00, 'Available'),
('Seattle', 'Portland', 'Car', 'Budget', 62.00, 'Available'),
('Denver', 'Boulder', 'Scooter', 'Spin', 12.00, 'Not Available'),
('Atlanta', 'Savannah', 'Car', 'National', 66.25, 'Available'),
('Las Vegas', 'Phoenix', 'Bike', 'BoltRides', 22.00, 'Available'),
('Boston', 'New York', 'Scooter', 'GoScoot', 14.00, 'Available'),
('Philadelphia', 'Baltimore', 'Car', 'Thrifty', 55.00, 'Available'),
('Detroit', 'Chicago', 'Car', 'Alamo', 60.00, 'Not Available'),
('Austin', 'San Antonio', 'Bike', 'EasyRide', 19.50, 'Available'),
('San Jose', 'San Francisco', 'Scooter', 'QuickMove', 13.75, 'Available');

SELECT * FROM Rental;

INSERT INTO Trains (
    SourceStation, DestinationStation, TrainName, TrainNumber,
    DepartureDateTime, ArrivalDateTime, DurationMinutes,
    TicketClass, Price, Availability
) VALUES
-- France
('Paris Gare de Lyon', 'Lyon Part-Dieu', 'TGV INOUI', 'TGV8801',
 '2025-04-24 09:00:00', '2025-04-24 11:00:00', 120, 'First Class', 110.00, 60),
('Paris Gare du Nord', 'Lille Europe', 'Eurostar', 'EUR221',
 '2025-05-01 10:00:00', '2025-05-01 10:59:00', 59, 'Second Class', 45.00, 80),

-- Australia
('Sydney Central', 'Melbourne Southern Cross', 'XPT Express', 'XPT291',
 '2025-04-25 06:00:00', '2025-04-25 14:00:00', 480, 'Business Class', 140.00, 25),
('Brisbane Roma St', 'Rockhampton', 'Tilt Train', 'TT893',
 '2025-04-30 08:00:00', '2025-04-30 13:30:00', 330, 'Economy', 95.00, 40),

-- USA
('New York Penn Station', 'Washington Union Station', 'Amtrak Acela', 'AC239',
 '2025-04-26 07:30:00', '2025-04-26 10:10:00', 160, 'Business Class', 130.00, 70),
('Chicago Union Station', 'St. Louis Gateway', 'Lincoln Service', 'LS311',
 '2025-04-27 13:00:00', '2025-04-27 17:30:00', 270, 'Coach', 65.00, 100),
('Los Angeles Union', 'San Diego', 'Pacific Surfliner', 'PS401',
 '2025-05-03 08:45:00', '2025-05-03 11:30:00', 165, 'First Class', 85.00, 55),

-- India
('New Delhi', 'Mumbai Central', 'Rajdhani Express', '12952',
 '2025-04-26 16:00:00', '2025-04-27 08:00:00', 960, 'AC Chair Car', 85.00, 90),
('Howrah', 'Chennai Central', 'Coromandel Express', '12841',
 '2025-05-02 14:00:00', '2025-05-03 07:30:00', 1020, 'Sleeper', 55.00, 120),
('Ahmedabad', 'Jaipur', 'Garib Rath', '12989',
 '2025-05-04 21:00:00', '2025-05-05 07:00:00', 600, 'Third AC', 40.00, 75),

-- UK
('London King\'s Cross', 'Edinburgh Waverley', 'LNER Azuma', 'AZM123',
 '2025-04-27 07:30:00', '2025-04-27 11:15:00', 225, 'First Class', 115.00, 50),
('Manchester Piccadilly', 'London Euston', 'Avanti West Coast', 'AWC155',
 '2025-05-01 08:15:00', '2025-05-01 10:30:00', 135, 'Standard', 70.00, 65),

-- Egypt
('Cairo Ramses', 'Alexandria Misr Station', 'Deluxe Express', 'EG205',
 '2025-04-28 09:30:00', '2025-04-28 12:00:00', 150, 'Sleeper', 60.00, 40),
('Luxor', 'Aswan', 'Nile Express', 'EG310',
 '2025-05-05 06:00:00', '2025-05-05 10:00:00', 240, 'First Class', 50.00, 30),
('Cairo Ramses', 'Luxor', 'Upper Egypt Night Train', 'EG450',
 '2025-05-06 20:00:00', '2025-05-07 08:00:00', 720, 'Sleeper', 75.00, 20);
SELECT * FROM Trains;


INSERT INTO Reviews (UserID, Rating) VALUES
(1, 4.5),
(2, 3.8),
(3, 5.0),
(4, 2.5),
(5, 4.2),
(6, 3.0),
(7, 4.9),
(8, 1.8),
(9, 4.0),
(10, 2.0),
(11, 5.0),
(12, 3.5),
(13, 4.7),
(14, 2.8),
(15, 3.9),
-- Additional rows for good measure
(1, 4.1),
(3, 3.3),
(7, 5.0),
(9, 2.2),
(12, 4.4);
SELECT * FROM Reviews;


INSERT INTO Packages (PackageName, DestinationID, Description, Price) VALUES
('Solo Traveller', 1, 'Backpacking across the Eiffel-lit nights of Paris.', 1200.00),
('Luxuria', 2, 'Luxury beaches and reef diving in Australia.', 3500.00),
('Solo Traveller', 3, 'Coastal California road trip adventure.', 1500.00),
('Luxuria', 4, 'Palace stays and gourmet tours in Rajasthan, India.', 2800.00),
('Solo Traveller', 5, 'Museum-hopping and pub nights in London.', 1300.00),
('Luxuria', 6, 'Cruising the Nile with 5-star accommodations.', 3200.00),
('Solo Traveller', 1, 'Café culture, poetry walks and solo wine tours.', 1100.00),
('Luxuria', 2, 'Great Barrier Reef + Island Resorts package.', 4100.00),
('Solo Traveller', 3, 'Urban exploration in NYC with city pass.', 1400.00),
('Luxuria', 4, 'Golden Triangle tour with chauffeur and guide.', 2700.00),
('Solo Traveller', 5, 'Walking Shakespeare’s London.', 1250.00),
('Luxuria', 6, '5-day desert safari & spa escape in Egypt.', 3600.00),
('Solo Traveller', 2, 'Sydney-to-Melbourne solo backpacker train pass.', 1600.00),
('Luxuria', 1, 'Romantic Parisian escape with Seine river cruise.', 3900.00),
('Solo Traveller', 4, 'Yoga and meditation retreat in the Himalayas.', 1350.00),
('Luxuria', 3, 'Luxury Broadway nights and Hamptons weekends.', 4400.00);
SELECT * FROM Packages;



INSERT INTO Activities (DestinationID, ActivityName, ActivityDate, ActivityType, Description, TicketPrice)
VALUES 
-- France (DestinationID = 1)
(1, 'Eiffel Tower Light Show', '2025-06-15', 'Cultural', 'Enjoy the iconic Eiffel Tower light show from the Champ de Mars.', 25.00),
(1, 'Louvre Museum Guided Tour', '2025-06-17', 'Cultural', 'Explore masterpieces including the Mona Lisa in a guided museum experience.', 30.00),
(1, 'Seine River Cruise', '2025-06-18', 'Romantic', 'Sunset cruise along the Seine with wine tasting.', 40.00),

-- Australia (DestinationID = 2)
(2, 'Sydney Opera House Tour', '2025-07-10', 'Cultural', 'Behind-the-scenes access to Australia’s most iconic performance venue.', 35.00),
(2, 'Bondi Beach Surfing Class', '2025-07-12', 'Adventure', 'Learn to ride the waves at Bondi with expert instructors.', 50.00),
(2, 'Blue Mountains Day Trip', '2025-07-14', 'Nature', 'Escape the city and experience the natural beauty of the Blue Mountains.', 70.00),

-- USA (DestinationID = 3)
(3, 'Broadway Musical Night', '2025-08-05', 'Show', 'Watch an award-winning Broadway musical in New York.', 120.00),
(3, 'Statue of Liberty Tour', '2025-08-06', 'Cultural', 'Guided tour and ferry ride to Liberty Island.', 25.00),
(3, 'Hollywood Walk of Fame Tour', '2025-08-10', 'Cultural', 'Explore the stars and history of Hollywood.', 20.00),

-- India (DestinationID = 4)
(4, 'Taj Mahal Sunrise Visit', '2025-09-01', 'Cultural', 'Breathtaking early morning view of the Taj Mahal.', 15.00),
(4, 'Ganges River Aarti Ceremony', '2025-09-03', 'Spiritual', 'Witness the beautiful Ganga Aarti ritual in Varanasi.', 10.00),
(4, 'Rajasthan Desert Safari', '2025-09-06', 'Adventure', 'Camel ride and dinner under the stars in the Thar Desert.', 60.00),

-- UK (DestinationID = 5)
(5, 'Tower of London Tour', '2025-10-10', 'Cultural', 'Historic tour with the Yeoman Warders.', 22.00),
(5, 'London Eye Ride', '2025-10-11', 'Leisure', 'Panoramic views of London from the iconic wheel.', 30.00),

-- Egypt (DestinationID = 6)
(6, 'Pyramids of Giza Camel Tour', '2025-11-01', 'Adventure', 'Guided camel ride around the pyramids.', 45.00),
(6, 'Nile River Dinner Cruise', '2025-11-02', 'Romantic', 'Enjoy a buffet dinner with live entertainment on the Nile.', 55.00);
SELECT * FROM Activities;


INSERT INTO Weather (
    DestinationID, WeatherDate, Temperature, Conditions, 
    Humidity, Precipitation, WindSpeed, UVIndex, AQI
) VALUES
-- France
(1, '2025-04-08', 18.5, 'Partly Cloudy', 60, 0.5, 12.3, 5, 42),
(1, '2025-04-09', 20.1, 'Sunny', 52, 0.0, 10.0, 6, 38),
(1, '2025-04-10', 16.8, 'Rainy', 75, 5.2, 15.0, 3, 47),

-- Australia
(2, '2025-04-08', 26.3, 'Sunny', 45, 0.0, 18.0, 9, 35),
(2, '2025-04-09', 25.0, 'Windy', 48, 0.0, 24.5, 7, 30),
(2, '2025-04-10', 22.7, 'Cloudy', 55, 1.0, 20.0, 4, 33),

-- USA
(3, '2025-04-08', 14.2, 'Cloudy', 68, 0.0, 10.0, 4, 60),
(3, '2025-04-09', 17.5, 'Sunny', 50, 0.0, 12.5, 6, 45),
(3, '2025-04-10', 19.8, 'Rainy', 70, 6.0, 14.0, 2, 72),

-- India
(4, '2025-04-08', 35.2, 'Sunny', 38, 0.0, 9.0, 10, 85),
(4, '2025-04-09', 36.5, 'Partly Cloudy', 40, 0.0, 8.5, 11, 90),
(4, '2025-04-10', 34.0, 'Windy', 42, 0.0, 15.2, 9, 88),

-- UK
(5, '2025-04-08', 12.0, 'Foggy', 80, 0.3, 5.0, 2, 50),
(5, '2025-04-09', 14.5, 'Cloudy', 70, 0.0, 8.0, 3, 47),

-- Egypt
(6, '2025-04-08', 29.5, 'Sunny', 25, 0.0, 10.2, 9, 40),
(6, '2025-04-09', 30.0, 'Windy', 22, 0.0, 20.5, 10, 45);

SELECT * FROM Weather;


INSERT INTO CustomerSupport (UserID, QueryType, QueryDescription, ResolutionStatus)
VALUES 
(1, 'Billing', 'I was charged twice for my booking.', 'In Progress'),
(2, 'Technical', 'Unable to log in after recent update.', 'Open'),
(3, 'Booking Inquiry', 'Need help rescheduling my hotel.', 'Resolved'),
(4, 'Feedback', 'Great service on my last trip!', 'Closed'),
(5, 'Billing', 'Coupon code didn’t apply.', 'Escalated'),
(6, 'Technical', 'App crashes on flight selection.', 'In Progress'),
(7, 'Booking Inquiry', 'Change of passenger name on ticket.', 'Open'),
(8, 'Feedback', 'Loved the cruise package!', 'Closed'),
(9, 'Billing', 'Need invoice for my last rental.', 'Resolved'),
(10, 'Technical', 'Issues uploading ID proof.', 'Waiting for Customer'),
(11, 'Booking Inquiry', 'What’s included in the Luxuria package?', 'Open'),
(12, 'Feedback', 'Excellent support team.', 'Closed'),
(13, 'Billing', 'Need refund status update.', 'Escalated'),
(14, 'Technical', 'Website not loading on Safari.', 'In Progress'),
(15, 'Booking Inquiry', 'Can I add insurance later?', 'Open');
SELECT * FROM CustomerSupport;

INSERT INTO Payments (UserID, BankDetails, PaymentMethod, TransactionDate, TransactionAmount, PaymentStatus)
VALUES
(1, 'Bank of America - ****1234', 'Credit Card', '2025-04-01', 1200.50, 'Completed'),
(2, 'HDFC - ****5678', 'UPI', '2025-03-29', 950.00, 'Pending'),
(3, 'Chase - ****7890', 'Debit Card', '2025-03-15', 1420.75, 'Failed'),
(4, 'ICICI - ****1122', 'Credit Card', '2025-02-21', 200.00, 'Completed'),
(5, 'PayPal - ****4321', 'PayPal', '2025-01-18', 620.50, 'Completed'),
(6, 'SBI - ****9999', 'Net Banking', '2025-03-01', 350.00, 'Pending'),
(7, 'HSBC - ****2468', 'Credit Card', '2025-03-25', 840.30, 'Completed'),
(8, 'NAB - ****1357', 'UPI', '2025-02-10', 1230.45, 'Completed'),
(9, 'ANZ - ****8642', 'Debit Card', '2025-03-28', 1470.00, 'Completed'),
(10, 'Barclays - ****5566', 'Credit Card', '2025-04-02', 410.00, 'Failed'),
(11, 'Axis - ****1010', 'UPI', '2025-03-05', 999.99, 'Completed'),
(12, 'Kotak - ****2020', 'Credit Card', '2025-01-25', 540.00, 'Completed'),
(13, 'TD Bank - ****3030', 'Debit Card', '2025-02-14', 310.00, 'Completed'),
(14, 'BOB - ****4040', 'UPI', '2025-02-28', 700.00, 'Pending'),
(15, 'Bankwest - ****5050', 'Credit Card', '2025-03-30', 880.00, 'Completed');
SELECT * FROM Payments;

INSERT INTO Refunds (UserID, RefundReason, RefundAmount, RefundDate, RefundStatus)
VALUES
(1, 'Flight cancelled by airline', 250.00, '2025-04-03', 'Processed'),
(2, 'Double payment refund', 950.00, '2025-04-01', 'Pending'),
(3, 'Hotel not available', 1200.00, '2025-03-27', 'Rejected'),
(4, 'Incorrect charges', 300.00, '2025-03-20', 'Processed'),
(5, 'Event cancellation', 180.00, '2025-03-15', 'Processed'),
(6, 'Travel advisory', 450.00, '2025-02-25', 'Pending'),
(7, 'Wrong amount charged', 150.00, '2025-02-18', 'Processed'),
(8, 'Duplicate booking', 700.00, '2025-01-30', 'Rejected'),
(9, 'Package not delivered', 600.00, '2025-01-15', 'Processed'),
(10, 'Flight delay', 120.00, '2025-02-28', 'Processed'),
(11, 'Baggage lost', 90.00, '2025-02-14', 'Pending'),
(12, 'Rental issue', 400.00, '2025-03-03', 'Processed'),
(13, 'Cruise reschedule', 820.00, '2025-03-21', 'Rejected'),
(14, 'Train ticket misbooked', 75.00, '2025-04-01', 'Processed'),
(15, 'Weather cancellation', 500.00, '2025-04-04', 'Pending');
SELECT * FROM Refunds;

INSERT INTO Insurance (UserID, InsuranceProvider, PolicyNumber, CoverageAmount, InsuranceStatus)
VALUES
(1, 'TravelGuard', 'TG-123456', 1000.00, 'Active'),
(2, 'ICICI Lombard', 'IL-987654', 2000.00, 'Expired'),
(3, 'Allianz', 'AL-654321', 1500.00, 'Active'),
(4, 'Tata AIG', 'TA-456789', 2500.00, 'Pending'),
(5, 'Bajaj Allianz', 'BA-112233', 1800.00, 'Active'),
(6, 'Future Generali', 'FG-334455', 1200.00, 'Expired'),
(7, 'Star Health', 'SH-667788', 2200.00, 'Active'),
(8, 'HDFC ERGO', 'HE-998877', 3000.00, 'Pending'),
(9, 'Chubb Insurance', 'CH-776655', 900.00, 'Active'),
(10, 'SBI General', 'SB-554433', 1900.00, 'Expired'),
(11, 'Royal Sundaram', 'RS-443322', 2500.00, 'Pending'),
(12, 'Digit Insurance', 'DI-332211', 1400.00, 'Active'),
(13, 'Religare', 'RE-221100', 1100.00, 'Active'),
(14, 'Liberty General', 'LG-110099', 1600.00, 'Pending'),
(15, 'Go Digit', 'GD-009988', 2100.00, 'Active');

SELECT * FROM Insurance;

INSERT INTO Bookings (UserID, DestinationID, HotelBookingID, FlightsBookingID, TrainsBookingID, CruisesBookingID, RentalBookingID, ItineraryID, PaymentID, InsuranceID, RefundID)
VALUES
(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1),
(2, 2, NULL, NULL, NULL, NULL, NULL, NULL, 2, 2, 2),
(3, 3, NULL, NULL, NULL, NULL, NULL, NULL, 3, 3, 3),
(4, 4, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, 4),
(5, 5, NULL, NULL, NULL, NULL, NULL, NULL, 5, 5, 5),
(6, 6, NULL, NULL, NULL, NULL, NULL, NULL, 6, 6, 6),
(7, 7, NULL, NULL, NULL, NULL, NULL, NULL, 7, 7, 7),
(8, 8, NULL, NULL, NULL, NULL, NULL, NULL, 8, 8, 8),
(9, 9, NULL, NULL, NULL, NULL, NULL, NULL, 9, 9, 9),
(10, 10, NULL, NULL, NULL, NULL, NULL, NULL, 10, 10, 10),
(11, 11, NULL, NULL, NULL, NULL, NULL, NULL, 11, 11, 11),
(12, 12, NULL, NULL, NULL, NULL, NULL, NULL, 12, 12, 12),
(13, 13, NULL, NULL, NULL, NULL, NULL, NULL, 13, 13, 13),
(14, 14, NULL, NULL, NULL, NULL, NULL, NULL, 14, 14, 14),
(15, 15, NULL, NULL, NULL, NULL, NULL, NULL, 15, 15, 15);

SELECT * FROM Bookings;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Bookings;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Bookings
ADD COLUMN BookingType VARCHAR(50);

ALTER TABLE Bookings
ADD COLUMN BookingDate DATE;

INSERT INTO Bookings (
    UserID, DestinationID, HotelBookingID, FlightsBookingID, TrainsBookingID,
    CruisesBookingID, RentalBookingID, ItineraryID, PaymentID, InsuranceID,
    RefundID, BookingType, BookingDate
)
VALUES
(1, 3, 5, 4, 2, 1, 6, 2, 1, 3, 1, 'Flight', '2025-04-08'),
(2, 4, 3, 2, 1, 2, 4, 1, 2, 4, 2, 'Hotel', '2025-04-08'),
(3, 1, 6, 3, 5, 3, 7, 3, 3, 2, 3, 'Cruise', '2025-04-08'),
(4, 6, 1, 5, 3, 4, 1, 4, 4, 5, 4, 'Flight + Hotel', '2025-04-08'),
(5, 2, 2, 6, 4, 2, 3, 5, 5, 1, 5, 'Flight + Cruise', '2025-04-08'),
(6, 8, 4, 7, 2, 5, 2, 6, 6, 3, NULL, 'Hotel', '2025-04-08'),
(7, 7, 8, 9, NULL, NULL, NULL, 7, 7, NULL, NULL, 'Flight', '2025-04-08'),
(8, 3, 9, 1, 6, 6, 8, 8, 8, 6, NULL, 'Cruise', '2025-04-08'),
(9, 5, NULL, 10, 7, 1, 9, 9, 9, 7, 1, 'Flight + Hotel', '2025-04-08'),
(10, 9, 10, 11, 8, NULL, NULL, 10, 10, NULL, NULL, 'Hotel', '2025-04-08'),
(11, 1, NULL, 12, NULL, 2, 10, 11, 1, 8, 2, 'Flight', '2025-04-08'),
(12, 4, 12, 13, 9, 3, 5, 12, 2, 2, 3, 'Flight + Cruise', '2025-04-08'),
(13, 6, 11, NULL, 10, 4, NULL, 13, 3, 9, NULL, 'Hotel', '2025-04-08'),
(14, 10, 13, 14, 1, 5, 6, 14, 4, 10, 4, 'Cruise', '2025-04-08'),
(15, 2, 14, 15, 2, 6, 7, 15, 5, 1, NULL, 'Flight', '2025-04-08');
select* from bookings;

DESCRIBE Users;
ALTER TABLE Users ADD COLUMN Password VARCHAR(255);
Select*from Users;






-- queries

-- Basic DDL:
-- Add a new column for loyalty points to the Users table

ALTER TABLE Users ADD COLUMN LoyaltyPoints INT DEFAULT 0;
select* from Users;
-- Add an index to the Nationality column in Users for faster searching

CREATE INDEX idx_user_nationality ON Users (Nationality);

-- Modify the PhoneNumber column to allow longer numbers
ALTER TABLE Users MODIFY COLUMN PhoneNumber VARCHAR(30);

-- Remove the index previously added on Nationality

DROP INDEX idx_user_nationality ON Users;

-- Constraint (Basic)
ALTER TABLE Hotels ADD CONSTRAINT chk_hotel_rating CHECK (Rating >= 1.0 AND Rating <= 5.0);

-- Index (Basic)
CREATE INDEX idx_flight_route ON Flights (SourceAirport, DestinationAirport);

-- Column add (Basic)
ALTER TABLE Bookings ADD COLUMN BookingNotes TEXT DEFAULT 'No specific notes provided.';

-- ENUM modify (Basic)
ALTER TABLE Hotels MODIFY COLUMN Room_Type ENUM('Standard', 'Deluxe', 'Suite');

-- New Table (Basic)
CREATE TABLE AirportCodes (
    AirportCode VARCHAR(3) PRIMARY KEY,
    AirportName VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    Country VARCHAR(100)
);

-- Drop Table (Basic)
DROP TABLE IF EXISTS Feedback;

-- DML: Basic Queries
SELECT UserID, FullName, Email, Username FROM Users WHERE Nationality = 'USA';
SELECT Name, Rating, Price_Per_Night FROM Hotels WHERE DestinationID = 1 ORDER BY Rating DESC;
INSERT INTO Destinations (Country, City) VALUES ('Portugal', 'Lisbon');
UPDATE Flights SET Price = 1400.00 WHERE FlightID = 1;
DELETE FROM Reviews WHERE ReviewID = 4;

-- DML: Complex Joins & Aggregates
SELECT U.UserID, U.FullName, COUNT(B.BookingID) AS TotalBookings
FROM Users U
JOIN Bookings B ON U.UserID = B.UserID
GROUP BY U.UserID, U.FullName
ORDER BY TotalBookings DESC;

SELECT D.Country, D.City, AVG(H.Rating) AS AverageRating
FROM Destinations D
JOIN Hotels H ON D.DestinationID = H.DestinationID
GROUP BY D.DestinationID, D.Country, D.City
HAVING AVG(H.Rating) > 4.6
ORDER BY AverageRating DESC;

SELECT U.UserID, U.FullName, U.Email
FROM Users U
LEFT JOIN Bookings B ON U.UserID = B.UserID
WHERE B.BookingID IS NULL;

SELECT F.FlightID, F.Airline, F.FlightNumber, F.TicketClass, F.Price
FROM Flights F
WHERE F.Price < (
    SELECT AVG(F_avg.Price)
    FROM Flights F_avg
    WHERE F_avg.TicketClass = F.TicketClass
);

SELECT U.Username, U.Email, CS.QueryType, CS.ResolutionStatus, CS.QueryDate
FROM Users U
JOIN CustomerSupport CS ON U.UserID = CS.UserID
WHERE CS.QueryDate = (
    SELECT MAX(CS_latest.QueryDate)
    FROM CustomerSupport CS_latest
    WHERE CS_latest.UserID = U.UserID
);

SELECT H.Name, D.City, H.Price_Per_Night,
RANK() OVER (PARTITION BY H.DestinationID ORDER BY H.Price_Per_Night DESC) as PriceRankInCity
FROM Hotels H
JOIN Destinations D ON H.DestinationID = D.DestinationID;

SELECT D.Country, D.City
FROM Destinations D
WHERE D.DestinationID IN (
    SELECT DestinationID FROM Activities WHERE ActivityType = 'Adventure'
)
AND D.DestinationID IN (
    SELECT DestinationID FROM Activities WHERE ActivityType = 'Cultural'
);

SELECT U.UserID, U.FullName, SUM(P.TransactionAmount) AS TotalCompletedSpending
FROM Users U
JOIN Payments P ON U.UserID = P.UserID
WHERE P.PaymentStatus = 'Completed'
GROUP BY U.UserID, U.FullName
ORDER BY TotalCompletedSpending DESC;

-- TCL: Basic Transactions
START TRANSACTION;
UPDATE Users SET Email = 'new.email@example.com' WHERE UserID = 1;
COMMIT;

START TRANSACTION;
INSERT INTO Feedback (Username, Comment) VALUES ('johndoe123', 'Temporary feedback.');
ROLLBACK;

START TRANSACTION;
UPDATE Hotels SET Availability_Status = 'Full' WHERE HotelId = 4;
UPDATE Flights SET Availability = Availability - 1 WHERE FlightID = 1;
COMMIT;

START TRANSACTION;
DELETE FROM Feedback WHERE Username = 'spamuser';
COMMIT;

-- TCL: Complex - Savepoints
START TRANSACTION;
UPDATE Hotels SET Price_Per_Night = 350.00 WHERE HotelId = 1;
SAVEPOINT BeforeBookingAttempt;
INSERT INTO Bookings (UserID, DestinationID, HotelBookingID, BookingType, BookingDate)
VALUES (5, 1, 1, 'Hotel', CURDATE());
-- ROLLBACK TO SAVEPOINT BeforeBookingAttempt;
COMMIT;

START TRANSACTION;
INSERT INTO Users (FirstName, LastName, DOB, Gender, Nationality, Email, PhoneNumber, Address, Username, Password)
VALUES ('Test', 'User', '2001-01-01', 'Other', 'Canada', 'test.user@example.com', '9876543210', '1 Test St', 'testuser1', 'password123');
SAVEPOINT UserCreated;
INSERT INTO Bookings (UserID, DestinationID, BookingType, BookingDate)
SELECT UserID, 1, 'Package', CURDATE() FROM Users WHERE Username = 'testuser1';
-- ROLLBACK TO SAVEPOINT UserCreated;
COMMIT;

-- DCL: Basic Grants & Revokes
GRANT SELECT ON trouvaille.Flights TO 'travel_agent'@'localhost';
GRANT INSERT, UPDATE ON trouvaille.Bookings TO 'travel_agent'@'localhost';
REVOKE UPDATE ON trouvaille.Bookings FROM 'travel_agent'@'localhost';

GRANT SELECT ON trouvaille.Users TO 'data_analyst'@'localhost';
GRANT SELECT ON trouvaille.Destinations TO 'data_analyst'@'localhost';
GRANT SELECT ON trouvaille.Bookings TO 'data_analyst'@'localhost';
GRANT SELECT ON trouvaille.Payments TO 'data_analyst'@'localhost';

-- DCL: Complex Permissions
GRANT SELECT (FlightID, SourceAirport, DestinationAirport, Price, Availability),
UPDATE (Price, Availability) ON trouvaille.Flights TO 'travel_agent'@'localhost';

-- GRANT ALL PRIVILEGES ON trouvaille.* TO 'db_admin'@'localhost' WITH GRANT OPTION;