-- Створення бази даних HW_5_SQL

USE HW_5_SQL;

-- Приклад таблиць для завдань
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    date DATE,
    shipper_id INT
);

CREATE TABLE IF NOT EXISTS order_details (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);

-- Завдання 1: Відображення таблиці order_details з customer_id із таблиці orders
SELECT 
    order_details.*, 
    (SELECT customer_id FROM orders WHERE orders.id = order_details.order_id) AS customer_id
FROM 
    order_details;

-- Завдання 2: Відображення таблиці order_details із фільтром shipper_id=3
SELECT 
    *
FROM 
    order_details
WHERE 
    order_id IN (
        SELECT id 
        FROM orders 
        WHERE shipper_id = 3
    );

-- Завдання 3: Знайдіть середнє значення поля quantity, групуючи за order_id
SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM (
    SELECT 
        *
    FROM 
        order_details
    WHERE 
        quantity > 10
) AS filtered_order_details
GROUP BY 
    order_id;

-- Завдання 4: Використання оператора WITH для створення тимчасової таблиці
WITH temp AS (
    SELECT 
        *
    FROM 
        order_details
    WHERE 
        quantity > 10
)
SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM 
    temp
GROUP BY 
    order_id;

-- Завдання 5: Створення функції для поділу двох параметрів
DROP FUNCTION IF EXISTS divide;
DELIMITER //
CREATE FUNCTION divide(param1 FLOAT, param2 FLOAT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF param2 = 0 THEN
        RETURN NULL;
    END IF;
    RETURN param1 / param2;
END //
DELIMITER ;

-- Застосування функції divide до атрибута quantity таблиці order_details
SELECT 
    id AS order_detail_id, 
    divide(quantity, 2) AS divided_quantity
FROM 
    order_details;

