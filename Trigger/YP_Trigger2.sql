CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF


SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER Staff_Update_Trigger
BEFORE UPDATE ON Staff
FOR EACH ROW
BEGIN   
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Staff_ID: ' || :OLD.staff_id);     
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Old Stall_ID: ' || :OLD.stall_id);
DBMS_OUTPUT.PUT_LINE('Old Role_ID: ' || :OLD.role_id);
DBMS_OUTPUT.PUT_LINE('Old Staff_Name: ' || :OLD.staff_name);
DBMS_OUTPUT.PUT_LINE('Old Hourly_Rate: ' || :OLD.hourly_rate);
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('New Stall_ID: ' || :NEW.stall_id);
DBMS_OUTPUT.PUT_LINE('New Role_ID: ' || :NEW.role_id);
DBMS_OUTPUT.PUT_LINE('New Staff_Name: ' || :NEW.staff_name);
DBMS_OUTPUT.PUT_LINE('New Hourly_Rate: ' || :NEW.hourly_rate);       
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
END;
/
