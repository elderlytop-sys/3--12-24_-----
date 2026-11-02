PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;

-- 1. Категории: уникальное название
CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 2–3. Товары: ссылка на категорию и положительная цена
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    category_id INTEGER NOT NULL,
    created TEXT NOT NULL DEFAULT (date('now')),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- 6. Поставщики: телефон и email уникальны
CREATE TABLE supplier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE
);

-- 7–8. Поставки: два внешних ключа, положительное количество,
-- дата по умолчанию, составной UNIQUE для пары товар–поставщик
CREATE TABLE shipment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    supplier_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    shipment_date TEXT NOT NULL DEFAULT CURRENT_DATE
        CHECK (shipment_date >= '2020-01-01'),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(id),
    UNIQUE (product_id, supplier_id)
);

-- Тестовые данные: по две и более записи в основные таблицы
INSERT INTO category (name) VALUES ('Еда'), ('Быт');
INSERT INTO product (name, price, category_id) VALUES
    ('Хлеб', 40.00, 1),
    ('Молоко', 60.00, 1),
    ('Мыло', 80.00, 2),
    ('Сыр', 200.00, 1);
INSERT INTO supplier (name, phone, email) VALUES
    ('ООО Продукты', '111-11-11', 'food@example.test'),
    ('ООО Хозтовары', '222-22-22', 'home@example.test');
INSERT INTO shipment (product_id, supplier_id, quantity) VALUES
    (1, 1, 100),
    (2, 1, 50),
    (3, 2, 30),
    (4, 2, 10);
