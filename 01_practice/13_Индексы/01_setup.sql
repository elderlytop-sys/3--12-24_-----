-- Запускать в новой пустой базе. Учебные данные составлены для задания.
PRAGMA foreign_keys = ON;
CREATE TABLE category(id INTEGER PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT NOT NULL, price REAL NOT NULL CHECK(price>=0), category_id INTEGER REFERENCES category(id));
INSERT INTO category VALUES(1,'Еда'),(2,'Хозяйственные товары'),(3,'Электроника'),(4,'Книги');
INSERT INTO product VALUES(1,'Хлеб',40,1),(2,'Молоко',60,1),(3,'Сыр',200,NULL),(4,'Чай',150,1),(5,'Мыло',80,2),(6,'Шампунь',250,2),(7,'Морковь',30,1),(8,'Холодильник',30000,3),(9,'Наушники',2000,3),(10,'Кофе',350,1);
