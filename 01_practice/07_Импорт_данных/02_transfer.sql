INSERT INTO product(name,price,category_id) SELECT TRIM(name),CAST(price AS REAL),CAST(category_id AS INTEGER) FROM tmp_product;
SELECT *,typeof(price) AS price_type FROM product;
DROP TABLE tmp_product;
