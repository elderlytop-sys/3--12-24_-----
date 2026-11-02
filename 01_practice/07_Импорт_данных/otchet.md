# 07. Импорт CSV

Рулев Никита Сергеевич, 3ИП-12-24.

Готовая practice.db создана реальным импортом CSV через Python sqlite3. Повторить: `python import_csv.py` (пересоздаёт только базу этой работы). Интерфейс DB Browser здесь не запускался; ниже приведены точные действия для воспроизведения задания 3.

1. Создать пустую БД в DB Browser, выполнить 01_create_staging.sql.
2. File → Import → Table from CSV file: products_5.csv, таблица tmp_product, разделитель запятая, UTF-8, первая строка — заголовки. Подтвердить импорт в существующую таблицу.
3. Выполнить 02_transfer.sql, нажать Write Changes. Для повторного импорта сначала очистить временную таблицу, не загружать те же строки дважды.
4. Для дополнительных CSV создавать таблицы по командам ниже, импортировать указанный CSV и выполнять следующий SQL.

## Импорт products_5.csv

Загружено строк: 5.

## 4. Приведение типов

```sql
INSERT INTO product(name,price,category_id) SELECT TRIM(name),CAST(price AS REAL),CAST(category_id AS INTEGER) FROM tmp_product;
```

Результат: `[]`

## 5. Проверка

```sql
SELECT *,typeof(price) AS price_type FROM product;
```

Результат: `[[1, "Хлеб", 40.0, 1, "real"], [2, "Молоко", 60.0, 1, "real"], [3, "Мыло", 80.0, 2, "real"], [4, "Сыр", 200.0, 1, "real"], [5, "Чай", 150.0, 1, "real"]]`

## 6. Удаление временной таблицы

```sql
DROP TABLE tmp_product;
```

Результат: `[]`

## 7. Подготовка грязных данных

```sql
CREATE TABLE tmp_dirty(name TEXT,price TEXT,category_id TEXT);
```

Результат: `[]`

## Импорт dirty.csv

Загружено строк: 3.

## 7. Очистка TRIM/LOWER

```sql
CREATE TABLE cleaned AS SELECT LOWER(TRIM(name)) AS name,CAST(TRIM(price) AS REAL) AS price,CAST(TRIM(category_id) AS INTEGER) AS category_id FROM tmp_dirty;
```

Результат: `[]`

## 7. Проверка очистки

```sql
SELECT * FROM cleaned;
```

Результат: `[["milk", 60.0, 1], ["bread", 40.0, 1], ["soap", 80.0, 2]]`

## 8. Отдельная таблица десяти записей

```sql
CREATE TABLE ten_products(name TEXT,price REAL,category_id INTEGER);
```

Результат: `[]`

## Импорт products_10.csv

Загружено строк: 10.

## 8. Проверка количества

```sql
SELECT COUNT(*) AS loaded FROM ten_products;
```

Результат: `[[10]]`

## 9. Подготовка дат

```sql
CREATE TABLE tmp_dates(name TEXT,created TEXT);
```

Результат: `[]`

## Импорт dates.csv

Загружено строк: 3.

## 9. DD.MM.YYYY → YYYY-MM-DD

```sql
CREATE TABLE dated_products AS SELECT name,substr(created,7,4)||'-'||substr(created,4,2)||'-'||substr(created,1,2) AS created FROM tmp_dates;
```

Результат: `[]`

## 9. Проверка дат

```sql
SELECT * FROM dated_products;
```

Результат: `[["Хлеб", "2026-10-30"], ["Мыло", "2025-02-01"], ["Молоко", "2026-09-15"]]`

## 10*. Исходные некорректные строки

```sql
CREATE TABLE tmp_invalid(name TEXT,price TEXT);
```

Результат: `[]`

## Импорт invalid.csv

Загружено строк: 4.

## 10*. Поиск некорректной цены

```sql
SELECT * FROM tmp_invalid WHERE NULLIF(TRIM(price),'') IS NULL OR CAST(price AS REAL)<0 OR TRIM(price) GLOB '*[^0-9.-]*' OR TRIM(price) IN ('.','-','-.') OR LENGTH(TRIM(price))-LENGTH(REPLACE(TRIM(price),'.',''))>1 OR instr(substr(TRIM(price),2),'-')>0;
```

Результат: `[["Отрицательный", "-10"], ["Пустой", ""], ["Текстовая цена", "abc"]]`

## 10*. Строки с отрицательной или NULL ценой после NULLIF/CAST

```sql
SELECT name,CAST(NULLIF(TRIM(price),'') AS REAL) AS price FROM tmp_invalid WHERE NULLIF(TRIM(price),'') IS NULL OR CAST(price AS REAL)<0;
```

Результат: `[["Отрицательный", -10.0], ["Пустой", null]]`

## Ответы

100 вместо 50: повторный импорт в заполненную таблицу без очистки или дубли в CSV. Проверить исходный CSV и COUNT(*); для уникальных данных применять ключи/UNIQUE.

Предсказание: строки Хлеб,40 и Мыло,80 попадут в TEXT/REAL; числовые строки преобразуются affinity REAL. Значения с нечисловым суффиксом могут остаться TEXT.

LOWER в стандартном SQLite работает только с ASCII. Поэтому dirty.csv содержит латинские названия разного регистра, а обычный CSV — русские. Для кириллицы нужен ICU/Unicode UDF.

Даты заданы валидными строками DD.MM.YYYY фиксированной длины. substr переставляет компоненты; это преобразование формата, а не проверка календаря.

CAST('abc' AS REAL) даёт 0, поэтому ошибку нельзя искать только через price<0: добавлена проверка текстового формата десятичных цен. Пустые поля CSV — пустая строка; NULLIF преобразует их в NULL. Проверка рассчитана на обычные десятичные числа без экспоненты и валюты.
