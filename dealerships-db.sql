--USE master;
--DROP DATABASE Car_Dealership_Network;
--GO

--CREATE DATABASE Car_Dealership_Network;
--GO

--USE Car_Dealership_Network;
--GO

------------ DELETE TABLES - VIEWS - PROCEDURES - FUNCTIONS - TRIGGERS ------------

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Dealer_Car;
DROP TABLE IF EXISTS Car_Equipment;
DROP TABLE IF EXISTS Additional_Equipment;
DROP TABLE IF EXISTS Passenger_Car;
DROP TABLE IF EXISTS Commercial_Vehicle;
DROP TABLE IF EXISTS Dealer_Specialization;
DROP TABLE IF EXISTS Engine_Model;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Dealer;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Engine_Type;
DROP TABLE IF EXISTS Brand;

DROP VIEW IF EXISTS Most_popular_brands;

DROP PROCEDURE IF EXISTS Cars_by_brand;
DROP PROCEDURE IF EXISTS New_dealer;
DROP PROCEDURE IF EXISTS Remove_commercial_vehicle;
DROP PROCEDURE IF EXISTS New_address;
DROP PROCEDURE IF EXISTS Car_sold;

DROP FUNCTION IF EXISTS Installment_Cost;
DROP FUNCTION IF EXISTS Older_Models_Than;

DROP TRIGGER IF EXISTS Check_Engine;

GO


------------ CREATE TABLES AND RELATIONS ------------

CREATE TABLE Brand
(
    name            VARCHAR(20) NOT NULL PRIMARY KEY,
    foundation_year VARCHAR(19)
);

CREATE TABLE Model
(
    id                              INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    name                            VARCHAR(20) UNIQUE,
    launch_year                     INTEGER,
    brand                           VARCHAR(20) REFERENCES Brand(name),
    previous_generation             INTEGER
);

CREATE TABLE Engine_Type
(
    id                  INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    fuel_type           VARCHAR(20),
    description         VARCHAR(300) UNIQUE
);

CREATE TABLE Dealer
(
    name        VARCHAR(30) NOT NULL PRIMARY KEY,
    address     VARCHAR(40) UNIQUE
);

CREATE TABLE Car
(
    vin                 VARCHAR(17) NOT NULL PRIMARY KEY,
    mileage             INTEGER DEFAULT 0,
    gearbox             VARCHAR(30) CHECK ( gearbox IN ('manual','automatic','semi-automatic','continuously variable')) DEFAULT 'manual',
    production_year     INTEGER CHECK( production_year > 1890 ),
    country_of_origin   VARCHAR(30),
    model_id            INTEGER NOT NULL REFERENCES Model(id),
    engine_type_id      INTEGER NOT NULL REFERENCES Engine_Type(id)
);

CREATE TABLE Additional_Equipment
(
    name VARCHAR(40) NOT NULL PRIMARY KEY
);

CREATE TABLE Client
(
    id INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    phone_number INTEGER UNIQUE
);

CREATE TABLE Passenger_Car
(
    model_id INTEGER NOT NULL PRIMARY KEY REFERENCES Model(id),
    passenger_capacity INTEGER DEFAULT 0,
    trunk_capacity INTEGER DEFAULT 0
);

CREATE TABLE Commercial_Vehicle
(
    model_id INTEGER NOT NULL PRIMARY KEY REFERENCES Model(id),
    load_capacity INTEGER DEFAULT 0
);

CREATE TABLE Dealer_Specialization
(
    dealer VARCHAR(30) NOT NULL REFERENCES Dealer(name),
    model_id INTEGER NOT NULL REFERENCES Model(id),
    PRIMARY KEY (dealer, model_id)
);

CREATE TABLE Engine_Model
(
    model_id INTEGER NOT NULL REFERENCES Model(id),
    engine_type_id INTEGER NOT NULL REFERENCES Engine_Type(id),
    PRIMARY KEY (model_id, engine_type_id)
);

CREATE TABLE Dealer_Car
(
    dealer VARCHAR(30) NOT NULL REFERENCES Dealer(name),
    car_vin VARCHAR(17) NOT NULL REFERENCES Car(vin),
    PRIMARY KEY (car_vin)
);

CREATE TABLE Car_Equipment
(
    car_vin VARCHAR(17) NOT NULL REFERENCES Car(vin),
    equipment VARCHAR(40) NOT NULL REFERENCES Additional_Equipment(name),
    PRIMARY KEY (car_vin, equipment)
);

CREATE TABLE Sales
(
    client_id INTEGER NOT NULL REFERENCES Client(id),
    dealer VARCHAR(30) NOT NULL REFERENCES Dealer(name),
    car_vin VARCHAR(17) NOT NULL REFERENCES Car(vin),
    sale_date VARCHAR(19) NOT NULL,
    price DECIMAL(11,2) NOT NULL CHECK ( price > 0.00 ),
    PRIMARY KEY (client_id, car_vin, dealer, sale_date)
);

GO

------------ INSERT DATA ------------

INSERT INTO Brand VALUES
('Volkswagen', 				'1909-07-16 00:00:00'),
('Škoda',					'1916-03-07 00:00:00'),
('SEAT', 			        '1902-08-22 00:00:00'),
('BMW', 			        '1911-11-03 00:00:00'),
('Ferrari', 			    '1919-01-01 00:00:00'),
('Bentley', 				'1914-01-01 00:00:00'),
('Jaguar', 			        '1938-09-13 00:00:00'),
('Fiat', 			    	'1899-07-11 00:00:00'),
('Ford Motor Company', 		'1906-11-29 00:00:00'),
('Audi', 	                '1908-01-01 00:00:00');


INSERT INTO Model VALUES
('Polo V', 			'2009', 'Volkswagen',		NULL	),
('Polo VI',	 		'2017', 'Volkswagen',		1		),
('Kinga', 			'1996', 'Volkswagen',		NULL	),
('Kinga II', 		'2003', 'Volkswagen',		3		),
('Kinga III', 		'2012', 'Volkswagen',		4		),
('Octavia I',	    '1996', 'Skoda',		    NULL	),
('Octavia II',	    '2003', 'Skoda',		    6		),
('Octavia III',	    '2012', 'Skoda',		    7	    ),
('S31',			    '1998', 'Skoda',		    NULL	),
('S32',			    '2002', 'Skoda',	 	    9		),
('Jumper I',		'1994', 'Ferrari',	        NULL	),
('Jumper II',		'2006', 'Ferrari',	        11		),
('Tristen I',		'1981', 'Fiat',		        NULL	),
('Tristen II',		'1994', 'Fiat',		        13		),
('Norv ',		    '2006', 'Fiat',		        NULL	),
('Diablo I',		'2000', 'Fiat',		        NULL	),
('Diablo II',		'2010', 'Fiat',		        16		),
('Fundo I',			'1996', 'Fiat',		        NULL	),
('Fundo II',		'2006', 'Fiat',		        18		),
('Sat I',		    '1998', 'Fiat',		        NULL	);

INSERT INTO Engine_Type VALUES
('gasoline', 'R4 1.2L (1197 cm3), DOHC, turbo'  ),
('gasoline', 'R4 2.0L, DOHC, turbo'             ),
('gasoline', 'R4 1.6L (1595 cm3), SOHC'         ),
('gasoline', 'VR6 3.2L (3189 cm3), DOHC'        ),
('gasoline', 'R4 1.9L (1896 cm3), SOHC'         ),
('gasoline', 'R4 1.6L (1574 cm3), SOHC'         ),
('gasoline', 'R6 2.0L (1991 cm3), SOHC'         ),
('gasoline', 'R4 2.0L (1991 cm3), SOHC'         ),
('gasoline', 'R6 2.3L (2316 cm3), SOHC'         ),
('gasoline', 'R4 1.6L (1766 cm3), SOHC'         ),
('diesel',   'PSA DJY (XUD9A)'                  ),
('diesel',   'PSA T9A (DJ5)'                    ),
('diesel',   'SOFIM 8140.21'                    ),
('diesel',   'SOFIM 8140.27'                    ),
('gasoline', 'R4 OHC/8 102/3500'                ),
('gasoline', 'R4 OHC/8 121/3300'                ),
('gasoline', 'R4 DOHC/16 145/4000'              ),
('gasoline', 'R4 DOHC/16 8.6/6.8/7.5'           ),
('gasoline', 'R4 DOHC/16 9.4/6.6/7.6'           ),
('gasoline', 'R4 73 (54)/5200 118/2600'         );


INSERT INTO Dealer VALUES
('Auto Master', 'Kościuszki 215,    Warsaw'),
('Pro-moto', 	'Warsawska 330,     Warsaw'),
('Dynamica',	'Jawornik 525,      Warsaw'),
('GEZET Group', 'Łopuszańska 72,    Warsaw'),
('Bednarek', 	'Szczecińska 36,    Warsaw'),
('Autopark',	'Gadowiejska 432,   Warsaw'),
('Top Auto', '  Batorego 69,        Warsaw'),
('CARSED',	    'Opolska 2,         Warsaw'),
('LELLEK',	    'Budowlanych 7,     Warsaw'),
('GAS GAS GAS',	'Kruszyna 12,       Warsaw');

INSERT INTO Car VALUES
('WPOZZZ99ZTS392124', 212,      'automatic',        2000, 'Germany',    1, 1),
('WBA5L31080G078897', 0,        'automatic',        1998, 'Germany',    2, 2),
('WBANU31080B697476', 0,        'manual',           2002, 'Germany',    3, 3),
('WBA1S510805A74005', 2554,     'manual',           2017, 'Italy',      4, 4),
('TNBAB7NE5E0100470', 254257,   'manual',           2013, 'Italy',      5, 5),
('WVWZZZ1JZ1W214431', 6454,     'automatic',        1997, 'Germany',    6, 6),
('TMBEM25J6D3135222', 34556,    'automatic',        2005, 'Germany',    7, 7),
('WVWZZZ3CZGP033210', 54348,    'automatic',        1996, 'Germany',    8, 8),
('VSSZZZ5PZ6R049517', 31245,    'manual',           2018, 'Germany',    9, 9),
('SAJAF51276BE94147', 1324,     'manual',           2006, 'France',     10, 10),
('WF0DXXGBBD7P77169', 3354,     'manual',           2001, 'Italy',      11, 11),
('2FMDK36C78BA90204', 8684,     'semi-automatic',   2010, 'Italy',      12, 12),
('WVWZZZAUZDP077595', 564868,   'manual',           1999, 'Germany',    13, 13),
('WA1MFCFPXEA018412', 65456,    'manual',           2016, 'Germany',    14, 14),
('TMBAH7NP1G7023039', 31345,    'semi-automatic',   2013, 'Germany',    15, 15),
('TMBEC25J8D3134639', 349963,   'manual',           2010, 'France',     16, 16),
('WBA5A51030G178312', 0,        'manual',           1995, 'France',     17, 17),
('TMBAE73TXC9065064', 0,        'manual',           2000, 'France',     18, 18),
('WBAPY51010CX14136', 0,        'semi-automatic',   2018, 'Germany',    19, 19),
('TMBCJ9NP3G7040661', 0,        'semi-automatic',   1999, 'Germany',    20, 20);

INSERT INTO Client VALUES
('Katarzyna',   'Nałkowska',    '265874986'),
('Wojciech',    'Michałski',    '569321478'),
('Amadeusz',    'Kosocki',      '895478658'),
('Beata',       'Miszewska',    '123654789'),
('Pola',        'Martyr',       '987654321'),
('Paweł',       'Derowski',     '987321654'),
('Jan',         'Zarański',     '321987654'),
('Danuta',      'Zaleńska',     '456321987'),
('Marta',       'Półć',         '789654123'),
('Aneta',       'Krisz',        '852963741');

INSERT INTO Additional_Equipment VALUES
('Reverse sensor and camera'),
('Automatic trunk lid'),
('GPS'),
('Heated seats'),
('Parking assistant'),
('Lane assistant'),
('Cruise control'),
('Automatic headlights'),
('Keyless entry system'),
('Traffic sign recognition');

INSERT INTO Passenger_Car VALUES
(1, 4, 332),
(2, 4, 301),
(3, 4, 214),
(4, 4, 206),
(5, 4, 206),
(6, 4, 206),
(7, 4, 622),
(8, 4, 450),
(9, 4, 246),
(10, 4, 337);

INSERT INTO Commercial_Vehicle VALUES
(11, 1500),
(12, 1200),
(13, 2500),
(14, 1300),
(15, 1450),
(16, 1900),
(17, 2000),
(18, 1200),
(19, 1400),
(20, 1700);

INSERT INTO Dealer_Specialization VALUES
('Auto Master',     1),
('Pro-moto',        3),
('Dynamica',        8),
('GEZET Group',     4),
('Bednarek',        17),
('Autopark',        2),
('Top Auto',        3),
('CARSED',          16),
('LELLEK',          8),
('GAS GAS GAS',     12);

INSERT INTO Model_Engine VALUES
(1,1),      (2,2),
(3,3),      (4,4),
(5,5),      (6,6), 
(7,7),      (8,8), 
(9,9),      (10,10),
(11,11),    (12,12),
(13,13),    (14,14),
(15,15),    (16,16), 
(17,17),    (18,18),
(19,19),    (20,20);

INSERT INTO Dealer_Car VALUES
('Auto Master',     'WPOZZZ99ZTS392124'),
('Pro-moto',        'WBA1S510805A74005'),
('Dynamica',        'WVWZZZ1JZ1W214431'),
('Dynamica',        'TMBEM25J6D3135222'),
('GEZET Group',     'WVWZZZ3CZGP033210'),
('Bednarek',        'VSSZZZ5PZ6R049517'),
('Top Auto',        'WVWZZZAUZDP077595'),
('CARSED',          'TMBAH7NP1G7023039'),
('GAS GAS GAS',     'TMBAE73TXC9065064'),
('GAS GAS GAS',     'WBAPY51010CX14136');

INSERT INTO Car_Equipment VALUES
('WPOZZZ99ZTS392124', 'GPS'),
('WBANU31080B697476', 'Cruise control'),
('WBA1S510805A74005', 'Automatic trunk lid'),
('WVWZZZ3CZGP033210', 'Keyless entry system'),
('VSSZZZ5PZ6R049517', 'Parking assistant'),
('SAJAF51276BE94147', 'Cruise control'),
('WF0DXXGBBD7P77169', 'Reverse sensor and camera'),
('2FMDK36C78BA90204', 'Parking assistant'),
('TMBAH7NP1G7023039', 'Automatic trunk lid'),
('TMBAE73TXC9065064', 'Cruise control');

INSERT INTO Sale VALUES
(1, 'Auto Master',     'WBA5L31080G078897', '2019-03-04 17:02:28', 104700.00),
(2, 'Pro-moto',        'WBANU31080B697476', '2019-01-04 12:27:55', 5900.00),
(3, 'Dynamica',        'TNBAB7NE5E0100470', '2019-05-09 15:24:05', 125900.00),
(4, 'Bednarek',        'SAJAF51276BE94147', '2019-06-05 03:16:42', 39999.00),
(5, 'Autopark',        'WF0DXXGBBD7P77169', '2019-01-23 16:39:24', 68300.00),
(6, 'Top Auto',        '2FMDK36C78BA90204', '2019-02-14 23:04:23', 38950.00),
(7, 'CARSED',          'WA1MFCFPXEA018412', '2019-03-31 17:27:47', 69400.00),
(8, 'LELLEK',          'TMBEC25J8D3134639', '2019-04-17 10:03:36', 29500.00),
(9, 'GAS GAS GAS',     'WBA5A51030G178312', '2019-03-07 23:45:06', 60000.00),
(10, 'GAS GAS GAS',    'TMBCJ9NP3G7040661', '2019-05-01 03:56:09', 5000.00);

GO

------------ VIEW ------------

CREATE VIEW Most_Purchased_Brands(brand, number_of_sold_cars)
AS
(
    SELECT  brand, 
            COUNT(*) AS [number_of_sold_cars]
	FROM    Model
	WHERE   id IN ( SELECT  model
                    FROM    Car
                    WHERE   vin IN ( SELECT  car_vin
                                     FROM    Sale))
    GROUP BY brand
);

GO

----------- PROCEDURES ----------

CREATE PROCEDURE Cars_By_Brand
    @dealer VARCHAR(30)
AS
BEGIN
    DECLARE @cars VARCHAR(8000);

    SELECT  @cars = COALESCE(@cars + ', ', '') + car_vin
    FROM    Dealer_Car
    WHERE   dealer = @dealer;

    PRINT @cars;
END;

GO


CREATE PROCEDURE New_Dealer
    @name      VARCHAR(30),
	@address   VARCHAR(40)
AS
BEGIN
    INSERT INTO Dealer VALUES 	
    (@name, @address);
END;

GO


CREATE PROCEDURE Delete_Commercial_Vehicle
    @model VARCHAR(20)
AS
BEGIN
    DELETE FROM	 Commercial_Vehicle
	WHERE model = ( SELECT  id
		               FROM 	Model
		               WHERE 	name = @model);
END;

GO


CREATE PROCEDURE New_Address
	@name INTEGER,
    @address VARCHAR(40)
AS
BEGIN
    UPDATE	Dealer
	SET		address = @address
	WHERE 	name = @name;
END;

GO


CREATE PROCEDURE Sold_Car
	@customer_id      INTEGER,
    @vin              VARCHAR(17),
	@price            DECIMAL(11,2)
AS
BEGIN
    DECLARE @dealer VARCHAR(30);

        IF   @vin IN 	    ( SELECT vin 
                              FROM Car )
	         AND  @customer_id IN ( SELECT id 
                                  FROM Customer )
        BEGIN
            SELECT  @dealer = dealer
            FROM 	Dealer_Car
	        WHERE	car_vin = @vin;
    
            INSERT INTO Sale VALUES
            (@customer_id, @dealer, @vin, CONVERT(VARCHAR, GETDATE(), 120), @price);
		
		    DELETE FROM	 Dealer_Car
		    WHERE car_vin = @vin;
        END
END;

GO


------------- FUNCTIONS -------------

CREATE FUNCTION Installment_Cost
(
    @vin VARCHAR(17),
    @installments DECIMAL(10)
)
RETURNS DECIMAL(11,2)
AS
BEGIN
    RETURN ( SELECT  price
             FROM    Sale
             WHERE   car_vin = @vin ) / @installments;
END;

GO

CREATE FUNCTION Older_Models
(
    @year INTEGER
)
RETURNS TABLE
AS
RETURN 
    SELECT name, year_introduced, brand
    FROM   Model
    WHERE  year_introduced < @year;

GO

------------ TRIGGER ------------

CREATE TRIGGER Check_Engine
ON Car
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS(
        SELECT * FROM inserted i
        WHERE i.model IN (
            SELECT model
            FROM Engine_Model
            WHERE engine_type_id = i.engine_type_id
        )
    )
    BEGIN
        INSERT INTO Car
        SELECT * FROM inserted;
    END;
		
END;
		
GO

------------ SELECT ------------

SELECT * FROM Car;
SELECT * FROM Model;
SELECT * FROM Brand;
SELECT * FROM Engine_Type;
SELECT * FROM Additional_Equipment;
SELECT * FROM Dealer;
SELECT * FROM Customer;
SELECT * FROM Passenger_Car;
SELECT * FROM Commercial_Vehicle;
SELECT * FROM Dealer_Specialization;
SELECT * FROM Engine_Model;
SELECT * FROM Dealer_Car;
SELECT * FROM Car_Equipment;
SELECT * FROM Sale;

SELECT * FROM Most_Purchased_Brands ORDER BY number_of_sold_cars DESC;

GO

------- SAMPLE PROCEDURES, FUNCTIONS AND TRIGGERS --------

-- EXEC Cars_By_Brand 'GAS GAS GAS'; -- Which cars does GAS GAS GAS sell

-- EXEC New_Dealer 'Satan', 'Warszawska 666, Warsaw';

-- EXEC Delete_Commercial_Vehicle 'Diablo I';

-- EXEC New_Address 'Satan', 'Hell';

-- EXEC Sold_Car 1, 'WBAPY51010CX14136', 300000.00;

-- SELECT dbo.Installment_Cost('SAJAF51276BE94147', 24);
-- SELECT * FROM dbo.Older_Models(2000) ORDER BY year_introduced;

-- INSERT INTO Car VALUES
-- ('BSFDGSRGE45235532', 15850.00, 'semiautomatic', 2016, 'Germany', 12, 10); 


-- discrepancy example


-- INSERT INTO Car VALUES
-- ('NUAUEHGFU493895FF', 96968.00, 'semiautomatic', 2016, 'Germany', 8, 8);

