-- 1. Всего товаров
SELECT COUNT(*) AS total FROM product;

-- 2. Средняя цена
SELECT AVG(price) AS avg_price FROM product;

-- 3. Количество по категориям
SELECT category_id,COUNT(*) AS total FROM product GROUP BY category_id;

-- 4. Сумма по категориям
SELECT category_id,SUM(price) AS sum_price FROM product GROUP BY category_id;

-- 5. Больше двух товаров
SELECT category_id,COUNT(*) AS total FROM product GROUP BY category_id HAVING COUNT(*)>2;

-- 6. Максимум и минимум
SELECT MAX(price) AS maximum,MIN(price) AS minimum FROM product;

-- 7. Средняя выше 100
SELECT category_id,AVG(price) AS avg_price FROM product GROUP BY category_id HAVING AVG(price)>100;

-- 8. Дороже средней
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product);

-- 9*. Сводка по средней цене
SELECT category_id,COUNT(*) AS total,AVG(price) AS avg_price,MAX(price) AS max_price FROM product GROUP BY category_id ORDER BY avg_price DESC;

-- Продвинутый случай
SELECT COUNT(DISTINCT category_id) AS categories_with_products FROM product;
