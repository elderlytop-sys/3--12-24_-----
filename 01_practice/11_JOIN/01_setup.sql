PRAGMA foreign_keys = ON;
CREATE TABLE category (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE supplier (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);
CREATE TABLE product (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price >= 0),
    category_id INTEGER REFERENCES category(id),
    supplier_id INTEGER REFERENCES supplier(id)
);
INSERT INTO category VALUES (1,'Еда'),(2,'Быт'),(3,'Напитки');
INSERT INTO supplier VALUES (1,'ООО Продукты'),(2,'ООО Хозтовары'),(3,'ООО Напитки');
INSERT INTO product VALUES
(1,'Хлеб',40,1,1),
(2,'Мыло',80,2,2),
(3,'Молоко',60,1,1),
(4,'Сыр',200,NULL,2),
(5,'Чай',150,1,1);
