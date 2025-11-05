CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER Role_Deletion_Check
BEFORE DELETE ON Role
FOR EACH ROW
BEGIN
IF :OLD.role_id = 1 THEN
RAISE_APPLICATION_ERROR(-20001, 'Role with role_id = 1 cannot be deleted.');
ELSE
-- Update the role_id in the Staff table to a default value
UPDATE Staff
SET role_id = 1  -- Update to the desired default role_id
WHERE role_id = :OLD.role_id;

DBMS_OUTPUT.PUT_LINE('Role ID: ' || :OLD.role_id || ' Deleted successfully');
END IF;
END;
/
