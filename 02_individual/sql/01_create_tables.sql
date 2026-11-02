PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    created_at TEXT NOT NULL DEFAULT (date('now'))
);

CREATE TABLE IF NOT EXISTS device_types (
    type_id INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    position TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS repair_statuses (
    status_id INTEGER PRIMARY KEY,
    status_name TEXT NOT NULL UNIQUE,
    is_final INTEGER NOT NULL DEFAULT 0 CHECK (is_final IN (0, 1))
);

CREATE TABLE IF NOT EXISTS services (
    service_id INTEGER PRIMARY KEY,
    service_name TEXT NOT NULL UNIQUE,
    standard_price NUMERIC NOT NULL CHECK (standard_price >= 0)
);

CREATE TABLE IF NOT EXISTS devices (
    device_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    type_id INTEGER NOT NULL,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    serial_number TEXT NOT NULL UNIQUE,
    purchase_date TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (type_id) REFERENCES device_types(type_id)
);

CREATE TABLE IF NOT EXISTS repair_orders (
    order_id INTEGER PRIMARY KEY,
    device_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    received_at TEXT NOT NULL,
    planned_completion_at TEXT,
    completed_at TEXT,
    issue_description TEXT NOT NULL,
    diagnosis TEXT,
    notes TEXT,
    CHECK (planned_completion_at IS NULL OR planned_completion_at >= received_at),
    CHECK (completed_at IS NULL OR completed_at >= received_at),
    FOREIGN KEY (device_id) REFERENCES devices(device_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (status_id) REFERENCES repair_statuses(status_id)
);

CREATE TABLE IF NOT EXISTS order_services (
    order_service_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, service_id),
    FOREIGN KEY (order_id) REFERENCES repair_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);
