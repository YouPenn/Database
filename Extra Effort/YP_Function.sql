CREATE OR REPLACE FUNCTION calculate_salary(hourly_rate NUMBER)
RETURN NUMBER
IS
total_salary NUMBER;
BEGIN
total_salary := hourly_rate * 8; 
-- Assuming 8 hours of work
RETURN total_salary;
END;
/

CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SELECT staff_name, hourly_rate, calculate_salary(hourly_rate) AS total_salary_for_8_hours
FROM staff;
