-- 1. Дороже средней
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product);

-- 2. Категория Еда
SELECT * FROM product WHERE category_id IN(SELECT id FROM category WHERE name='Еда');

-- 3. Категории с товарами
SELECT * FROM category c WHERE EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id);

-- 4. Категории без товаров
SELECT * FROM category c WHERE NOT EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id);

-- 5. Максимальная цена
SELECT * FROM product WHERE price=(SELECT MAX(price) FROM product);

-- 6. Дороже средней своей категории
SELECT * FROM product p WHERE price>(SELECT AVG(price) FROM product x WHERE x.category_id=p.category_id);

-- 7. Дороже максимума категории 2
SELECT * FROM product WHERE price>(SELECT MAX(price) FROM product WHERE category_id=2);

-- 8. Средняя цена категории выше 100
SELECT * FROM category c WHERE (SELECT AVG(price) FROM product p WHERE p.category_id=c.id)>100;

-- Продвинутый случай: два CTE
WITH averages AS (SELECT category_id,AVG(price) AS avg_price FROM product GROUP BY category_id), maxima AS (SELECT category_id,MAX(price) AS max_price FROM product GROUP BY category_id) SELECT c.id,c.name,a.avg_price,m.max_price FROM category c JOIN averages a ON a.category_id=c.id JOIN maxima m ON m.category_id=c.id ORDER BY c.id;
