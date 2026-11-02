-- Запускать в новой пустой базе. Учебные данные составлены для задания.
CREATE TABLE category(id INTEGER PRIMARY KEY,name TEXT);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT,price TEXT);
INSERT INTO product VALUES(1,'Хлеб','40'),(2,'Мыло','80'),(3,'Молоко','60'),(4,'Сыр','200'),(5,'Чай','150');
