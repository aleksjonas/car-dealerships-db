# Car Dealerships Database

Documentation for the database schema, including tables, views, procedures, functions, triggers, and sample queries.

## Tables

1. **Brand**: Stores information about car brands, including name and foundation year.
2. **Model**: Contains details about car models, including ID, name, launch year, brand (foreign key to Brand table), and the previous generation model (if applicable).
3. **Engine_Type**: Stores engine types and descriptions, including ID, fuel type, and description.
4. **Dealer**: Information about car dealers, including name and address.
5. **Car**: Holds data regarding cars, including VIN (Vehicle Identification Number), mileage, gearbox type, production year, country of origin, model (foreign key to Model table), and engine type (foreign key to Engine_Type table).
6. **Additional_Equipment**: Contains additional equipment available for cars, including name.
7. **Client**: Stores information about clients purchasing cars, including ID, first name, last name, and phone number.
8. **Passenger_Car**: Details about passenger cars, including model ID (foreign key to Model table), passenger capacity, and trunk capacity.
9. **Commercial_Vehicle**: Information about commercial vehicles, including model ID (foreign key to Model table) and load capacity.
10. **Dealer_Specialization**: Tracks dealer specialization in selling specific car models, including dealer name and model ID (both foreign keys).
11. **Engine_Model**: Maps models to engine types, including model ID and engine type ID (both foreign keys).
12. **Dealer_Car**: Represents the relationship between dealers and cars they sell, including dealer name and car VIN (both foreign keys).
13. **Car_Equipment**: Tracks additional equipment for each car, including car VIN and equipment name (both foreign keys).
14. **Sales**: Records car sales, including client ID (foreign key to Client table), dealer name (foreign key to Dealer table), car VIN (foreign key to Car table), sale date, and price.

## Views

1. **Most_Purchased_Brands**: A view showing the most purchased brands and the number of cars sold for each brand. It calculates the number of sold cars by counting the occurrences of each brand in the Sales table.

## Procedures

1. **Cars_By_Brand**: Retrieves the VINs of cars sold by a specific dealer. It takes the dealer's name as input and returns a list of car VINs.
2. **New_Dealer**: Adds a new car dealer to the database. It takes the dealer's name and address as input and inserts a new record into the Dealer table.
3. **Delete_Commercial_Vehicle**: Deletes a commercial vehicle from the database based on the model name. It takes the model name as input and removes the corresponding record from the Commercial_Vehicle table.
4. **New_Address**: Updates the address of a dealer. It takes the dealer's name and new address as input and updates the address in the Dealer table.
5. **Sold_Car**: Records the sale of a car to a client. It takes the client ID, car VIN, and sale price as input, inserts a new record into the Sales table, and removes the corresponding record from the Dealer_Car table.

## Functions

1. **Installment_Cost**: Calculates the cost of each installment for a car based on VIN and the number of installments. It takes the car VIN and the number of installments as input and returns the installment cost.
2. **Older_Models**: Retrieves models introduced before a specified year. It takes a year as input and returns a table of older models, including model name, launch year, and brand.

## Trigger

1. **Check_Engine**: Checks if a newly inserted car's engine matches the engine type specified for its model. If not, the insertion is aborted. It ensures data integrity by enforcing consistency between the model's engine type and the actual engine type of the car being inserted.

## Sample Usage


- Which cars does 'GAS GAS GAS' dealership sell
````sql
EXEC Cars_By_Brand 'GAS GAS GAS';
````

- Create a new dealer record
````sql
EXEC New_Dealer 'Doughnutan', 'Warszawska 43, Warsaw';
````


- Remove the 'Diablo I' model from commercial vehicles
````sql
EXEC Delete_Commercial_Vehicle 'Diablo I';
````


- Update the dealer's address
````sql
EXEC New_Address 'Satan', 'Hell';
````

- Record a car sale
````sql
EXEC Sold_Car 1, 'WBAPY51010CX14136', 300000.00;
````

- Calculate the installment cost for purchasing the car with the given VIN in 24 installments
````sql
SELECT dbo.Installment_Cost('SAJAF51276BE94147', 24);
````

- Calculate the installment cost for purchasing the car with the given VIN in 24 installments
````sql
SELECT * FROM dbo.Older_Models(2000) ORDER BY year_introduced;
````

- Get a list of older models introduced before the year 2000
````sql
INSERT INTO Car VALUES
('BSFDGSRGE45235532', 15850.00, 'semiautomatic', 2016, 'Germany', 12, 10); 
````
