-- 1–5. Три студента
SELECT * FROM student;

-- 6–7. Преподаватели со стажем более 5 лет
SELECT * FROM teacher WHERE experience>5;

-- 8. Проверка BLOB
SELECT file_name,typeof(content) AS storage_type,length(content) AS bytes,hex(content) AS hex_value FROM attachment;

-- 9*. Дата по умолчанию
SELECT *,created=date('now') AS matches_today FROM event;

-- Предсказание: версия SQLite
SELECT sqlite_version() AS version;
