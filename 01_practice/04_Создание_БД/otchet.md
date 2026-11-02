# 04. Введение в SQLite

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## 1–5. Три студента

```sql
SELECT * FROM student;
```

| id | fio | birth | avg |
| --- | --- | --- | --- |
| 1 | Иванов Иван Иванович | 2005-01-15 | 4.5 |
| 2 | Петров Пётр Петрович | 2004-11-02 | 3.8 |
| 3 | Сидоров Сергей Сергеевич | 2005-06-20 | 4.9 |

## 6–7. Преподаватели со стажем более 5 лет

```sql
SELECT * FROM teacher WHERE experience>5;
```

| id | fio | subject | experience |
| --- | --- | --- | --- |
| 1 | Орлова Анна | Математика | 12 |
| 3 | Смирнова Ирина | Физика | 8 |
| 5 | Кузнецова Елена | Русский язык | 20 |

## 8. Проверка BLOB

```sql
SELECT file_name,typeof(content) AS storage_type,length(content) AS bytes,hex(content) AS hex_value FROM attachment;
```

| file_name | storage_type | bytes | hex_value |
| --- | --- | --- | --- |
| sample.bin | blob | 4 | 010203FF |

## 9*. Дата по умолчанию

```sql
SELECT *,created=date('now') AS matches_today FROM event;
```

| id | title | created | matches_today |
| --- | --- | --- | --- |
| 1 | Создание базы | 2026-10-30 | 1 |

## Предсказание: версия SQLite

```sql
SELECT sqlite_version() AS version;
```

| version |
| --- |
| 3.53.1 |

## Ответы и пояснения

Изменения сохранены транзакцией commit; в DB Browser после самостоятельного выполнения нужно нажать Write Changes.
BLOB хранит двоичные данные без преобразования в текст: изображения, файлы, подписи. В примере записаны 4 байта.
В ошибочном CREATE TABLE поле id — обычный INTEGER, поэтому при пропуске значения получит NULL. INTEGER PRIMARY KEY связывает поле с rowid и позволяет автоматически назначать идентификатор; AUTOINCREMENT дополнительно запрещает повторное использование ранее выданных идентификаторов.
SELECT sqlite_version() возвращает текстовую версию используемой библиотеки, а не список таблиц. date('now') вычисляется в UTC.
