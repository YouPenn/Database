CREATE OR REPLACE PROCEDURE UpdateRentalAgreementStatus (
p_rental_agreement_id IN NUMBER,
p_status IN VARCHAR2
)
IS
v_invalid_status EXCEPTION;
BEGIN
-- Check if the provided status is valid
IF p_status NOT IN ('Active', 'Inactive') THEN
-- Raise the custom exception if the status is invalid
RAISE v_invalid_status;
ELSE
-- Update the status if it is valid
UPDATE Rental_Agreement
SET status = p_status
WHERE rental_agreement_id = p_rental_agreement_id;
END IF;
EXCEPTION
WHEN v_invalid_status THEN
-- Handle the exception for invalid status
DBMS_OUTPUT.PUT_LINE('---------------------------------------');
DBMS_OUTPUT.PUT_LINE('Error: Invalid rental agreement status.');
DBMS_OUTPUT.PUT_LINE('---------------------------------------');
WHEN OTHERS THEN
-- Handle any other exceptions
DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


SET SERVEROUTPUT ON;

DECLARE
v_rental_agreement_id NUMBER := &p_rental_agreement_id;
v_status VARCHAR2(20) := '&p_status';
BEGIN
UpdateRentalAgreementStatus(v_rental_agreement_id, v_status); 
END;
/
