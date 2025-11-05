CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET LINESIZE 200
SET PAGESIZE 100


SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Update_Staff (
v_staff_id IN NUMBER,
v_new_stall_id IN NUMBER,
v_new_role_id IN NUMBER,
v_new_staff_name IN VARCHAR2,
v_new_hourly_rate IN NUMBER
) AS
BEGIN
UPDATE Staff
SET stall_id = v_new_stall_id,
role_id = v_new_role_id,
staff_name = v_new_staff_name,
hourly_rate = v_new_hourly_rate
WHERE staff_id = v_staff_id;
    
COMMIT;

DBMS_OUTPUT.PUT_LINE('Staff with ID ' || v_staff_id || ' updated successfully.');
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

DECLARE
v_staff_id NUMBER := &staff_id;
v_stall_id NUMBER := &stall_id;
v_role_id NUMBER := &role_id;
v_staff_name VARCHAR2(100) := '&staff_name';
v_hourly_rate NUMBER := &hourly_rate;
BEGIN
Update_Staff(
v_staff_id,
v_stall_id,
v_role_id,
v_staff_name,
v_hourly_rate
);
END;
/
