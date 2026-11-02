-- План до индексов
EXPLAIN QUERY PLAN SELECT * FROM product WHERE price>100;

-- 1. Индекс цены
CREATE INDEX idx_product_price ON product(price);

-- 2. Индекс имени
CREATE INDEX idx_product_name ON product(name);

-- 3. Составной индекс
CREATE INDEX idx_product_cat_price ON product(category_id,price);

-- 4. План по цене
EXPLAIN QUERY PLAN SELECT * FROM product WHERE price>100;

-- 4. План составного индекса
EXPLAIN QUERY PLAN SELECT * FROM product WHERE category_id=1 AND price>100;

-- 5. Удаление индекса имени
DROP INDEX idx_product_name;

-- 6. Уникальный индекс
CREATE UNIQUE INDEX idx_product_name_unique ON product(name);

-- 7. Индекс имени и категории
CREATE INDEX idx_product_name_cat ON product(name,category_id);

-- 9*. Индекс выражения
CREATE INDEX idx_product_lower_name ON product(LOWER(name));

-- 9*. Проверка плана выражения
EXPLAIN QUERY PLAN SELECT * FROM product WHERE LOWER(name)=LOWER('Хлеб');

-- Итоговый список индексов
PRAGMA index_list(product);
