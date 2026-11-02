PRAGMA foreign_keys = ON;

-- Задача 1. 1НФ: повторяющиеся значения вынесены в отдельные строки.
CREATE TABLE nf1_student (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL
);
CREATE TABLE nf1_student_phone (
    student_id INTEGER NOT NULL REFERENCES nf1_student(id),
    phone TEXT NOT NULL,
    PRIMARY KEY (student_id, phone)
);
CREATE TABLE nf1_discipline (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE nf1_student_discipline (
    student_id INTEGER NOT NULL REFERENCES nf1_student(id),
    discipline_id INTEGER NOT NULL REFERENCES nf1_discipline(id),
    PRIMARY KEY (student_id, discipline_id)
);
INSERT INTO nf1_student VALUES (1,'Иванов И.И.'),(2,'Петров П.П.'),(3,'Сидоров С.С.');
INSERT INTO nf1_student_phone VALUES
(1,'111-22-33'),(1,'444-55-66'),(2,'555-66-77'),(3,'888-99-00'),(3,'123-45-67');
INSERT INTO nf1_discipline VALUES (10,'Математика'),(11,'Физика'),(12,'Химия'),(13,'Биология');
INSERT INTO nf1_student_discipline VALUES
(1,10),(1,11),(2,10),(3,12),(3,13),(3,11);

-- Задача 2. 2НФ: сведения о студенте и дисциплине отделены от оценки.
CREATE TABLE nf2_student (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL
);
CREATE TABLE nf2_discipline (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE nf2_grade (
    student_id INTEGER NOT NULL REFERENCES nf2_student(id),
    discipline_id INTEGER NOT NULL REFERENCES nf2_discipline(id),
    grade INTEGER NOT NULL CHECK (grade BETWEEN 2 AND 5),
    PRIMARY KEY (student_id, discipline_id)
);
INSERT INTO nf2_student VALUES (1,'Иванов'),(2,'Петров'),(3,'Сидоров');
INSERT INTO nf2_discipline VALUES (10,'Математика'),(11,'Физика');
INSERT INTO nf2_grade VALUES (1,10,5),(1,11,4),(2,10,3),(3,11,5);

-- Задача 3. 3НФ: факультет хранится в таблице группы, а студент ссылается на группу.
CREATE TABLE nf3_group (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    faculty TEXT NOT NULL
);
CREATE TABLE nf3_student (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL,
    group_id INTEGER NOT NULL REFERENCES nf3_group(id)
);
INSERT INTO nf3_group VALUES (1,'ИС-31','Информатики'),(2,'ЭК-21','Экономики'),(3,'ИС-32','Информатики');
INSERT INTO nf3_student VALUES
(1,'Иванов',1),(2,'Петров',1),(3,'Сидоров',2),(4,'Кузнецов',2),(5,'Смирнов',3);

-- Задача 6. Заказы в 3НФ.
CREATE TABLE nf3_customer (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL,
    phone TEXT NOT NULL
);
CREATE TABLE nf3_order (
    id INTEGER PRIMARY KEY,
    order_date TEXT NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES nf3_customer(id)
);
CREATE TABLE nf3_product (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price >= 0)
);
CREATE TABLE nf3_order_item (
    order_id INTEGER NOT NULL REFERENCES nf3_order(id),
    product_id INTEGER NOT NULL REFERENCES nf3_product(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id)
);
INSERT INTO nf3_customer VALUES (1,'Иванов','111'),(2,'Петров','444');
INSERT INTO nf3_order VALUES (1,'01.02',1),(2,'02.02',2),(3,'03.02',1);
INSERT INTO nf3_product VALUES (1,'Хлеб',40),(2,'Молоко',60),(3,'Мыло',80);
INSERT INTO nf3_order_item VALUES (1,1,2),(1,2,1),(2,1,3),(3,3,1);

-- Задача 7. Сотрудники и отделы в 3НФ.
CREATE TABLE nf3_department (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    manager_name TEXT NOT NULL
);
CREATE TABLE nf3_employee (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL,
    department_id INTEGER NOT NULL REFERENCES nf3_department(id)
);
INSERT INTO nf3_department VALUES (1,'Бухгалтерия','Петров'),(2,'IT','Смирнов');
INSERT INTO nf3_employee VALUES (1,'Иванов',1),(2,'Сидоров',1),(3,'Кузнецов',2),(4,'Морозов',2);

-- Задача 8. Расписание: справочники отделены от строк расписания.
CREATE TABLE timetable_group (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE timetable_subject (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE timetable_teacher (
    id INTEGER PRIMARY KEY,
    fio TEXT NOT NULL
);
CREATE TABLE timetable_room (
    id INTEGER PRIMARY KEY,
    room_number TEXT NOT NULL UNIQUE
);
CREATE TABLE timetable_lesson (
    day TEXT NOT NULL,
    lesson_time TEXT NOT NULL,
    group_id INTEGER NOT NULL REFERENCES timetable_group(id),
    subject_id INTEGER NOT NULL REFERENCES timetable_subject(id),
    teacher_id INTEGER NOT NULL REFERENCES timetable_teacher(id),
    room_id INTEGER NOT NULL REFERENCES timetable_room(id),
    PRIMARY KEY (day, lesson_time, group_id)
);
INSERT INTO timetable_group VALUES (1,'ИС-31'),(2,'ЭК-21');
INSERT INTO timetable_subject VALUES (1,'Математика'),(2,'Физика'),(3,'Экономика');
INSERT INTO timetable_teacher VALUES (1,'Петров'),(2,'Сидоров'),(3,'Кузнецов');
INSERT INTO timetable_room VALUES (101,'101'),(202,'202'),(303,'303');
INSERT INTO timetable_lesson VALUES
('Пн','9:00',1,1,1,101),('Пн','10:30',1,2,2,202),
('Вт','9:00',1,1,1,101),('Вт','9:00',2,3,3,303),
('Ср','9:00',1,2,2,202);

-- Задача со звёздочкой. Декомпозиция BCNF по зависимости преподаватель -> предмет.
CREATE TABLE bcnf_student_subject (
    student TEXT NOT NULL,
    subject TEXT NOT NULL,
    PRIMARY KEY (student, subject)
);
CREATE TABLE bcnf_teacher_subject (
    teacher TEXT PRIMARY KEY,
    subject TEXT NOT NULL
);
INSERT INTO bcnf_student_subject VALUES
('Иванов','Математика'),('Иванов','Физика'),('Петров','Математика'),('Сидоров','Физика');
INSERT INTO bcnf_teacher_subject VALUES ('Петров','Математика'),('Сидоров','Физика');
