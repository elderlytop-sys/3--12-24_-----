-- 3. Заказ с отсутствующим клиентом [ОЖИДАЕТСЯ ОШИБКА; выполнять отдельно]
INSERT INTO orders VALUES(3,999);

-- 4. CASCADE: удалить клиента 1
DELETE FROM client WHERE id=1;

-- 4. Заказы удалились
SELECT COUNT(*) FROM orders;

-- 5. Создать таблицу с RESTRICT
CREATE TABLE orders_new(id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES client(id) ON DELETE RESTRICT);

-- 5. Копирование
INSERT INTO orders_new SELECT * FROM orders;

-- 5. Удалить старую
DROP TABLE orders;

-- 5. Переименование
ALTER TABLE orders_new RENAME TO orders;

-- 5. Заказ существующего клиента
INSERT INTO orders VALUES(3,2);

-- 5. Отсутствующий клиент при RESTRICT [ОЖИДАЕТСЯ ОШИБКА; выполнять отдельно]
INSERT INTO orders VALUES(4,999);

-- 5. RESTRICT запрещает удалить клиента [ОЖИДАЕТСЯ ОШИБКА; выполнять отдельно]
DELETE FROM client WHERE id=2;

-- 5. Данные сохранились
SELECT * FROM orders;

-- 6. SET NULL: удалить категорию
DELETE FROM category WHERE id=1;

-- 6. Проверка
SELECT * FROM product;

-- 7–8. Позиция заказа
INSERT INTO order_product VALUES(3,1,2);

-- 7. Второй товар того же заказа
INSERT INTO order_product VALUES(3,2,1);

-- 7. Второй заказ
INSERT INTO orders VALUES(4,2);

-- 7. Тот же товар в другом заказе
INSERT INTO order_product VALUES(4,1,1);

-- 8. Дубликат составного ключа [ОЖИДАЕТСЯ ОШИБКА; выполнять отдельно]
INSERT INTO order_product VALUES(3,1,5);

-- 7–8. Содержимое связи M:N
SELECT * FROM order_product ORDER BY order_id,product_id;

-- 9*. Иерархия сотрудников
SELECT e.name,m.name AS manager FROM employee e LEFT JOIN employee m ON m.id=e.manager_id ORDER BY e.id;

-- Проверка внешних ключей
PRAGMA foreign_key_check;