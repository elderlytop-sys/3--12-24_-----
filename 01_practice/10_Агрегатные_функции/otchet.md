# 10. Агрегатные функции

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## 1. Всего товаров

```sql
SELECT COUNT(*) AS total FROM product;
```

| total |
| --- |
| 10 |

## 2. Средняя цена

```sql
SELECT AVG(price) AS avg_price FROM product;
```

| avg_price |
| --- |
| 3316.0 |

## 3. Количество по категориям

```sql
SELECT category_id,COUNT(*) AS total FROM product GROUP BY category_id;
```

| category_id | total |
| --- | --- |
| NULL | 1 |
| 1 | 5 |
| 2 | 2 |
| 3 | 2 |

## 4. Сумма по категориям

```sql
SELECT category_id,SUM(price) AS sum_price FROM product GROUP BY category_id;
```

| category_id | sum_price |
| --- | --- |
| NULL | 200.0 |
| 1 | 630.0 |
| 2 | 330.0 |
| 3 | 32000.0 |

## 5. Больше двух товаров

```sql
SELECT category_id,COUNT(*) AS total FROM product GROUP BY category_id HAVING COUNT(*)>2;
```

| category_id | total |
| --- | --- |
| 1 | 5 |

## 6. Максимум и минимум

```sql
SELECT MAX(price) AS maximum,MIN(price) AS minimum FROM product;
```

| maximum | minimum |
| --- | --- |
| 30000.0 | 30.0 |

## 7. Средняя выше 100

```sql
SELECT category_id,AVG(price) AS avg_price FROM product GROUP BY category_id HAVING AVG(price)>100;
```

| category_id | avg_price |
| --- | --- |
| NULL | 200.0 |
| 1 | 126.0 |
| 2 | 165.0 |
| 3 | 16000.0 |

## 8. Дороже средней

```sql
SELECT * FROM product WHERE price>(SELECT AVG(price) FROM product);
```

| id | name | price | category_id |
| --- | --- | --- | --- |
| 8 | Холодильник | 30000.0 | 3 |

## 9*. Сводка по средней цене

```sql
SELECT category_id,COUNT(*) AS total,AVG(price) AS avg_price,MAX(price) AS max_price FROM product GROUP BY category_id ORDER BY avg_price DESC;
```

| category_id | total | avg_price | max_price |
| --- | --- | --- | --- |
| 3 | 2 | 16000.0 | 30000.0 |
| NULL | 1 | 200.0 | 200.0 |
| 2 | 2 | 165.0 | 250.0 |
| 1 | 5 | 126.0 | 350.0 |

## Продвинутый случай

```sql
SELECT COUNT(DISTINCT category_id) AS categories_with_products FROM product;
```

| categories_with_products |
| --- |
| 3 |

## Ответы и пояснения

COUNT(*) считает строки, COUNT(category_id) пропускает NULL. В GROUP BY товары без категории образуют отдельную группу NULL; COUNT(DISTINCT category_id) её не считает.
Вопрос в методичке неточен именно для SQLite: SELECT name,COUNT(*) FROM product GROUP BY category_id обычно не выдаёт ошибку, но name берётся из произвольной строки группы. Правильно выводить category_id,COUNT(*). В более строгих СУБД исходная запись отклоняется.
Предсказание для отдельного набора (3 товара категории 1 и 1 товар категории 2): одна строка category_id=1, COUNT(*)=3.
