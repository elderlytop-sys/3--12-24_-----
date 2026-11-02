from pathlib import Path
import sqlite3,json
D=Path(__file__).resolve().parent
schema="""PRAGMA foreign_keys=ON;
CREATE TABLE client(id INTEGER PRIMARY KEY,name TEXT NOT NULL);
CREATE TABLE orders(id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES client(id) ON DELETE CASCADE);
INSERT INTO client VALUES(1,'Иванов'),(2,'Петров');
INSERT INTO orders VALUES(1,1),(2,1);
CREATE TABLE category(id INTEGER PRIMARY KEY,name TEXT);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT,category_id INTEGER REFERENCES category(id) ON DELETE SET NULL);
INSERT INTO category VALUES(1,'Еда');
INSERT INTO product VALUES(1,'Хлеб',1),(2,'Молоко',1);
CREATE TABLE order_product(order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,product_id INTEGER REFERENCES product(id) ON DELETE RESTRICT,quantity INTEGER NOT NULL CHECK(quantity>0),PRIMARY KEY(order_id,product_id));
CREATE TABLE employee(id INTEGER PRIMARY KEY,name TEXT NOT NULL,manager_id INTEGER REFERENCES employee(id) ON DELETE SET NULL);
INSERT INTO employee VALUES(1,'Директор',NULL),(2,'Мастер',1),(3,'Стажёр',2);
"""
(D/'01_schema.sql').write_text(schema,encoding='utf-8')
(D/'practice.db').unlink(missing_ok=True)
c=sqlite3.connect(D/'practice.db');c.executescript(schema)
results=[]; script=[]
def execute(label,sql,error=False):
 script.append('-- '+label+(' [ОЖИДАЕТСЯ ОШИБКА; выполнять отдельно]' if error else '')+'\n'+sql+';')
 try:
  cur=c.execute(sql);rows=cur.fetchall() if cur.description else []
  if error:raise AssertionError('Ограничение не сработало')
  results.append(dict(task=label,sql=sql,rows=rows,status='ok'))
 except sqlite3.IntegrityError as e:
  if not error:raise
  results.append(dict(task=label,sql=sql,status='expected_error',message=str(e)))
execute('3. Заказ с отсутствующим клиентом','INSERT INTO orders VALUES(3,999)',True)
execute('4. CASCADE: удалить клиента 1','DELETE FROM client WHERE id=1')
execute('4. Заказы удалились','SELECT COUNT(*) FROM orders');assert c.execute('SELECT COUNT(*) FROM orders').fetchone()[0]==0
execute('5. Создать таблицу с RESTRICT','CREATE TABLE orders_new(id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES client(id) ON DELETE RESTRICT)')
execute('5. Копирование','INSERT INTO orders_new SELECT * FROM orders')
execute('5. Удалить старую','DROP TABLE orders')
execute('5. Переименование','ALTER TABLE orders_new RENAME TO orders')
execute('5. Заказ существующего клиента','INSERT INTO orders VALUES(3,2)')
execute('5. Отсутствующий клиент при RESTRICT','INSERT INTO orders VALUES(4,999)',True)
execute('5. RESTRICT запрещает удалить клиента','DELETE FROM client WHERE id=2',True)
execute('5. Данные сохранились','SELECT * FROM orders')
execute('6. SET NULL: удалить категорию','DELETE FROM category WHERE id=1')
execute('6. Проверка','SELECT * FROM product');assert c.execute('SELECT COUNT(*) FROM product WHERE category_id IS NULL').fetchone()[0]==2
execute('7–8. Позиция заказа','INSERT INTO order_product VALUES(3,1,2)')
execute('7. Второй товар того же заказа','INSERT INTO order_product VALUES(3,2,1)')
execute('7. Второй заказ','INSERT INTO orders VALUES(4,2)')
execute('7. Тот же товар в другом заказе','INSERT INTO order_product VALUES(4,1,1)')
execute('8. Дубликат составного ключа','INSERT INTO order_product VALUES(3,1,5)',True)
execute('7–8. Содержимое связи M:N','SELECT * FROM order_product ORDER BY order_id,product_id')
execute('9*. Иерархия сотрудников','SELECT e.name,m.name AS manager FROM employee e LEFT JOIN employee m ON m.id=e.manager_id ORDER BY e.id')
execute('Проверка внешних ключей','PRAGMA foreign_key_check')
c.commit();assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok';assert not c.execute('PRAGMA foreign_key_check').fetchall();c.close()
(D/'02_tests.sql').write_text('\n\n'.join(script),encoding='utf-8')
(D/'results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
report='# 08. Ссылочная целостность\n\nРулев Никита Сергеевич, 3ИП-12-24.\n\nЗапуск: `python run.py`. Создаётся practice.db; тесты с ожидаемыми ошибками обрабатываются автоматически. В DB Browser выполните 01_schema.sql в пустой базе, затем команды 02_tests.sql по одной: четыре ошибки ограничений ожидаемы.\n\n'
for r in results:
 report+='## '+r['task']+'\n\n```sql\n'+r['sql']+';\n```\n\n'+('Ожидаемая ошибка: '+r['message'] if r['status']=='expected_error' else 'Результат: `'+json.dumps(r['rows'],ensure_ascii=False)+'`')+'\n\n'
report+='## Ответы\n\nКлиент 1:N Заказ: у клиента несколько заказов, каждый заказ принадлежит одному клиенту. CASCADE удаляет связанные заказы; RESTRICT запрещает удаление клиента, пока они существуют. SET NULL сохраняет товары, очищая category_id; столбец должен допускать NULL.\n\nЗаказ M:N Товар реализована таблицей order_product с двумя FK и составным PK. Один товар встречается в разных заказах, а заказ содержит разные товары. manager_id моделирует подчинение сотрудников; у руководителя верхнего уровня NULL. Один FK сам по себе не предотвращает циклы в иерархии.\n\nПоиск ошибки: при PRAGMA foreign_keys=OFF SQLite не проверяет FK. Включать PRAGMA foreign_keys=ON нужно для каждого подключения вне активной транзакции. При выключенной проверке заказ (1,999) может быть вставлен.\n\nПредсказание: при удалении клиента 1 с включённым CASCADE заказы 1 и 2 удалятся, клиент 2 останется.\n'
(D/'otchet.md').write_text(report,encoding='utf-8')
