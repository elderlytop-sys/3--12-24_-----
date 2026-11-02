# 06. Изменение структуры таблиц

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## 1. Добавление description

```sql
ALTER TABLE product ADD COLUMN description TEXT;
```

Команда выполнена.

## Проверка 1

```sql
PRAGMA table_info(product);
```

| cid | name | type | notnull | dflt_value | pk |
| --- | --- | --- | --- | --- | --- |
| 0 | id | INTEGER | 0 | NULL | 1 |
| 1 | name | TEXT | 0 | NULL | 0 |
| 2 | price | TEXT | 0 | NULL | 0 |
| 3 | description | TEXT | 0 | NULL | 0 |

## 2. name → title

```sql
ALTER TABLE product RENAME COLUMN name TO title;
```

Команда выполнена.

## Проверка 2

```sql
PRAGMA table_info(product);
```

| cid | name | type | notnull | dflt_value | pk |
| --- | --- | --- | --- | --- | --- |
| 0 | id | INTEGER | 0 | NULL | 1 |
| 1 | title | TEXT | 0 | NULL | 0 |
| 2 | price | TEXT | 0 | NULL | 0 |
| 3 | description | TEXT | 0 | NULL | 0 |

## 3. Удаление description

```sql
ALTER TABLE product DROP COLUMN description;
```

Команда выполнена.

## Проверка 3

```sql
PRAGMA table_info(product);
```

| cid | name | type | notnull | dflt_value | pk |
| --- | --- | --- | --- | --- | --- |
| 0 | id | INTEGER | 0 | NULL | 1 |
| 1 | title | TEXT | 0 | NULL | 0 |
| 2 | price | TEXT | 0 | NULL | 0 |

## 4. category → categories

```sql
ALTER TABLE category RENAME TO categories;
```

Команда выполнена.

## 5. Удаление product

```sql
DROP TABLE product;
```

Команда выполнена.

## Подготовка независимых задач 6–9 после удаления

```sql
CREATE TABLE product(id INTEGER PRIMARY KEY,title TEXT,price TEXT);
```

Команда выполнена.

## Учебные данные для задач 6–9

```sql
INSERT INTO product VALUES(1,'Хлеб','40'),(2,'Мыло','80'),(3,'Молоко','60'),(4,'Сыр','200'),(5,'Чай','150');
```

Команда выполнена.

## 6. Начало пересоздания для DEFAULT

```sql
SAVEPOINT add_created;
```

Команда выполнена.

## 6. Новая структура с DEFAULT

```sql
CREATE TABLE product_dated(id INTEGER PRIMARY KEY,title TEXT,price TEXT,created TEXT DEFAULT(date('now')));
```

Команда выполнена.

## 6. Копирование, дата заполняется автоматически

```sql
INSERT INTO product_dated(id,title,price) SELECT id,title,price FROM product;
```

Команда выполнена.

## 6. Удаление прежней таблицы

```sql
DROP TABLE product;
```

Команда выполнена.

## 6. Переименование

```sql
ALTER TABLE product_dated RENAME TO product;
```

Команда выполнена.

## 6. Фиксация

```sql
RELEASE add_created;
```

Команда выполнена.

## 6. Проверка

```sql
SELECT * FROM product;
```

| id | title | price | created |
| --- | --- | --- | --- |
| 1 | Хлеб | 40 | 2026-10-30 |
| 2 | Мыло | 80 | 2026-10-30 |
| 3 | Молоко | 60 | 2026-10-30 |
| 4 | Сыр | 200 | 2026-10-30 |
| 5 | Чай | 150 | 2026-10-30 |

## 7–9*. Начало пересоздания с сохранением данных

```sql
SAVEPOINT change_type;
```

Команда выполнена.

## 7. Новый тип price

```sql
CREATE TABLE product_real(id INTEGER PRIMARY KEY,title TEXT,price REAL,created TEXT DEFAULT(date('now')));
```

Команда выполнена.

## 7. Копирование с CAST

```sql
INSERT INTO product_real SELECT id,title,CAST(price AS REAL),created FROM product;
```

Команда выполнена.

## 7. Удаление старой таблицы

```sql
DROP TABLE product;
```

Команда выполнена.

## 7. Переименование

```sql
ALTER TABLE product_real RENAME TO product;
```

Команда выполнена.

## 8. Таблица с CHECK

```sql
CREATE TABLE product_checked(id INTEGER PRIMARY KEY,title TEXT,price REAL CHECK(price>=0),created TEXT DEFAULT(date('now')));
```

Команда выполнена.

## 8. Копирование

```sql
INSERT INTO product_checked SELECT * FROM product;
```

Команда выполнена.

## 8. Удаление

```sql
DROP TABLE product;
```

Команда выполнена.

## 8. Переименование

```sql
ALTER TABLE product_checked RENAME TO product;
```

Команда выполнена.

## 9*. Фиксация

```sql
RELEASE change_type;
```

Команда выполнена.

## 7–9. Проверка типа и данных

```sql
SELECT *,typeof(price) AS price_type FROM product;
```

| id | title | price | created | price_type |
| --- | --- | --- | --- | --- |
| 1 | Хлеб | 40.0 | 2026-10-30 | real |
| 2 | Мыло | 80.0 | 2026-10-30 | real |
| 3 | Молоко | 60.0 | 2026-10-30 | real |
| 4 | Сыр | 200.0 | 2026-10-30 | real |
| 5 | Чай | 150.0 | 2026-10-30 | real |

## Предсказание: добавление нового столбца

```sql
ALTER TABLE product ADD COLUMN new_col TEXT;
```

Команда выполнена.

## Предсказание: число строк

```sql
SELECT COUNT(*) AS count_rows FROM product;
```

| count_rows |
| --- |
| 5 |

## Ответы и пояснения

Задание 5 удаляет product, поэтому для 6–9 таблица создана заново с явно указанными учебными данными. Это отдельные этапы, а не восстановление удалённых данных.
В SQLite нельзя выполнить ALTER COLUMN price TYPE REAL. Тип меняется пересозданием с копированием и CAST; CHECK добавлен отдельным пересозданием. SAVEPOINT делает последовательность изменений атомарной при штатном выполнении; при ошибке следует ROLLBACK TO change_type.
ADD COLUMN created TEXT DEFAULT(date('now')) на заполненной таблице недопустим: ALTER TABLE не разрешает такое выражение DEFAULT. Поэтому в задании 6 выполнено пересоздание, а DEFAULT задан в CREATE TABLE.
После ADD COLUMN new_col количество строк остаётся 5, новый столбец содержит NULL. DROP COLUMN требует SQLite 3.35+.
