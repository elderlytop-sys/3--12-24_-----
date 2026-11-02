# 12. Подзапросы

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## 1. Дороже средней

```sql
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product);
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |

## 2. Категория Еда

```sql
SELECT * FROM product WHERE category_id IN(SELECT id FROM category WHERE name='Еда');
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 1 | Хлеб | 40.0 | 1 |
| 2 | Молоко | 60.0 | 1 |
| 4 | Чай | 150.0 | 1 |
| 7 | Морковь | 30.0 | 1 |
| 10 | Кофе | 350.0 | 1 |

## 3. Категории с товарами

```sql
SELECT * FROM category c WHERE EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id);
```

| id | name |
| --- | --- |
| 1 | Еда |
| 2 | Хозяйственные товары |
| 3 | Электроника |

## 4. Категории без товаров

```sql
SELECT * FROM category c WHERE NOT EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id);
```

| id | name |
| --- | --- |
| 4 | Книги |

## 5. Максимальная цена

```sql
SELECT * FROM product WHERE price=(SELECT MAX(price) FROM product);
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |

## 6. Дороже средней своей категории

```sql
SELECT * FROM product p WHERE price>(SELECT AVG(price) FROM product x WHERE x.category_id=p.category_id);
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 4 | Чай | 150.0 | 1 |
| 6 | Шампунь | 250.0 | 2 |
| 8 | Холодильник | 30000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |

## 7. Дороже максимума категории 2

```sql
SELECT * FROM product WHERE price>(SELECT MAX(price) FROM product WHERE category_id=2);
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |
| 9 | Наушники | 2000.0 | 3 |
| 10 | Кофе | 350.0 | 1 |

## 8. Средняя цена категории выше 100

```sql
SELECT * FROM category c WHERE (SELECT AVG(price) FROM product p WHERE p.category_id=c.id)>100;
```

| id | name |
| --- | --- |
| 1 | Еда |
| 2 | Хозяйственные товары |
| 3 | Электроника |

## Продвинутый случай: два CTE

```sql
WITH averages AS (SELECT category_id,AVG(price) AS avg_price FROM product GROUP BY category_id), maxima AS (SELECT category_id,MAX(price) AS max_price FROM product GROUP BY category_id) SELECT c.id,c.name,a.avg_price,m.max_price FROM category c JOIN averages a ON a.category_id=c.id JOIN maxima m ON m.category_id=c.id ORDER BY c.id;
```

| id | name | avg_price | max_price |
| --- | --- | --- | --- |
| 1 | Еда | 126.0 | 350.0 |
| 2 | Хозяйственные товары | 165.0 | 250.0 |
| 3 | Электроника | 16000.0 | 30000.0 |

## Ответы и пояснения

Скалярный подзапрос должен выражать одно значение. В SQLite подзапрос с несколькими строками не обязательно выдаёт ошибку: используется первая строка; без ORDER BY она не гарантирована. Для сравнения со средней используйте AVG(price), а с максимумом — MAX(price). Исходное сравнение с SELECT price WHERE category_id=1 логически неоднозначно.
Предсказание для категорий 1 и 2, когда товары есть только в первой: NOT EXISTS вернёт категорию 2.
В задании 6 товары с NULL category_id исключены: у них нет своей категории. Пустая категория имеет AVG=NULL и не проходит условие >100.
