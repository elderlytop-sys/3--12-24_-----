"""Проверка CHECK, UNIQUE, DEFAULT и CASE в UPDATE для практической работы 14."""
import sqlite3, json
from pathlib import Path
p=Path(__file__).with_name('practice.db')
c=sqlite3.connect(p)
checks=[]
def must_fail(label,sql,params=()):
    try: c.execute(sql,params)
    except sqlite3.IntegrityError as e:
        checks.append({'check':label,'result':'ошибка ожидаема','detail':str(e)})
        c.rollback()
    else: raise AssertionError(label+' — ограничение не сработало')
must_fail('CHECK price >= 0', "INSERT INTO product(name,price) VALUES('Отрицательная цена',-1)")
must_fail('UNIQUE name', "INSERT INTO product(name,price) VALUES('Хлеб',10)")
must_fail('NOT NULL name', "INSERT INTO product(name,price) VALUES(NULL,10)")
# DEFAULT 0 при пропуске price.
c.execute("INSERT INTO product(name) VALUES('Проверка DEFAULT')")
value=c.execute("SELECT price FROM product WHERE name='Проверка DEFAULT'").fetchone()[0]
assert value == 0
checks.append({'check':'DEFAULT price = 0','result':'успешно','value':value})
# COALESCE и NULLIF.
assert c.execute('SELECT COALESCE(NULL,NULL,5)').fetchone()[0] == 5
assert c.execute('SELECT 100/NULLIF(0,0)').fetchone()[0] is None
checks.append({'check':'COALESCE(NULL,NULL,5)','result':5})
checks.append({'check':'100/NULLIF(0,0)','result':None})
c.execute("UPDATE price_fix_demo SET price=-15 WHERE id=1")
c.execute("UPDATE price_fix_demo SET price=CASE WHEN price<0 THEN 0 ELSE price END")
assert c.execute("SELECT price FROM price_fix_demo WHERE id=1").fetchone()[0] == 0
checks.append({'check':'CASE в UPDATE','result':'отрицательная цена заменена на 0'})
assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
Path(__file__).with_name('constraint_checks.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
c.close()
print('Все проверки ограничений и CASE пройдены.')
