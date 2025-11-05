CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET LINESIZE 87
SET PAGESIZE 100

TTITLE CENTER 'Staff Salary Summary by Stall'

CREATE OR REPLACE VIEW Staff_Salary_Summary_View AS
SELECT 
S.stall_name,
COUNT(F.staff_id) AS num_staff,
SUM(F.hourly_rate * 8) AS total_salary_for_8_hours
FROM
stall S
JOIN 
staff F ON S.stall_id = F.stall_id
JOIN 
role R ON F.role_id = R.role_id
GROUP BY
S.stall_name
ORDER BY
S.stall_name;


select * from Staff_Salary_Summary_View;