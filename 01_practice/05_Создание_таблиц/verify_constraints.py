"""Автоматическая проверка ограничений практической работы № 05."""
import sqlite3
import json
from pathlib import Path

db_path = Path(__file__).with_name("practice.db")
conn = sqlite3.connect(db_path)
conn.execute("PRAGMA foreign_keys = ON")
checks = []

def expect_failure(label, sql, params=()):
    try:
        conn.execute(sql, params)
    except sqlite3.IntegrityError as exc:
        checks.append({"check": label, "status": "PASS", "expected": "ошибка ограничения", "actual": str(exc)})
        conn.rollback()
    else:
        raise AssertionError(f"{label}: ограничение не сработало")

def expect_success(label, sql, params=()):
    conn.execute(sql, params)
    checks.append({"check": label, "status": "PASS", "expected": "успешная вставка", "actual": "успешно"})
    conn.rollback()

expect_failure("CHECK product.price > 0",
               "INSERT INTO product(name, price, category_id) VALUES ('Тест цена 0', 0, 1)")
expect_failure("UNIQUE category.name",
               "INSERT INTO category(name) VALUES ('Еда')")
expect_failure("FOREIGN KEY product.category_id",
               "INSERT INTO product(name, price, category_id) VALUES ('Тест FK', 10, 999)")
expect_failure("UNIQUE supplier.phone",
               "INSERT INTO supplier(name, phone, email) VALUES ('Дубликат', '111-11-11', 'other@example.test')")
expect_failure("UNIQUE supplier.email",
               "INSERT INTO supplier(name, phone, email) VALUES ('Дубликат', '999-99-99', 'food@example.test')")
expect_failure("CHECK shipment.quantity > 0",
               "INSERT INTO shipment(product_id, supplier_id, quantity) VALUES (1, 1, 0)")
expect_failure("FOREIGN KEY shipment.product_id",
               "INSERT INTO shipment(product_id, supplier_id, quantity) VALUES (999, 1, 5)")
expect_failure("FOREIGN KEY shipment.supplier_id",
               "INSERT INTO shipment(product_id, supplier_id, quantity) VALUES (1, 999, 5)")
expect_failure("UNIQUE shipment(product_id, supplier_id)",
               "INSERT INTO shipment(product_id, supplier_id, quantity) VALUES (1, 1, 5)")
expect_failure("CHECK shipment.shipment_date >= 2020-01-01",
               "INSERT INTO shipment(product_id, supplier_id, quantity, shipment_date) VALUES (1, 2, 5, '2019-12-31')")

expect_success("Корректная ссылка product.category_id = 1",
               "INSERT INTO product(name, price, category_id) VALUES ('Тест корректной ссылки', 15, 1)")

assert conn.execute("PRAGMA integrity_check").fetchone()[0] == "ok"
assert conn.execute("PRAGMA foreign_key_check").fetchall() == []
checks.append({"check": "PRAGMA integrity_check", "status": "PASS", "actual": "ok"})
checks.append({"check": "PRAGMA foreign_key_check", "status": "PASS", "actual": "нарушений нет"})

out = Path(__file__).with_name("constraint_checks.json")
out.write_text(json.dumps(checks, ensure_ascii=False, indent=2), encoding="utf-8")
conn.close()
print(f"Успешно выполнено проверок: {len(checks)}")
for item in checks:
    print(f"[{item['status']}] {item['check']}: {item['actual']}")
