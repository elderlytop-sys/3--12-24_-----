-- Практическая работа № 05. Проверочные запросы

-- 1. Таблица category
SELECT id, name FROM category ORDER BY id;

-- 2–3. Таблица product, связь с category и положительная цена
SELECT p.id, p.name, p.price, c.name AS category, p.created
FROM product AS p
JOIN category AS c ON c.id = p.category_id
ORDER BY p.id;

-- 4. Проверка наличия минимум двух записей в category и product
SELECT 'category' AS table_name, COUNT(*) AS records FROM category
UNION ALL
SELECT 'product', COUNT(*) FROM product;

-- 5. Фактическая проверка ограничений выполняется скриптом verify_constraints.py

-- 6. Таблица supplier
SELECT id, name, phone, email FROM supplier ORDER BY id;

-- 7. Таблица shipment: связи, количество и дата по умолчанию
SELECT sh.id, p.name AS product, s.name AS supplier,
       sh.quantity, sh.shipment_date
FROM shipment AS sh
JOIN product AS p ON p.id = sh.product_id
JOIN supplier AS s ON s.id = sh.supplier_id
ORDER BY sh.id;

-- Проверка даты по умолчанию
SELECT id, shipment_date, shipment_date = CURRENT_DATE AS date_is_today
FROM shipment ORDER BY id;

-- 8. Проверка составного UNIQUE (product_id, supplier_id)
SELECT name, "unique"
FROM pragma_index_list('shipment')
WHERE "unique" = 1;

-- 9. Ограничение на дату: проверка определения CHECK в схеме
SELECT sql
FROM sqlite_master
WHERE type = 'table' AND name = 'shipment';

-- Контроль ссылочной целостности: результат должен быть пустым
PRAGMA foreign_key_check;
