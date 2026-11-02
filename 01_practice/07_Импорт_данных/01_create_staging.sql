CREATE TABLE tmp_product(name TEXT,price TEXT,category_id TEXT);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL,price REAL CHECK(price>=0),category_id INTEGER);
