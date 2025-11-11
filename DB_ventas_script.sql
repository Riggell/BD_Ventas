CREATE DATABASE bd_ventas_proyecto_final;
USE bd_ventas_proyecto_final;

CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  ciudad VARCHAR(80),
  email VARCHAR(120),
  creado_en DATETIME DEFAULT NOW()
);

CREATE TABLE productos (
  id_producto INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(120) NOT NULL,
  precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  creado_en DATETIME DEFAULT NOW()
);

CREATE TABLE ventas (
  id_venta INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  fecha_venta DATE NOT NULL,
  total DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
  creado_en DATETIME DEFAULT NOW(),
  CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_venta (
  id_detalle INT PRIMARY KEY AUTO_INCREMENT,
  id_venta INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
  CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
  CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE pagos (
  id_pago INT PRIMARY KEY AUTO_INCREMENT,
  id_venta INT NOT NULL,
  monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
  fecha_pago DATE NOT NULL,
  creado_en DATETIME DEFAULT NOW(),
  CONSTRAINT fk_pagos_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(id_producto);
CREATE INDEX idx_pagos_venta ON pagos(id_venta);

#Inserción de datos *******************************************************

INSERT INTO clientes (nombre, ciudad, email) VALUES
('Carlos Gómez', 'Bogotá', 'carlos.gomez@example.com'),
('Laura Martínez', 'Medellín', 'laura.martinez@example.com'),
('Andrés Rojas', 'Cali', 'andres.rojas@example.com'),
('María López', 'Barranquilla', 'maria.lopez@example.com'),
('Santiago Ramírez', 'Cartagena', 'santiago.ramirez@example.com'),
('Camila Torres', 'Pereira', 'camila.torres@example.com'),
('Felipe Herrera', 'Manizales', 'felipe.herrera@example.com'),
('Valentina Díaz', 'Bucaramanga', 'valentina.diaz@example.com'),
('Julián Castro', 'Santa Marta', 'julian.castro@example.com'),
('Paula Jiménez', 'Cúcuta', 'paula.jimenez@example.com');

INSERT INTO productos (nombre, precio, stock) VALUES
('Camiseta deportiva', 65000.00, 40),
('Pantalón jean', 90000.00, 35),
('Zapatos casuales', 150000.00, 25),
('Reloj digital', 200000.00, 15),
('Gorra unisex', 35000.00, 50),
('Chaqueta impermeable', 180000.00, 20),
('Sudadera deportiva', 120000.00, 30),
('Bufanda de lana', 45000.00, 40),
('Bolso de cuero', 220000.00, 10),
('Cinturón clásico', 55000.00, 25);


INSERT INTO ventas (id_cliente, fecha_venta, total) VALUES
(1, '2025-10-01', 215000.00),
(2, '2025-10-02', 90000.00),
(3, '2025-10-03', 355000.00),
(4, '2025-10-04', 120000.00),
(5, '2025-10-05', 65000.00),
(6, '2025-10-06', 275000.00),
(7, '2025-10-07', 150000.00),
(8, '2025-10-08', 235000.00),
(9, '2025-10-09', 180000.00),
(10, '2025-10-10', 255000.00);


INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal) VALUES
(1, 1, 2, 130000.00),
(1, 5, 1, 35000.00),
(1, 10, 1, 55000.00),

(2, 2, 1, 90000.00),

(3, 3, 1, 150000.00),
(3, 4, 1, 200000.00),
(3, 5, 1, 35000.00),

(4, 7, 1, 120000.00),

(5, 1, 1, 65000.00),

(6, 6, 1, 180000.00),
(6, 8, 2, 90000.00),
(6, 5, 1, 35000.00),

(7, 3, 1, 150000.00),

(8, 9, 1, 220000.00),
(8, 5, 1, 35000.00),

(9, 7, 1, 120000.00),
(9, 1, 1, 65000.00),

(10, 4, 1, 200000.00),
(10, 2, 1, 90000.00);


INSERT INTO pagos (id_venta, monto, fecha_pago) VALUES
(1, 215000.00, '2025-10-01'),
(2, 90000.00, '2025-10-02'),
(3, 355000.00, '2025-10-03'),
(4, 120000.00, '2025-10-04'),
(5, 65000.00, '2025-10-05'),
(6, 275000.00, '2025-10-06'),
(7, 150000.00, '2025-10-07'),
(8, 235000.00, '2025-10-08'),
(9, 180000.00, '2025-10-09'),
(10, 255000.00, '2025-10-10');


#Subconsultas: Mínimo 3 subconsultas en diferentes consultas.
#Transacciones: Mínimo 2 transacciones que involucren múltiples operaciones una de ellas con 'Savepoint'.
#Procedimiento Almacenado: 1 procedimiento almacenado.
#Usuarios y Roles: Mínimo 2 usuarios con diferentes roles (ej. administrador, usuario normal).
#XD



