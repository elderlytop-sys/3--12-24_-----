# 09. Выборка данных SELECT

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## 1. Цена > 100

```sql
SELECT * FROM product WHERE price>100;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 3 | Сыр | 200.0 | NULL |
| 4 | Чай | 150.0 | 1 |
| 6 | Шампунь | 250.0 | 2 |
| 8 | Холодильник | 30000.0 | 3 |
| 9 | Наушники | 2000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |

## 2. Цена от 50 до 200 включительно

```sql
SELECT * FROM product WHERE price BETWEEN 50 AND 200;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 2 | Молоко | 60.0 | 1 |
| 3 | Сыр | 200.0 | NULL |
| 4 | Чай | 150.0 | 1 |
| 5 | Мыло | 80.0 | 2 |

## 3. Название начинается на Х

```sql
SELECT * FROM product WHERE name LIKE 'Х%';
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 1 | Хлеб | 40.0 | 1 |
| 8 | Холодильник | 30000.0 | 3 |

## 4. Без категории

```sql
SELECT * FROM product WHERE category_id IS NULL;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 3 | Сыр | 200.0 | NULL |

## 5. По убыванию цены

```sql
SELECT * FROM product ORDER BY price DESC,id;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |
| 9 | Наушники | 2000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |
| 6 | Шампунь | 250.0 | 2 |
| 3 | Сыр | 200.0 | NULL |
| 4 | Чай | 150.0 | 1 |
| 5 | Мыло | 80.0 | 2 |
| 2 | Молоко | 60.0 | 1 |
| 1 | Хлеб | 40.0 | 1 |
| 7 | Морковь | 30.0 | 1 |

## 6. Первые три по id

```sql
SELECT * FROM product ORDER BY id LIMIT 3;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 1 | Хлеб | 40.0 | 1 |
| 2 | Молоко | 60.0 | 1 |
| 3 | Сыр | 200.0 | NULL |

## 7. Целая цена кратна десяти

```sql
SELECT * FROM product WHERE price=CAST(price AS INTEGER) AND CAST(price AS INTEGER)%10=0;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 1 | Хлеб | 40.0 | 1 |
| 2 | Молоко | 60.0 | 1 |
| 3 | Сыр | 200.0 | NULL |
| 4 | Чай | 150.0 | 1 |
| 5 | Мыло | 80.0 | 2 |
| 6 | Шампунь | 250.0 | 2 |
| 7 | Морковь | 30.0 | 1 |
| 8 | Холодильник | 30000.0 | 3 |
| 9 | Наушники | 2000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |

## 8. Название содержит о

```sql
SELECT * FROM product WHERE name LIKE '%о%';
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 2 | Молоко | 60.0 | 1 |
| 5 | Мыло | 80.0 | 2 |
| 7 | Морковь | 30.0 | 1 |
| 8 | Холодильник | 30000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |

## 9*. Дороже средней, с категорией, пять самых дорогих

```sql
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product) AND category_id IS NOT NULL ORDER BY price DESC,id LIMIT 5;
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |

## Продвинутый пример LOWER (ASCII)

```sql
SELECT LOWER('MILK') AS lower_ascii,LOWER('Молоко') AS lower_cyrillic;
```

| lower_ascii | lower_cyrillic |
| --- | --- |
| milk | Молоко |

## Поиск М/м в стандартном SQLite

```sql
SELECT * FROM product WHERE LOWER(name) LIKE 'м%' OR name LIKE 'М%';
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 2 | Молоко | 60.0 | 1 |
| 5 | Мыло | 80.0 | 2 |
| 7 | Морковь | 30.0 | 1 |

## Предсказание на отдельном наборе

```sql
WITH example(name,price) AS (VALUES('Хлеб',40),('Молоко',60),('Мыло',80),('Морковь',30)) SELECT * FROM example WHERE name LIKE 'М%' ORDER BY price LIMIT 2;
```

| name | price |
| --- | --- |
| Морковь | 30 |
| Молоко | 60 |

## Ответы и пояснения

AND имеет приоритет выше OR: исходный запрос означает price>100 OR (price<50 AND category_id=1). Если категория 1 нужна для обеих ценовых ветвей: WHERE (price>100 OR price<50) AND category_id=1. Синтаксической ошибки нет, ошибка зависит от намерения.
В задаче 7 «заканчивается на 0» трактуется как целая цена, кратная 10; у REAL текстовое представление вроде 40.0 не является надёжным критерием.
Предсказание: Морковь 30, Молоко 60.
В стандартной SQLite LOWER и регистронезависимый LIKE работают с ASCII, но не приводят русские заглавные буквы к строчным. Для общего Unicode-поиска нужен ICU либо пользовательская функция; для указанной буквы приведён переносимый вариант с М и м. Без ORDER BY понятие «первые» не определено.
