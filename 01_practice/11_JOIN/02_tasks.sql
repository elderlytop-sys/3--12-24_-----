-- 1. Товары с названиями категорий (INNER JOIN)
SELECT p.name AS product,c.name AS category FROM product p INNER JOIN category c ON p.category_id=c.id ORDER BY p.id;

-- 2. Все категории, включая категории без товаров (LEFT JOIN)
SELECT c.name AS category,p.name AS product FROM category c LEFT JOIN product p ON p.category_id=c.id ORDER BY c.id,p.id;

-- 3. Товары без категории (LEFT JOIN + IS NULL)
SELECT p.id,p.name FROM product p LEFT JOIN category c ON p.category_id=c.id WHERE c.id IS NULL ORDER BY p.id;

-- 4. Количество товаров в каждой категории
SELECT c.name AS category,COUNT(p.id) AS product_count FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id,c.name ORDER BY c.id;

-- 5. Товары и категории (FULL OUTER JOIN)
SELECT p.id AS product_id,p.name AS product,c.id AS category_id,c.name AS category FROM product p FULL OUTER JOIN category c ON p.category_id=c.id ORDER BY COALESCE(c.id,p.category_id),p.id;

-- 6. Категории без товаров
SELECT c.id,c.name FROM category c LEFT JOIN product p ON p.category_id=c.id WHERE p.id IS NULL ORDER BY c.id;

-- 7. Товар, категория и поставщик (три таблицы)
SELECT p.name AS product,c.name AS category,s.name AS supplier FROM product p LEFT JOIN category c ON c.id=p.category_id LEFT JOIN supplier s ON s.id=p.supplier_id ORDER BY p.id;

-- 8. Товары, категория которых начинается на «Е»
SELECT p.name AS product,c.name AS category FROM product p JOIN category c ON c.id=p.category_id WHERE c.name LIKE 'Е%' ORDER BY p.id;

-- 9*. Пары товаров из одной категории (SELF JOIN)
SELECT p1.name AS product_1,p2.name AS product_2,c.name AS category FROM product p1 JOIN product p2 ON p1.category_id=p2.category_id AND p1.id<p2.id JOIN category c ON c.id=p1.category_id ORDER BY p1.id,p2.id;

-- Поиск ошибки. Число строк при JOIN без ON
SELECT COUNT(*) AS rows_without_on FROM product p JOIN category c;

-- Предсказание результата LEFT JOIN
WITH product(name,category_id) AS (VALUES ('Хлеб',1),('Сыр',NULL)), category(id,name) AS (VALUES (1,'Еда'),(2,'Напитки')) SELECT p.name,c.name AS category FROM product p LEFT JOIN category c ON p.category_id=c.id ORDER BY p.name;

-- Продвинутый случай. RIGHT JOIN через LEFT JOIN
SELECT p.name AS product,c.name AS category FROM category c LEFT JOIN product p ON p.category_id=c.id ORDER BY c.id,p.id;
