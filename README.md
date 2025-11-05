# Database

download "Run SQL Command Line" (Oracle Database 11g Express Edition, but this version alr cant found from official website, maybe just download lastest version)
create a new user
example name yp, password aaaaaaa

connect yp 
PW: aaaaaa

//this is the all sample data: 

@C:\Users\User\Desktop\Done\DB\ScriptFile.sql


//select query: 

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Query\YP_Query1.sql

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Query\YP_Query2.sql


Update Staff:

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Procedure\YP_Procedure1.sql

DELETE Role:

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Procedure\YP_Procedure2.sql


Show what change, 
auto change the role to 1(default) in staff table when role deleted

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Trigger\YP_Trigger1.sql

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Trigger\YP_Trigger2.sql


summary of shipments within aspecified date range:

2022-1-1

2022-1-10

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Report\YP_Report1.sql


summarise stall rentals based on the specifiednumber of months:

@C:\Users\User\Desktop\Done\DB\TeeYouPenn\Report\YP_Report2.sql



basic:

-- Select all columns from the "users" table

SELECT * FROM users;


-- Select specific columns (name and email) from the "users" table

SELECT name, email FROM users WHERE id = 1;


-- Insert a new record into the "users" table:

INSERT INTO users (id, name, email) 
VALUES (1, 'John Doe', 'john.doe@example.com');


-- Update the email of the user with id = 1:

UPDATE users 
SET email = 'john.new@example.com' 
WHERE id = 1;


-- Delete the user with id = 1 from the "users" table:

DELETE FROM users 
WHERE id = 1;


-- Create a "users" table: 
CREATE TABLE users ( 
    id INT PRIMARY KEY, 
    name VARCHAR(50), 
    email VARCHAR(100) 
);

