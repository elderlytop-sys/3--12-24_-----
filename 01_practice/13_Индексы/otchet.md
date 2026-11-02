# 13. Индексы

Студент: Рулев Никита Сергеевич, 3ИП-12-24.

Выполнено на SQLite 3.53.1 через Python sqlite3. Данные учебные. Готовая база: `practice.db`. Для повторения создайте пустую базу, выполните `01_setup.sql`, затем `02_tasks.sql`. Фактические результаты также записаны в `results.json`.

## План до индексов

```sql
EXPLAIN QUERY PLAN SELECT * FROM product WHERE price>100;
```

| id | parent | notused | detail |
| --- | --- | --- | --- |
| 2 | 0 | 216 | SCAN product |

## 1. Индекс цены

```sql
CREATE INDEX idx_product_price ON product(price);
```

Команда выполнена.

## 2. Индекс имени

```sql
CREATE INDEX idx_product_name ON product(name);
```

Команда выполнена.

## 3. Составной индекс

```sql
CREATE INDEX idx_product_cat_price ON product(category_id,price);
```

Команда выполнена.

## 4. План по цене

```sql
EXPLAIN QUERY PLAN SELECT * FROM product WHERE price>100;
```

| id | parent | notused | detail |
| --- | --- | --- | --- |
| 3 | 0 | 203 | SEARCH product USING INDEX idx_product_price (price>?) |

## 4. План составного индекса

```sql
EXPLAIN QUERY PLAN SELECT * FROM product WHERE category_id=1 AND price>100;
```

| id | parent | notused | detail |
| --- | --- | --- | --- |
| 3 | 0 | 50 | SEARCH product USING INDEX idx_product_cat_price (category_id=? AND price>?) |

## 5. Удаление индекса имени

```sql
DROP INDEX idx_product_name;
```

Команда выполнена.

## 6. Уникальный индекс

```sql
CREATE UNIQUE INDEX idx_product_name_unique ON product(name);
```

Команда выполнена.

## 7. Индекс имени и категории

```sql
CREATE INDEX idx_product_name_cat ON product(name,category_id);
```

Команда выполнена.

## 9*. Индекс выражения

```sql
CREATE INDEX idx_product_lower_name ON product(LOWER(name));
```

Команда выполнена.

## 9*. Проверка плана выражения

```sql
EXPLAIN QUERY PLAN SELECT * FROM product WHERE LOWER(name)=LOWER('Хлеб');
```

| id | parent | notused | detail |
| --- | --- | --- | --- |
| 3 | 0 | 61 | SEARCH product USING INDEX idx_product_lower_name (<expr>=?) |

## Итоговый список индексов

```sql
PRAGMA index_list(product);
```

| seq | name | unique | origin | partial |
| --- | --- | --- | --- | --- |
| 0 | idx_product_lower_name | 0 | c | 0 |
| 1 | idx_product_name_cat | 0 | c | 0 |
| 2 | idx_product_name_unique | 1 | c | 0 |
| 3 | idx_product_cat_price | 0 | c | 0 |
| 4 | idx_product_price | 0 | c | 0 |

## Ответы и пояснения

Задание 8: отдельный benchmark.py выполняет честное сравнение на 100 000 учебных строк с одним и тем же запросом до/после индекса. Замеры, число строк и оба плана сохранены в benchmark_results.json. На десяти строках измерение в основном показывает шум.
Индекс на id INTEGER PRIMARY KEY избыточен: id уже является ключом rowid B-дерева. UNIQUE и другие формы PRIMARY KEY обычно создают автоматический индекс, но INTEGER PRIMARY KEY — особый случай.
Предсказание: обычно SEARCH product USING INDEX idx (price>?), но выбор зависит от статистики и стоимости плана; наличие индекса само по себе не гарантирует его использование.
Индекс LOWER(name) работает, когда запрос использует то же выражение. Стандартный LOWER не нормализует кириллицу, поэтому это проверка использования индекса, а не обещание Unicode-поиска.
