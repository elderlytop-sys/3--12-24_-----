from pathlib import Path
import csv,sqlite3,json
D=Path(__file__).resolve().parent
(D/'practice.db').unlink(missing_ok=True);c=sqlite3.connect(D/'practice.db');logs=[]
def query(label,q):
 cur=c.execute(q);rows=cur.fetchall() if cur.description else []
 logs.append(dict(task=label,sql=q,columns=[x[0] for x in cur.description] if cur.description else [],rows=rows))
def load(file,table):
 with (D/file).open(encoding='utf-8-sig',newline='') as f:
  reader=csv.reader(f);headers=next(reader); rows=list(reader)
 c.executemany('INSERT INTO '+table+' VALUES('+','.join('?' for _ in headers)+')',rows)
 logs.append(dict(task='Импорт '+file,rows_loaded=len(rows)))
setup="""CREATE TABLE tmp_product(name TEXT,price TEXT,category_id TEXT);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL,price REAL CHECK(price>=0),category_id INTEGER);
"""
c.executescript(setup);load('products_5.csv','tmp_product')
q="INSERT INTO product(name,price,category_id) SELECT TRIM(name),CAST(price AS REAL),CAST(category_id AS INTEGER) FROM tmp_product"
query('4. Приведение типов',q);query('5. Проверка','SELECT *,typeof(price) AS price_type FROM product');assert c.execute('SELECT COUNT(*) FROM product').fetchone()[0]==5
query('6. Удаление временной таблицы','DROP TABLE tmp_product')
query('7. Подготовка грязных данных','CREATE TABLE tmp_dirty(name TEXT,price TEXT,category_id TEXT)');load('dirty.csv','tmp_dirty')
query('7. Очистка TRIM/LOWER',"CREATE TABLE cleaned AS SELECT LOWER(TRIM(name)) AS name,CAST(TRIM(price) AS REAL) AS price,CAST(TRIM(category_id) AS INTEGER) AS category_id FROM tmp_dirty")
query('7. Проверка очистки','SELECT * FROM cleaned')
query('8. Отдельная таблица десяти записей','CREATE TABLE ten_products(name TEXT,price REAL,category_id INTEGER)');load('products_10.csv','ten_products');query('8. Проверка количества','SELECT COUNT(*) AS loaded FROM ten_products');assert c.execute('SELECT COUNT(*) FROM ten_products').fetchone()[0]==10
query('9. Подготовка дат','CREATE TABLE tmp_dates(name TEXT,created TEXT)');load('dates.csv','tmp_dates')
query('9. DD.MM.YYYY → YYYY-MM-DD',"CREATE TABLE dated_products AS SELECT name,substr(created,7,4)||'-'||substr(created,4,2)||'-'||substr(created,1,2) AS created FROM tmp_dates")
query('9. Проверка дат','SELECT * FROM dated_products')
query('10*. Исходные некорректные строки','CREATE TABLE tmp_invalid(name TEXT,price TEXT)');load('invalid.csv','tmp_invalid')
# Учебный CSV содержит положительную, отрицательную, пустую и явно текстовую цену.
query('10*. Поиск некорректной цены',"SELECT * FROM tmp_invalid WHERE NULLIF(TRIM(price),'') IS NULL OR CAST(price AS REAL)<0 OR TRIM(price) GLOB '*[^0-9.-]*' OR TRIM(price) IN ('.','-','-.') OR LENGTH(TRIM(price))-LENGTH(REPLACE(TRIM(price),'.',''))>1 OR instr(substr(TRIM(price),2),'-')>0")
query('10*. Строки с отрицательной или NULL ценой после NULLIF/CAST',"SELECT name,CAST(NULLIF(TRIM(price),'') AS REAL) AS price FROM tmp_invalid WHERE NULLIF(TRIM(price),'') IS NULL OR CAST(price AS REAL)<0")
c.commit();assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok';c.close()
(D/'01_create_staging.sql').write_text(setup,encoding='utf-8')
(D/'02_transfer.sql').write_text(q+';\nSELECT *,typeof(price) AS price_type FROM product;\nDROP TABLE tmp_product;\n',encoding='utf-8')
(D/'results.json').write_text(json.dumps(logs,ensure_ascii=False,indent=2),encoding='utf-8')
report='# 07. Импорт CSV\n\nРулев Никита Сергеевич, 3ИП-12-24.\n\nГотовая practice.db создана реальным импортом CSV через Python sqlite3. Повторить: `python import_csv.py` (пересоздаёт только базу этой работы). Интерфейс DB Browser здесь не запускался; ниже приведены точные действия для воспроизведения задания 3.\n\n1. Создать пустую БД в DB Browser, выполнить 01_create_staging.sql.\n2. File → Import → Table from CSV file: products_5.csv, таблица tmp_product, разделитель запятая, UTF-8, первая строка — заголовки. Подтвердить импорт в существующую таблицу.\n3. Выполнить 02_transfer.sql, нажать Write Changes. Для повторного импорта сначала очистить временную таблицу, не загружать те же строки дважды.\n4. Для дополнительных CSV создавать таблицы по командам ниже, импортировать указанный CSV и выполнять следующий SQL.\n\n'
for r in logs:
 report+='## '+r['task']+'\n\n'
 if 'sql' in r:report+='```sql\n'+r['sql']+';\n```\n\nРезультат: `'+json.dumps(r['rows'],ensure_ascii=False)+'`\n\n'
 else:report+='Загружено строк: '+str(r['rows_loaded'])+'.\n\n'
report+='## Ответы\n\n100 вместо 50: повторный импорт в заполненную таблицу без очистки или дубли в CSV. Проверить исходный CSV и COUNT(*); для уникальных данных применять ключи/UNIQUE.\n\nПредсказание: строки Хлеб,40 и Мыло,80 попадут в TEXT/REAL; числовые строки преобразуются affinity REAL. Значения с нечисловым суффиксом могут остаться TEXT.\n\nLOWER в стандартном SQLite работает только с ASCII. Поэтому dirty.csv содержит латинские названия разного регистра, а обычный CSV — русские. Для кириллицы нужен ICU/Unicode UDF.\n\nДаты заданы валидными строками DD.MM.YYYY фиксированной длины. substr переставляет компоненты; это преобразование формата, а не проверка календаря.\n\nCAST(\'abc\' AS REAL) даёт 0, поэтому ошибку нельзя искать только через price<0: добавлена проверка текстового формата десятичных цен. Пустые поля CSV — пустая строка; NULLIF преобразует их в NULL. Проверка рассчитана на обычные десятичные числа без экспоненты и валюты.\n'
(D/'otchet.md').write_text(report,encoding='utf-8')
