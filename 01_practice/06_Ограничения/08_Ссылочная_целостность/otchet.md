# 08. Ссылочная целостность

Рулев Никита Сергеевич, 3ИП-12-24.

Запуск: `python run.py`. Создаётся practice.db; тесты с ожидаемыми ошибками обрабатываются автоматически. В DB Browser выполните 01_schema.sql в пустой базе, затем команды 02_tests.sql по одной: четыре ошибки ограничений ожидаемы.

## 3. Заказ с отсутствующим клиентом

```sql
INSERT INTO orders VALUES(3,999);
```

Ожидаемая ошибка: FOREIGN KEY constraint failed

## 4. CASCADE: удалить клиента 1

```sql
DELETE FROM client WHERE id=1;
```

Результат: `[]`

## 4. Заказы удалились

```sql
SELECT COUNT(*) FROM orders;
```

Результат: `[[0]]`

## 5. Создать таблицу с RESTRICT

```sql
CREATE TABLE orders_new(id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES client(id) ON DELETE RESTRICT);
```

Результат: `[]`

## 5. Копирование

```sql
INSERT INTO orders_new SELECT * FROM orders;
```

Результат: `[]`

## 5. Удалить старую

```sql
DROP TABLE orders;
```

Результат: `[]`

## 5. Переименование

```sql
ALTER TABLE orders_new RENAME TO orders;
```

Результат: `[]`

## 5. Заказ существующего клиента

```sql
INSERT INTO orders VALUES(3,2);
```

Результат: `[]`

## 5. Отсутствующий клиент при RESTRICT

```sql
INSERT INTO orders VALUES(4,999);
```

Ожидаемая ошибка: FOREIGN KEY constraint failed

## 5. RESTRICT запрещает удалить клиента

```sql
DELETE FROM client WHERE id=2;
```

Ожидаемая ошибка: FOREIGN KEY constraint failed

## 5. Данные сохранились

```sql
SELECT * FROM orders;
```

Результат: `[[3, 2]]`

## 6. SET NULL: удалить категорию

```sql
DELETE FROM category WHERE id=1;
```

Результат: `[]`

## 6. Проверка

```sql
SELECT * FROM product;
```

Результат: `[[1, "Хлеб", null], [2, "Молоко", null]]`

## 7–8. Позиция заказа

```sql
INSERT INTO order_product VALUES(3,1,2);
```

Результат: `[]`

## 7. Второй товар того же заказа

```sql
INSERT INTO order_product VALUES(3,2,1);
```

Результат: `[]`

## 7. Второй заказ

```sql
INSERT INTO orders VALUES(4,2);
```

Результат: `[]`

## 7. Тот же товар в другом заказе

```sql
INSERT INTO order_product VALUES(4,1,1);
```

Результат: `[]`

## 8. Дубликат составного ключа

```sql
INSERT INTO order_product VALUES(3,1,5);
```

Ожидаемая ошибка: UNIQUE constraint failed: order_product.order_id, order_product.product_id

## 7–8. Содержимое связи M:N

```sql
SELECT * FROM order_product ORDER BY order_id,product_id;
```

Результат: `[[3, 1, 2], [3, 2, 1], [4, 1, 1]]`

## 9*. Иерархия сотрудников

```sql
SELECT e.name,m.name AS manager FROM employee e LEFT JOIN employee m ON m.id=e.manager_id ORDER BY e.id;
```

Результат: `[["Директор", null], ["Мастер", "Директор"], ["Стажёр", "Мастер"]]`

## Проверка внешних ключей

```sql
PRAGMA foreign_key_check;
```

Результат: `[]`

## Ответы

Клиент 1:N Заказ: у клиента несколько заказов, каждый заказ принадлежит одному клиенту. CASCADE удаляет связанные заказы; RESTRICT запрещает удаление клиента, пока они существуют. SET NULL сохраняет товары, очищая category_id; столбец должен допускать NULL.

Заказ M:N Товар реализована таблицей order_product с двумя FK и составным PK. Один товар встречается в разных заказах, а заказ содержит разные товары. manager_id моделирует подчинение сотрудников; у руководителя верхнего уровня NULL. Один FK сам по себе не предотвращает циклы в иерархии.

Поиск ошибки: при PRAGMA foreign_keys=OFF SQLite не проверяет FK. Включать PRAGMA foreign_keys=ON нужно для каждого подключения вне активной транзакции. При выключенной проверке заказ (1,999) может быть вставлен.

Предсказание: при удалении клиента 1 с включённым CASCADE заказы 1 и 2 удалятся, клиент 2 останется.
