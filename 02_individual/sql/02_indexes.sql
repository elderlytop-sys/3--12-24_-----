-- Индекс 1: ускоряет отбор заказов по статусу и дате приёмки.
CREATE INDEX IF NOT EXISTS idx_repair_orders_status_received
    ON repair_orders(status_id, received_at);

-- Индекс 2: ускоряет поиск устройств конкретного клиента.
CREATE INDEX IF NOT EXISTS idx_devices_customer_id
    ON devices(customer_id);
