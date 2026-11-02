-- 1. Студенты и телефоны (1НФ)
SELECT s.id,s.fio,p.phone FROM nf1_student s JOIN nf1_student_phone p ON p.student_id=s.id ORDER BY s.id,p.phone;

-- 1. Студенты и дисциплины (1НФ)
SELECT s.fio,d.name AS discipline FROM nf1_student_discipline sd JOIN nf1_student s ON s.id=sd.student_id JOIN nf1_discipline d ON d.id=sd.discipline_id ORDER BY s.id,d.id;

-- 2. Оценки после приведения к 2НФ
SELECT s.fio,d.name AS discipline,g.grade FROM nf2_grade g JOIN nf2_student s ON s.id=g.student_id JOIN nf2_discipline d ON d.id=g.discipline_id ORDER BY s.id,d.id;

-- 3. Студенты и группы после приведения к 3НФ
SELECT s.id,s.fio,g.name AS group_name,g.faculty FROM nf3_student s JOIN nf3_group g ON g.id=s.group_id ORDER BY s.id;

-- 6. Заказы и клиенты
SELECT o.id,o.order_date,c.fio,c.phone FROM nf3_order o JOIN nf3_customer c ON c.id=o.customer_id ORDER BY o.id;

-- 6. Состав заказов
SELECT i.order_id,p.name AS product,p.price,i.quantity FROM nf3_order_item i JOIN nf3_product p ON p.id=i.product_id ORDER BY i.order_id,p.id;

-- 7. Сотрудники и отделы
SELECT e.fio,d.name AS department,d.manager_name FROM nf3_employee e JOIN nf3_department d ON d.id=e.department_id ORDER BY e.id;

-- 8. Нормализованное расписание
SELECT l.day,l.lesson_time,g.name AS group_name,s.name AS subject,t.fio AS teacher,r.room_number AS room FROM timetable_lesson l JOIN timetable_group g ON g.id=l.group_id JOIN timetable_subject s ON s.id=l.subject_id JOIN timetable_teacher t ON t.id=l.teacher_id JOIN timetable_room r ON r.id=l.room_id ORDER BY CASE l.day WHEN 'Пн' THEN 1 WHEN 'Вт' THEN 2 ELSE 3 END,l.lesson_time,g.id;

-- BCNF. Студенты и предметы
SELECT student,subject FROM bcnf_student_subject ORDER BY student,subject;

-- BCNF. Преподаватели и предметы
SELECT teacher,subject FROM bcnf_teacher_subject ORDER BY teacher;
