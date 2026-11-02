-- 01. Все заказ-наряды, от новых к старым.
SELECT order_id, received_at, issue_description
FROM repair_orders
ORDER BY received_at DESC;

-- 02. Заказы с клиентом, устройством, мастером и статусом (JOIN).
SELECT ro.order_id, c.full_name AS customer, d.brand, d.model,
       e.full_name AS employee, rs.status_name, ro.received_at
FROM repair_orders ro
JOIN devices d ON d.device_id = ro.device_id
JOIN customers c ON c.customer_id = d.customer_id
JOIN employees e ON e.employee_id = ro.employee_id
JOIN repair_statuses rs ON rs.status_id = ro.status_id
ORDER BY ro.order_id;

-- 03. Заказы, которые ещё не завершены.
SELECT ro.order_id, ro.issue_description, rs.status_name
FROM repair_orders ro
JOIN repair_statuses rs ON rs.status_id = ro.status_id
WHERE rs.is_final = 0
ORDER BY ro.received_at;

-- 04. Количество заказов по каждому статусу (агрегат).
SELECT rs.status_name, COUNT(ro.order_id) AS orders_count
FROM repair_statuses rs
LEFT JOIN repair_orders ro ON ro.status_id = rs.status_id
GROUP BY rs.status_id, rs.status_name
ORDER BY orders_count DESC;

-- 05. Выручка по видам услуг на основании цены в заказ-наряде.
SELECT s.service_name, SUM(os.quantity * os.unit_price) AS service_revenue
FROM order_services os
JOIN services s ON s.service_id = os.service_id
GROUP BY s.service_id, s.service_name
ORDER BY service_revenue DESC;

-- 06. Клиенты с количеством обращений.
SELECT c.customer_id, c.full_name, COUNT(ro.order_id) AS orders_count
FROM customers c
JOIN devices d ON d.customer_id = c.customer_id
JOIN repair_orders ro ON ro.device_id = d.device_id
GROUP BY c.customer_id, c.full_name
ORDER BY orders_count DESC, c.full_name;

-- 07. Стоимость работ по каждому заказу.
SELECT ro.order_id, SUM(os.quantity * os.unit_price) AS order_total
FROM repair_orders ro
LEFT JOIN order_services os ON os.order_id = ro.order_id
GROUP BY ro.order_id
ORDER BY order_total DESC;

-- 08. Средняя стоимость заказа (агрегат и JOIN).
SELECT ROUND(AVG(order_total), 2) AS average_order_cost
FROM (
    SELECT ro.order_id, SUM(os.quantity * os.unit_price) AS order_total
    FROM repair_orders ro
    JOIN order_services os ON os.order_id = ro.order_id
    GROUP BY ro.order_id
);

-- 09. Количество заказов у каждого мастера.
SELECT e.full_name, COUNT(ro.order_id) AS orders_count
FROM employees e
LEFT JOIN repair_orders ro ON ro.employee_id = e.employee_id
GROUP BY e.employee_id, e.full_name
ORDER BY orders_count DESC;

-- 10. Заказы, стоимость которых выше средней стоимости заказов (подзапрос).
SELECT totals.order_id, totals.order_total
FROM (
    SELECT ro.order_id, SUM(os.quantity * os.unit_price) AS order_total
    FROM repair_orders ro
    JOIN order_services os ON os.order_id = ro.order_id
    GROUP BY ro.order_id
) AS totals
WHERE totals.order_total > (
    SELECT AVG(order_total)
    FROM (
        SELECT SUM(os2.quantity * os2.unit_price) AS order_total
        FROM order_services os2
        GROUP BY os2.order_id
    )
)
ORDER BY totals.order_total DESC;

-- 11. Клиенты, у которых ещё не было ремонтов (NOT EXISTS).
SELECT c.customer_id, c.full_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM devices d
    JOIN repair_orders ro ON ro.device_id = d.device_id
    WHERE d.customer_id = c.customer_id
);

-- 12. Устройства, которые ещё не поступали в ремонт.
SELECT d.device_id, d.brand, d.model, d.serial_number
FROM devices d
WHERE NOT EXISTS (
    SELECT 1 FROM repair_orders ro WHERE ro.device_id = d.device_id
);

-- 13. Пять последних поступивших устройств.
SELECT ro.order_id, ro.received_at, d.brand, d.model
FROM repair_orders ro
JOIN devices d ON d.device_id = ro.device_id
ORDER BY ro.received_at DESC
LIMIT 5;

-- 14. Услуги, цена которых выше средней цены по справочнику.
SELECT service_name, standard_price
FROM services
WHERE standard_price > (SELECT AVG(standard_price) FROM services)
ORDER BY standard_price DESC;

-- 15. Количество устройств каждого типа.
SELECT dt.type_name, COUNT(d.device_id) AS devices_count
FROM device_types dt
LEFT JOIN devices d ON d.type_id = dt.type_id
GROUP BY dt.type_id, dt.type_name
ORDER BY devices_count DESC;
