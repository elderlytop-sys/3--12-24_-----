-- 3. CASE: метка «дорого/дёшево»
SELECT name,price,CASE WHEN price IS NULL THEN 'не указана' WHEN price>100 THEN 'дорого' ELSE 'дёшево' END AS price_label FROM product ORDER BY id;

-- 4. COALESCE: NULL в category_id заменён на 0
SELECT name,COALESCE(category_id,0) AS category_id FROM product ORDER BY id;

-- 5. NULLIF: защита от деления на ноль
SELECT name,1000/NULLIF(price,0) AS ratio FROM product ORDER BY id;

-- 7. CASE с тремя ценовыми категориями
SELECT name,price,CASE WHEN price<50 THEN 'дёшево' WHEN price BETWEEN 50 AND 100 THEN 'средне' WHEN price>100 THEN 'дорого' ELSE 'не указана' END AS price_category FROM product ORDER BY id;

-- 8. COALESCE с двумя столбцами
SELECT name,COALESCE(price,0)+COALESCE(discount,0) AS price_plus_discount FROM product ORDER BY id;

-- 9*. Сортировка через CASE: дорого, средне, дёшево
SELECT name,price,CASE WHEN price>100 THEN 'дорого' WHEN price BETWEEN 50 AND 100 THEN 'средне' WHEN price<50 THEN 'дёшево' ELSE 'не указана' END AS price_category FROM product ORDER BY CASE WHEN price>100 THEN 1 WHEN price BETWEEN 50 AND 100 THEN 2 WHEN price<50 THEN 3 ELSE 4 END,price DESC;

-- Продвинутый случай. CASE в UPDATE
UPDATE price_fix_demo SET price=CASE WHEN price<0 THEN 0 ELSE price END;

-- Результат CASE в UPDATE
SELECT id,name,price FROM price_fix_demo ORDER BY id;

-- Предсказание результата COALESCE(NULL,NULL,5)
SELECT COALESCE(NULL,NULL,5) AS result;
