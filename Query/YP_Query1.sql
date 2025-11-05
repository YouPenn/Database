CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

set linesize 133
set pagesize 100

TTITLE CENTER 'Shipment History for 2021' -
RIGHT 'PAGE:' FORMAT 999 SQL.PNO SKIP 2

BREAK ON date

SELECT 
S.shipping_date AS "DATE",
S.status AS shipment_status,
C.name AS customer_name,
O.type AS order_type
FROM shipment S
JOIN orders O ON S.order_id = O.order_id  
JOIN customer C ON O.customer_id = C.customer_id 
WHERE TO_CHAR(S.shipping_date, 'YYYY') = '2021' AND O.type = 'Delivery'
ORDER BY S.shipping_date;
