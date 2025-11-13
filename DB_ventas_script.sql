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
('María López', 'Cali', 'maria.lopez@example.com'), #4
('Santiago Ramírez', 'Cali', 'santiago.ramirez@example.com'), #5
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
(1, '2025-10-02', 90000.00),  
(3, '2025-10-03', 355000.00),
(4, '2025-10-04', 120000.00),
(5, '2025-10-04', 65000.00),
(6, '2025-10-04', 275000.00),
(7, '2025-10-04', 150000.00),
(8, '2025-10-08', 235000.00),
(9, '2025-10-09', 180000.00),
(10, '2025-10-10', 255000.00);

SELECT * FROM ventas;


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
(2, 90000.00, '2025-10-01'),
(3, 355000.00, '2025-10-03'),
(4, 120000.00, '2025-10-04'),
(5, 65000.00, '2025-10-05'),
(6, 275000.00, '2025-10-06'),
(7, 150000.00, '2025-10-07'),
(8, 235000.00, '2025-10-08'),
(9, 180000.00, '2025-10-09'),
(10, 255000.00, '2025-10-10');


#Subconsultas: 

#Subconsulta_1
SELECT id_cliente, nombre
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM ventas
);

#Subconsulta_2
SELECT id_producto, nombre
FROM productos
WHERE id_producto IN (
    SELECT id_producto
    FROM detalle_venta
);

#Subconsulta_3
SELECT id_venta, total
FROM ventas
WHERE id_venta IN (
    SELECT id_venta
    FROM pagos
);

#Procedimientos Almacenados

DELIMITER //

CREATE PROCEDURE verificar_disponiblidad_producto_venta(
	IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad_producto INT,
    IN p_precio_producto DECIMAL(10,2),
    OUT confirmacion INT
)
BEGIN
	DECLARE stock_disponible INT;
    DECLARE precio_total DECIMAL(10,2);

    SELECT stock INTO stock_disponible
    FROM productos 
    WHERE id_producto = p_id_producto;
    
    IF stock_disponible >= p_cantidad_producto THEN
    
		SET precio_total = p_cantidad_producto * p_precio_producto;
    
        INSERT INTO ventas (id_cliente, fecha_venta, total)
        VALUES (p_id_cliente, CURDATE(), precio_total);
        
        
        SET confirmacion = LAST_INSERT_ID();
        
	ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'STOCK INSUFICENTE';
        SET confirmacion = 0;
        
    END IF;
    
END //

DELIMITER ;

#Ingresar detalles de venta

DELIMITER //

CREATE PROCEDURE ingresar_detalles_venta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad_producto INT,
    IN p_precio_producto DECIMAL(10,2),
    OUT confirmacion TINYINT(1)
)
BEGIN
    DECLARE id_venta INT;
    DECLARE subtotal DECIMAL(10,2);

    SET subtotal = p_cantidad_producto * p_precio_producto;

    CALL verificar_disponiblidad_producto_venta(
        p_id_cliente,
        p_id_producto,
        p_cantidad_producto,
        p_precio_producto,
        id_venta
    );

    IF id_venta != 0 THEN
        INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal)
        VALUES (id_venta, p_id_producto, p_cantidad_producto, subtotal);

        UPDATE productos 
        SET stock = stock - p_cantidad_producto
        WHERE id_producto = p_id_producto;

        SET confirmacion = 1;
    ELSE
        SET confirmacion = 0;
    END IF;
END //

DELIMITER ;

##--- transaciones minimo 2 que involucren multiples operaciones 1 una set point 

##--- usuarios y roles minimo 2 con diferentes roles / ej admin y usario normal 







