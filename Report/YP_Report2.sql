CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET SERVEROUTPUT ON;

SET LINESIZE 150
SET PAGESIZE 100

CREATE OR REPLACE PROCEDURE StallRentalReport (
p_num_of_months IN NUMBER
) AS
CURSOR rental_agreement_cursor IS
SELECT
r.stall_id,
r.rent_amount,
r.payment_frequency,
r.owner_name,
r.owner_ic,
r.contact_phone
FROM
Rental_Agreement r;
    
CURSOR stall_cursor (p_stall_id NUMBER) IS
SELECT
s.stall_name
FROM
Stall s
WHERE
s.stall_id = p_stall_id;

v_stall_id Rental_Agreement.stall_id%TYPE;
v_rental_amount Rental_Agreement.rent_amount%TYPE;
v_payment_frequency Rental_Agreement.payment_frequency%TYPE;
v_owner_name Rental_Agreement.owner_name%TYPE;
v_owner_ic Rental_Agreement.owner_ic%TYPE;
v_contact_phone Rental_Agreement.contact_phone%TYPE;
v_stall_name Stall.stall_name%TYPE; -- Corrected declaration here
v_total_rent NUMBER := 0;
BEGIN
OPEN rental_agreement_cursor;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');

LOOP
FETCH rental_agreement_cursor INTO
v_stall_id,
v_rental_amount,
v_payment_frequency,
v_owner_name,
v_owner_ic,
v_contact_phone;

EXIT WHEN rental_agreement_cursor%NOTFOUND;

OPEN stall_cursor(v_stall_id);
FETCH stall_cursor INTO v_stall_name;
CLOSE stall_cursor;

DBMS_OUTPUT.PUT_LINE('Stall ID: ' || v_stall_id);
DBMS_OUTPUT.PUT_LINE('Stall Name: ' || v_stall_name);

IF v_payment_frequency = 'Monthly' THEN
DBMS_OUTPUT.PUT_LINE('Total Rent: ' || v_rental_amount * p_num_of_months);
v_total_rent := v_total_rent + (v_rental_amount * p_num_of_months);
ELSIF v_payment_frequency = 'Yearly' THEN
DBMS_OUTPUT.PUT_LINE('Total Rent: ' || (v_rental_amount / 12) * p_num_of_months);
v_total_rent := v_total_rent + ((v_rental_amount / 12) * p_num_of_months);
ELSE
DBMS_OUTPUT.PUT_LINE('Invalid payment frequency.');
END IF;

DBMS_OUTPUT.PUT_LINE('Owner Name: ' || v_owner_name);
DBMS_OUTPUT.PUT_LINE('Owner IC: ' || v_owner_ic);
DBMS_OUTPUT.PUT_LINE('Contact Phone: ' || v_contact_phone);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
END LOOP;

CLOSE rental_agreement_cursor;

DBMS_OUTPUT.PUT_LINE('Total Rent of all stalls: ' || v_total_rent);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');

COMMIT;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

DECLARE
v_num_of_months NUMBER := &p_num_of_months;
BEGIN
StallRentalReport (
p_num_of_months => v_num_of_months
);
END;
/
