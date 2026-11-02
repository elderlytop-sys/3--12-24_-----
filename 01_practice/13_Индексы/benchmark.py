from pathlib import Path
import sqlite3,time,statistics,json
c=sqlite3.connect(':memory:',cached_statements=0)
c.execute('CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT,price REAL,category_id INTEGER)')
c.executemany('INSERT INTO product VALUES(?,?,?,?)',((i,f'Товар {i}',i%10000,i%5) for i in range(1,100001)));c.commit()
q='SELECT SUM(price) FROM product WHERE price>=9990'
def measure():
 plan=c.execute('EXPLAIN QUERY PLAN '+q).fetchall()
 for _ in range(5):c.execute(q).fetchone()
 times=[]
 for _ in range(40):
  t=time.perf_counter();value=c.execute(q).fetchone()[0];times.append((time.perf_counter()-t)*1000)
 return dict(plan=plan,median_ms=statistics.median(times),minimum_ms=min(times),result=value,repetitions=40)
a=measure();c.execute('CREATE INDEX idx_bench_price ON product(price)');b=measure();assert a['result']==b['result']
r=dict(sqlite_version=sqlite3.sqlite_version,rows=100000,query=q,without_index=a,with_index=b,speedup=a['median_ms']/b['median_ms'],note='Реальный замер текущей среды, в памяти; время построения индекса не включено, ускорение зависит от данных и запроса.')
Path(__file__).with_name('benchmark_results.json').write_text(json.dumps(r,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(r,ensure_ascii=False))
