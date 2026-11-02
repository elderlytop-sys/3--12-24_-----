-- Запускать в новой пустой базе. Учебные данные составлены для задания.
CREATE TABLE student(id INTEGER PRIMARY KEY AUTOINCREMENT,fio TEXT NOT NULL,birth TEXT,avg REAL);
INSERT INTO student(fio,birth,avg) VALUES('Иванов Иван Иванович','2005-01-15',4.5),('Петров Пётр Петрович','2004-11-02',3.8),('Сидоров Сергей Сергеевич','2005-06-20',4.9);
CREATE TABLE teacher(id INTEGER PRIMARY KEY AUTOINCREMENT,fio TEXT NOT NULL,subject TEXT,experience INTEGER);
INSERT INTO teacher(fio,subject,experience) VALUES('Орлова Анна','Математика',12),('Иванов Павел','Информатика',4),('Смирнова Ирина','Физика',8),('Зайцев Олег','История',5),('Кузнецова Елена','Русский язык',20);
CREATE TABLE attachment(id INTEGER PRIMARY KEY,file_name TEXT,content BLOB);
INSERT INTO attachment VALUES(1,'sample.bin',X'010203FF');
CREATE TABLE event(id INTEGER PRIMARY KEY,title TEXT,created TEXT DEFAULT(date('now')));
INSERT INTO event(title) VALUES('Создание базы');
