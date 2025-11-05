CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET LINESIZE 200
SET PAGESIZE 100

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Delete_Role (
v_role_id IN NUMBER
) AS
BEGIN
DBMS_OUTPUT.PUT_LINE('Deleting role with ID: ' || v_role_id);

DELETE FROM role WHERE role_id = v_role_id;

IF SQL%ROWCOUNT = 1 THEN
COMMIT;
ELSE
DBMS_OUTPUT.PUT_LINE('Error: Role with ID ' || v_role_id || ' not found or not deleted.');
END IF;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

DECLARE
v_role_id NUMBER := &role_id;
BEGIN
Delete_Role(v_role_id);
END;
/
