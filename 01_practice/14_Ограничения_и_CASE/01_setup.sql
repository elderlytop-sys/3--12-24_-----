PRAGMA foreign_keys = ON;
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    price REAL CHECK (price >= 0) DEFAULT 0,
    category_id INTEGER,
    discount REAL
);
INSERT INTO product (name,price,category_id,discount) VALUES
('Хлеб',40,1,5),
('Мыло',80,2,NULL),
('Ноутбук',150,3,20),
('Конфеты',30,1,0),
('Кофе',100,1,NULL),
('Товар без цены',NULL,NULL,NULL),
('Бесплатный образец',0,2,0);
-- Цена не указана: должен сработать DEFAULT 0.
INSERT INTO product (name,category_id,discount) VALUES ('Товар по умолчанию',2,0);

-- Отдельная демонстрационная таблица нужна, чтобы CASE в UPDATE исправил отрицательное значение.
-- В product отрицательная цена не может появиться из-за CHECK.
CREATE TABLE price_fix_demo (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL
);
INSERT INTO price_fix_demo VALUES (1,'Ошибка ввода',-15),(2,'Корректная цена',50);
