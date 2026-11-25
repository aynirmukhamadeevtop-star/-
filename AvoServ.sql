-- Клиенты
CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    discount NUMERIC(5,2) DEFAULT 0 CHECK (discount >= 0 AND discount <= 100)
);

-- Автомобили
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    brand VARCHAR(100) NOT NULL,
    vehicle_class VARCHAR(50)
);

-- Сотрудники
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    position VARCHAR(100) NOT NULL,
    experience_years INT CHECK (experience_years >= 0),
    salary_coefficient NUMERIC(4,2) DEFAULT 1.00,
    phone VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'active'
);

-- Блоки услуг
CREATE TABLE service_blocks (
    block_id INT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL
);

-- Услуги
CREATE TABLE services (
    service_id INT PRIMARY KEY,
    block_id INT NOT NULL REFERENCES service_blocks(block_id),
    name VARCHAR(255) NOT NULL,
    base_price NUMERIC(10,2) NOT NULL CHECK (base_price >= 0)
);

-- Заказы
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
    status VARCHAR(20) NOT NULL DEFAULT 'new',
    created_at TIMESTAMP NOT NULL,
    closed_at TIMESTAMP,
    discount NUMERIC(10,2) DEFAULT 0 CHECK (discount >= 0),
    comment TEXT
);

-- Позиции заказа
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    service_id INT NOT NULL REFERENCES services(service_id),
    employee_id INT REFERENCES employees(employee_id),
    quantity NUMERIC(10,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    discount NUMERIC(10,2) DEFAULT 0 CHECK (discount >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'new'
);

-- Склад
CREATE TABLE warehouse (
    resource_id INT PRIMARY KEY,
    resource_type VARCHAR(20) NOT NULL,
    name VARCHAR(255) NOT NULL,
    quantity NUMERIC(10,3) NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    unit VARCHAR(20) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0)
);

-- Расход ресурсов
CREATE TABLE resource_usages (
    usage_id INT PRIMARY KEY,
    order_item_id INT NOT NULL REFERENCES order_items(order_item_id),
    resource_id INT NOT NULL REFERENCES warehouse(resource_id),
    quantity NUMERIC(10,3) NOT NULL CHECK (quantity > 0),
    price_at_sale NUMERIC(10,2) NOT NULL CHECK (price_at_sale >= 0)
);

-- Оплаты
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    method VARCHAR(20) NOT NULL,
    paid_at TIMESTAMP NOT NULL
);

-- Начисления ЗП
CREATE TABLE salary_accruals (
    accrual_id INT PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    order_item_id INT REFERENCES order_items(order_item_id),
    period_from DATE NOT NULL,
    period_to DATE NOT NULL,
    type VARCHAR(20) NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'calculated'
);

-- История статусов
CREATE TABLE order_status_history (
    history_id INT PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    employee_id INT REFERENCES employees(employee_id),
    old_status VARCHAR(20),
    new_status VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP NOT NULL
);
