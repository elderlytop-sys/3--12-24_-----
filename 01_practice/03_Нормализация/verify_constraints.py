"""Дополнительные проверки ссылок и ключей для учебной базы нормализации."""
import sqlite3
from pathlib import Path
p=Path(__file__).with_name('practice.db')
c=sqlite3.connect(p)
c.execute('PRAGMA foreign_keys=ON')
assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
assert c.execute('PRAGMA foreign_key_check').fetchall()==[]
assert c.execute('SELECT COUNT(*) FROM nf1_student_phone').fetchone()[0]==5
assert c.execute('SELECT COUNT(*) FROM nf1_student_discipline').fetchone()[0]==6
assert c.execute('SELECT COUNT(*) FROM nf2_grade').fetchone()[0]==4
assert c.execute('SELECT COUNT(*) FROM nf3_student').fetchone()[0]==5
assert c.execute('SELECT COUNT(*) FROM nf3_order_item').fetchone()[0]==4
assert c.execute('SELECT COUNT(*) FROM timetable_lesson').fetchone()[0]==5
c.close()
print('Все проверки нормализованных таблиц пройдены.')
