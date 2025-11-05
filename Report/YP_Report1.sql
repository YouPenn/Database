CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF

SET SERVEROUTPUT ON;

SET LINESIZE 150
SET PAGESIZE 100

CREATE OR REPLACE PROCEDURE ShipmentReport (
p_start_date IN DATE,
p_end_date IN DATE
) AS
CURSOR customer_cursor IS
SELECT 
DISTINCT o.customer_id
FROM 
Shipment s
INNER JOIN 
Orders o ON s.order_id = o.order_id
WHERE 
s.shipping_date BETWEEN p_start_date AND p_end_date;
    
CURSOR shipment_cursor (p_customer_id NUMBER) IS
SELECT 
s.shipment_id,
o.order_id,
c.name AS customer_name,
a.detailed_address || ', ' || a.postal_code || ', ' || a.area || ', ' || a.state AS customer_address,
s.shipping_date,
s.status
FROM 
Shipment s
INNER JOIN 
Orders o ON s.order_id = o.order_id
INNER JOIN 
Customer c ON o.customer_id = c.customer_id
INNER JOIN 
Address a ON s.address_id = a.address_id
WHERE 
s.shipping_date BETWEEN p_start_date AND p_end_date
AND o.customer_id = p_customer_id;
    
v_shipment_count NUMBER := 0; -- Variable to store the total number of shipments
BEGIN
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
FOR customer_rec IN customer_cursor LOOP
FOR shipment_rec IN shipment_cursor(customer_rec.customer_id) 

LOOP
DBMS_OUTPUT.PUT_LINE('Order ID: ' || shipment_rec.order_id);
DBMS_OUTPUT.PUT_LINE('Customer Name: ' || shipment_rec.customer_name);
DBMS_OUTPUT.PUT_LINE('Customer Address: ' || shipment_rec.customer_address);
DBMS_OUTPUT.PUT_LINE('Shipment Date: ' || shipment_rec.shipping_date);
DBMS_OUTPUT.PUT_LINE('Shipment Status: ' || shipment_rec.status);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
            
v_shipment_count := v_shipment_count + 1;
END LOOP;
END LOOP;
    
DBMS_OUTPUT.PUT_LINE('Total Number of Shipments: ' || v_shipment_count);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
ROLLBACK;
END;
/

DECLARE
v_start_date DATE := TO_DATE('&p_start_date', 'YYYY-MM-DD');
v_end_date DATE := TO_DATE('&p_end_date', 'YYYY-MM-DD');
BEGIN
ShipmentReport (
p_start_date => v_start_date,
p_end_date => v_end_date
);
END;
/
