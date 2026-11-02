-- 1. Добавление description
ALTER TABLE product ADD COLUMN description TEXT;

-- Проверка 1
PRAGMA table_info(product);

-- 2. name → title
ALTER TABLE product RENAME COLUMN name TO title;

-- Проверка 2
PRAGMA table_info(product);

-- 3. Удаление description
ALTER TABLE product DROP COLUMN description;

-- Проверка 3
PRAGMA table_info(product);

-- 4. category → categories
ALTER TABLE category RENAME TO categories;

-- 5. Удаление product
DROP TABLE product;

-- Подготовка независимых задач 6–9 после удаления
CREATE TABLE product(id INTEGER PRIMARY KEY,title TEXT,price TEXT);

-- Учебные данные для задач 6–9
INSERT INTO product VALUES(1,'Хлеб','40'),(2,'Мыло','80'),(3,'Молоко','60'),(4,'Сыр','200'),(5,'Чай','150');

-- 6. Начало пересоздания для DEFAULT
SAVEPOINT add_created;

-- 6. Новая структура с DEFAULT
CREATE TABLE product_dated(id INTEGER PRIMARY KEY,title TEXT,price TEXT,created TEXT DEFAULT(date('now')));

-- 6. Копирование, дата заполняется автоматически
INSERT INTO product_dated(id,title,price) SELECT id,title,price FROM product;

-- 6. Удаление прежней таблицы
DROP TABLE product;

-- 6. Переименование
ALTER TABLE product_dated RENAME TO product;

-- 6. Фиксация
RELEASE add_created;

-- 6. Проверка
SELECT * FROM product;

-- 7–9*. Начало пересоздания с сохранением данных
SAVEPOINT change_type;

-- 7. Новый тип price
CREATE TABLE product_real(id INTEGER PRIMARY KEY,title TEXT,price REAL,created TEXT DEFAULT(date('now')));

-- 7. Копирование с CAST
INSERT INTO product_real SELECT id,title,CAST(price AS REAL),created FROM product;

-- 7. Удаление старой таблицы
DROP TABLE product;

-- 7. Переименование
ALTER TABLE product_real RENAME TO product;

-- 8. Таблица с CHECK
CREATE TABLE product_checked(id INTEGER PRIMARY KEY,title TEXT,price REAL CHECK(price>=0),created TEXT DEFAULT(date('now')));

-- 8. Копирование
INSERT INTO product_checked SELECT * FROM product;

-- 8. Удаление
DROP TABLE product;

-- 8. Переименование
ALTER TABLE product_checked RENAME TO product;

-- 9*. Фиксация
RELEASE change_type;

-- 7–9. Проверка типа и данных
SELECT *,typeof(price) AS price_type FROM product;

-- Предсказание: добавление нового столбца
ALTER TABLE product ADD COLUMN new_col TEXT;

-- Предсказание: число строк
SELECT COUNT(*) AS count_rows FROM product;
