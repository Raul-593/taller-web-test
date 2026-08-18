-- ========================================================
-- Base de datos para pruebas QA (Selenium)
-- ========================================================

-- Extension necesaria para uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================================
-- ENUM TYPES
-- ========================================================
CREATE TYPE mantenimiento_estado AS ENUM 
('recibido','en_proceso','completado', 'entregado', 'cancelado');
CREATE TYPE metodo_pago AS ENUM 
('efectivo','transferencia','tarjeta');
CREATE TYPE estado_pago AS ENUM 
('pendiente','completado','cancelado');

-- ========================================================
-- TABLAS
-- ========================================================
CREATE TABLE customers (
    id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        text NOT NULL,
    phone       integer,
    address     text,
    active      boolean NOT NULL DEFAULT true,
    created_at  timestamp without time zone NOT NULL DEFAULT now(),
    updated_at  timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE suppliers (
    id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        text NOT NULL,
    phone       integer,
    address     text,
    observacion text,
    active      boolean NOT NULL DEFAULT true,
    created_at  timestamp without time zone NOT NULL DEFAULT now(),
    updated_at  timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE products (
    id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        text NOT NULL,
    description text,
    category    text,
    stock       integer NOT NULL DEFAULT 0,
    stock_min   integer NOT NULL DEFAULT 0,
    price       numeric NOT NULL DEFAULT 0,
    cost        numeric NOT NULL DEFAULT 0,
    active      boolean NOT NULL DEFAULT true,
    created_at  timestamp without time zone NOT NULL DEFAULT now(),
    updated_at  timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE bicycles (
    id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id   uuid NOT NULL REFERENCES customers(id),
    brand         text,
    model         text,
    serial_number text,
    observacion   text,
    created_at    timestamp without time zone NOT NULL DEFAULT now(),
    updated_at    timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE sales (
    id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    sales_date     date NOT NULL DEFAULT CURRENT_DATE,
    customer_id    uuid REFERENCES customers(id),
    sales_type     text NOT NULL DEFAULT 'retail',
    sub_total      numeric NOT NULL DEFAULT 0,
    discount       numeric NOT NULL DEFAULT 0,
    total          numeric NOT NULL DEFAULT 0,
    payment_method metodo_pago DEFAULT 'transferencia',
    status         estado_pago DEFAULT 'pendiente',
    observacion    text,
    created_at     timestamp without time zone NOT NULL DEFAULT now(),
    updated_at     timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE sale_items (
    id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    sale_id     uuid NOT NULL REFERENCES sales(id),
    product_id  uuid NOT NULL REFERENCES products(id),
    quantity    integer NOT NULL,
    unit_price  numeric NOT NULL,
    discount    numeric NOT NULL DEFAULT 0,
    total       numeric NOT NULL,
    created_at  timestamp without time zone NOT NULL DEFAULT now()
);

CREATE TABLE purchases (
    id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id    uuid NOT NULL REFERENCES suppliers(id),
    purchase_date  date NOT NULL DEFAULT CURRENT_DATE,
    description    text,
    sub_total      numeric NOT NULL DEFAULT 0,
    total          numeric NOT NULL DEFAULT 0,
    payment_method metodo_pago DEFAULT 'transferencia',
    status         estado_pago DEFAULT 'pendiente',
    observacion    text,
    created_at     timestamp without time zone NOT NULL DEFAULT now(),
    updated_at     timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE purchase_items (
    id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_id uuid NOT NULL REFERENCES purchases(id),
    product_id  uuid NOT NULL REFERENCES products(id),
    quantity    integer NOT NULL,
    unit_cost   numeric NOT NULL,
    total       numeric NOT NULL,
    created_at  timestamp without time zone NOT NULL DEFAULT now()
);

CREATE TABLE maintenance_records (
    id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    bicycle_id    uuid NOT NULL REFERENCES bicycles(id),
    sale_id       uuid REFERENCES sales(id),
    service_date  date NOT NULL DEFAULT CURRENT_DATE,
    delivery_date date,
    description   text NOT NULL,
    observation   text,
    cost          numeric NOT NULL DEFAULT 0,
    status        mantenimiento_estado NOT NULL DEFAULT 'recibido',
    created_at    timestamp without time zone NOT NULL DEFAULT now(),
    updated_at    timestamp with time zone NOT NULL DEFAULT now()
);

create table maintenance_items (
  "id"             uuid                        not null default extensions.uuid_generate_v4(),
  "maintenance_id" uuid,
  "product_id"     uuid,
  "item_type"      text                        not null,
  "description"    text,
  "quantity"       integer                     not null default 1,
  "unit_price"     numeric                     not null default 0,
  "total_price"    numeric,
  "created_at"     timestamp without time zone not null default now(),
  "updated_at"     timestamp with time zone    not null default now(),
  constraint "maintenance_items_pkey" primary key (id)
);

-- ========================================================
-- DATOS DE PRUEBA
-- ========================================================

-- Customers
INSERT INTO customers (id, name, phone, address, active) VALUES
    ('11111111-1111-1111-1111-111111111111', 'QA TEST Cliente Uno', 999000001, 'Av. de Prueba 100', true),
    ('11111111-1111-1111-1111-111111111112', 'QA TEST Cliente Dos', 999000002, 'Av. de Prueba 200', true),
    ('11111111-1111-1111-1111-111111111113', 'QA TEST Cliente Inactivo', 999000003, 'Av. de Prueba 300', false);

-- Suppliers
INSERT INTO suppliers (id, name, phone, address, observacion, active) VALUES
    ('22222222-2222-2222-2222-222222222221', 'QA TEST Proveedor Repuestos', 998000001, 'Zona Industrial 1', 'Proveedor de prueba', true),
    ('22222222-2222-2222-2222-222222222222', 'QA TEST Proveedor Accesorios', 998000002, 'Zona Industrial 2', 'Proveedor de prueba', true);
	

-- Products
INSERT INTO products (id, name, description, category, stock, stock_min, price, cost, active) VALUES
    ('33333333-3333-3333-3333-333333333331', 'QA TEST Cadena', 'Cadena de bicicleta estándar', 'Repuestos', 20, 5, 15.00, 8.00, true),
    ('33333333-3333-3333-3333-333333333332', 'QA TEST Llanta 26"', 'Llanta rin 26', 'Repuestos', 10, 2, 50.00, 30.00, true),
    ('33333333-3333-3333-3333-333333333333', 'QA TEST Casco', 'Casco de seguridad', 'Accesorios', 8, 2, 30.00, 18.00, true);

-- Bicycles
INSERT INTO bicycles (id, customer_id, brand, model, serial_number, observacion) VALUES
    ('44444444-4444-4444-4444-444444444441', '11111111-1111-1111-1111-111111111111', 'QA TEST Trek', 'Marlin 7', 'SN-QA-0001', 'Bici de prueba'),
    ('44444444-4444-4444-4444-444444444442', '11111111-1111-1111-1111-111111111112', 'QA TEST Giant', 'Talon 3', 'SN-QA-0002', 'Bici de prueba');

-- Sales
INSERT INTO sales (id, sales_date, customer_id, sales_type, sub_total, discount, total, payment_method, status, observacion) VALUES
    ('55555555-5555-5555-5555-555555555551', CURRENT_DATE, '11111111-1111-1111-1111-111111111111', 'retail', 40.00, 0, 40.00, 'efectivo', 'completado', 'Venta de prueba');

-- Sale items
INSERT INTO sale_items (id, sale_id, product_id, quantity, unit_price, discount, total) VALUES
    ('66666666-6666-6666-6666-666666666661', '55555555-5555-5555-5555-555555555551', '33333333-3333-3333-3333-333333333331', 1, 15.00, 0, 15.00),
    ('66666666-6666-6666-6666-666666666662', '55555555-5555-5555-5555-555555555551', '33333333-3333-3333-3333-333333333333', 1, 30.00, 5.00, 25.00);

-- Purchases
INSERT INTO purchases (id, supplier_id, purchase_date, description, sub_total, total, payment_method, status, observacion) VALUES
    ('77777777-7777-7777-7777-777777777771', '22222222-2222-2222-2222-222222222221', CURRENT_DATE, 'Compra de prueba de repuestos', 80.00, 80.00, 'transferencia', 'completado', 'Compra QA');

-- Purchase items
INSERT INTO purchase_items (id, purchase_id, product_id, quantity, unit_cost, total) VALUES
    ('88888888-8888-8888-8888-888888888881', '77777777-7777-7777-7777-777777777771', '33333333-3333-3333-3333-333333333331', 10, 8.00, 80.00);

-- Maintenance records
INSERT INTO maintenance_records (id, bicycle_id, sale_id, service_date, delivery_date, description, observation, cost, status) VALUES
    ('99999999-9999-9999-9999-999999999991', '44444444-4444-4444-4444-444444444441', NULL, CURRENT_DATE, CURRENT_DATE + 2, 'Mantenimiento preventivo QA', 'Registro de prueba', 25.00, 'recibido'),
    ('99999999-9999-9999-9999-999999999992', '44444444-4444-4444-4444-444444444442', NULL, CURRENT_DATE - 5, CURRENT_DATE - 1, 'Cambio de llanta QA', 'Registro de prueba entregado', 50.00, 'entregado');

-- Maintenance Items
INSERT INTO maintenance_items (id, maintenance_id, product_id, item_type, description, quantity, unit_price, total_price) VALUES
    ('99999999-9999-9999-9999-999999999993', '99999999-9999-9999-9999-999999999991','33333333-3333-3333-3333-333333333331', 'retail', 'Cambio de Cadena QA', '1', 15.00, 15.00),
    ('99999999-9999-9999-9999-999999999994', '99999999-9999-9999-9999-999999999992','33333333-3333-3333-3333-333333333332', 'retail', 'Cambio de Llantas QA', '2', 50.00, 100.00);
