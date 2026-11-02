-- 1. Цена > 100
SELECT * FROM product WHERE price>100;

-- 2. Цена от 50 до 200 включительно
SELECT * FROM product WHERE price BETWEEN 50 AND 200;

-- 3. Название начинается на Х
SELECT * FROM product WHERE name LIKE 'Х%';

-- 4. Без категории
SELECT * FROM product WHERE category_id IS NULL;

-- 5. По убыванию цены
SELECT * FROM product ORDER BY price DESC,id;

-- 6. Первые три по id
SELECT * FROM product ORDER BY id LIMIT 3;

-- 7. Целая цена кратна десяти
SELECT * FROM product WHERE price=CAST(price AS INTEGER) AND CAST(price AS INTEGER)%10=0;

-- 8. Название содержит о
SELECT * FROM product WHERE name LIKE '%о%';

-- 9*. Дороже средней, с категорией, пять самых дорогих
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product) AND category_id IS NOT NULL ORDER BY price DESC,id LIMIT 5;

-- Продвинутый пример LOWER (ASCII)
SELECT LOWER('MILK') AS lower_ascii,LOWER('Молоко') AS lower_cyrillic;

-- Поиск М/м в стандартном SQLite
SELECT * FROM product WHERE LOWER(name) LIKE 'м%' OR name LIKE 'М%';

-- Предсказание на отдельном наборе
WITH example(name,price) AS (VALUES('Хлеб',40),('Молоко',60),('Мыло',80),('Морковь',30)) SELECT * FROM example WHERE name LIKE 'М%' ORDER BY price LIMIT 2;
