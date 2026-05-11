-- =============================================================
--  BD PAPELERÍA — Script de creación completo
--  Gestor: MySQL 8.0+
--  Codificación: UTF8MB4
--  Autor: Administrador de Base de Datos
--  Fecha: 2026-05-11
-- =============================================================

CREATE DATABASE IF NOT EXISTS bdpapeleria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE bdpapeleria;

SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================
--  1. CONFIGURACIÓN Y CATÁLOGOS
-- =============================================================

-- -------------------------------------------------------------
--  Sucursal
-- -------------------------------------------------------------
CREATE TABLE sucursal (
  id        INT            NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(100)   NOT NULL,
  direccion VARCHAR(255)       NULL,
  telefono  VARCHAR(20)        NULL,
  activo    BOOLEAN        NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Unidad de medida
-- -------------------------------------------------------------
CREATE TABLE unidad_medida (
  id           INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(50) NOT NULL,
  abreviatura  VARCHAR(10) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_unidad_abreviatura (abreviatura)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Rol / Permiso
-- -------------------------------------------------------------
CREATE TABLE rol (
  id                 INT          NOT NULL AUTO_INCREMENT,
  nombre             VARCHAR(50)  NOT NULL,
  descripcion        TEXT             NULL,
  puede_vender       BOOLEAN      NOT NULL DEFAULT FALSE,
  puede_comprar      BOOLEAN      NOT NULL DEFAULT FALSE,
  puede_administrar  BOOLEAN      NOT NULL DEFAULT FALSE,
  puede_reportes     BOOLEAN      NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id),
  UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB;

-- =============================================================
--  2. PERSONAS
-- =============================================================

-- -------------------------------------------------------------
--  Empleado
-- -------------------------------------------------------------
CREATE TABLE empleado (
  id             INT          NOT NULL AUTO_INCREMENT,
  rol_id         INT          NOT NULL,
  sucursal_id    INT              NULL,
  nombre         VARCHAR(100) NOT NULL,
  apellidos      VARCHAR(100) NOT NULL,
  puesto         VARCHAR(80)      NULL,
  turno          ENUM('mañana','tarde','noche') NULL,
  usuario        VARCHAR(50)  NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  activo         BOOLEAN      NOT NULL DEFAULT TRUE,
  creado_en      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_empleado_usuario (usuario),
  CONSTRAINT fk_empleado_rol
    FOREIGN KEY (rol_id)      REFERENCES rol (id),
  CONSTRAINT fk_empleado_sucursal
    FOREIGN KEY (sucursal_id) REFERENCES sucursal (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Cliente
-- -------------------------------------------------------------
CREATE TABLE cliente (
  id                  INT          NOT NULL AUTO_INCREMENT,
  nombre              VARCHAR(100) NOT NULL,
  apellidos           VARCHAR(100) NOT NULL,
  telefono            VARCHAR(20)      NULL,
  email               VARCHAR(120)     NULL,
  direccion           VARCHAR(255)     NULL,
  rfc                 VARCHAR(20)      NULL,
  tipo                ENUM('menudeo','mayoreo') NOT NULL DEFAULT 'menudeo',
  credito_limite      DECIMAL(10,2)NOT NULL DEFAULT 0.00,
  credito_disponible  DECIMAL(10,2)NOT NULL DEFAULT 0.00,
  activo              BOOLEAN      NOT NULL DEFAULT TRUE,
  creado_en           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- =============================================================
--  3. CATÁLOGO DE PRODUCTOS
-- =============================================================

-- -------------------------------------------------------------
--  Categoría (auto-referenciada para subcategorías)
-- -------------------------------------------------------------
CREATE TABLE categoria (
  id                 INT          NOT NULL AUTO_INCREMENT,
  categoria_padre_id INT              NULL,
  nombre             VARCHAR(100) NOT NULL,
  descripcion        TEXT             NULL,
  activo             BOOLEAN      NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id),
  CONSTRAINT fk_categoria_padre
    FOREIGN KEY (categoria_padre_id) REFERENCES categoria (id)
      ON DELETE SET NULL
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Proveedor
-- -------------------------------------------------------------
CREATE TABLE proveedor (
  id                INT           NOT NULL AUTO_INCREMENT,
  nombre            VARCHAR(150)  NOT NULL,
  rfc               VARCHAR(20)       NULL,
  telefono          VARCHAR(20)       NULL,
  email             VARCHAR(120)      NULL,
  direccion         VARCHAR(255)      NULL,
  condiciones_pago  VARCHAR(100)      NULL,
  dias_credito      INT           NOT NULL DEFAULT 0,
  activo            BOOLEAN       NOT NULL DEFAULT TRUE,
  creado_en         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_proveedor_rfc (rfc)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Producto
-- -------------------------------------------------------------
CREATE TABLE producto (
  id             INT            NOT NULL AUTO_INCREMENT,
  categoria_id   INT            NOT NULL,
  proveedor_id   INT                NULL,
  unidad_id      INT            NOT NULL,
  codigo_barras  VARCHAR(50)        NULL,
  nombre         VARCHAR(150)   NOT NULL,
  descripcion    TEXT               NULL,
  precio_venta   DECIMAL(10,2)  NOT NULL,
  precio_costo   DECIMAL(10,2)  NOT NULL,
  stock_actual   INT            NOT NULL DEFAULT 0,
  stock_minimo   INT            NOT NULL DEFAULT 0,
  imagen_url     VARCHAR(255)       NULL,
  activo         BOOLEAN        NOT NULL DEFAULT TRUE,
  creado_en      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_producto_codigo (codigo_barras),
  CONSTRAINT fk_producto_categoria
    FOREIGN KEY (categoria_id)  REFERENCES categoria (id),
  CONSTRAINT fk_producto_proveedor
    FOREIGN KEY (proveedor_id)  REFERENCES proveedor (id)
      ON DELETE SET NULL,
  CONSTRAINT fk_producto_unidad
    FOREIGN KEY (unidad_id)     REFERENCES unidad_medida (id),
  CONSTRAINT ck_producto_precios
    CHECK (precio_venta >= 0 AND precio_costo >= 0),
  CONSTRAINT ck_producto_stock
    CHECK (stock_actual >= 0 AND stock_minimo >= 0)
) ENGINE=InnoDB;

-- =============================================================
--  4. PUNTO DE VENTA
-- =============================================================

-- -------------------------------------------------------------
--  Caja (apertura/cierre de turno)
-- -------------------------------------------------------------
CREATE TABLE caja (
  id             INT           NOT NULL AUTO_INCREMENT,
  empleado_id    INT           NOT NULL,
  sucursal_id    INT               NULL,
  fecha_apertura TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_cierre   TIMESTAMP         NULL,
  fondo_inicial  DECIMAL(10,2) NOT NULL,
  total_ventas   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total_efectivo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  estado         ENUM('abierta','cerrada') NOT NULL DEFAULT 'abierta',
  PRIMARY KEY (id),
  CONSTRAINT fk_caja_empleado
    FOREIGN KEY (empleado_id)  REFERENCES empleado (id),
  CONSTRAINT fk_caja_sucursal
    FOREIGN KEY (sucursal_id)  REFERENCES sucursal (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Venta
-- -------------------------------------------------------------
CREATE TABLE venta (
  id          INT           NOT NULL AUTO_INCREMENT,
  cliente_id  INT               NULL,
  empleado_id INT           NOT NULL,
  caja_id     INT           NOT NULL,
  fecha       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  subtotal    DECIMAL(10,2) NOT NULL,
  descuento   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  impuesto    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total       DECIMAL(10,2) NOT NULL,
  tipo_pago   ENUM('efectivo','tarjeta','transferencia','credito') NOT NULL,
  estado      ENUM('completada','cancelada','pendiente') NOT NULL DEFAULT 'completada',
  notas       TEXT              NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_venta_cliente
    FOREIGN KEY (cliente_id)  REFERENCES cliente (id)
      ON DELETE SET NULL,
  CONSTRAINT fk_venta_empleado
    FOREIGN KEY (empleado_id) REFERENCES empleado (id),
  CONSTRAINT fk_venta_caja
    FOREIGN KEY (caja_id)     REFERENCES caja (id),
  CONSTRAINT ck_venta_total
    CHECK (total >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Detalle de venta
-- -------------------------------------------------------------
CREATE TABLE detalle_venta (
  id               INT           NOT NULL AUTO_INCREMENT,
  venta_id         INT           NOT NULL,
  producto_id      INT           NOT NULL,
  cantidad         INT           NOT NULL,
  precio_unitario  DECIMAL(10,2) NOT NULL,
  descuento        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  subtotal         DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_detalle_venta_venta
    FOREIGN KEY (venta_id)    REFERENCES venta (id)
      ON DELETE CASCADE,
  CONSTRAINT fk_detalle_venta_producto
    FOREIGN KEY (producto_id) REFERENCES producto (id),
  CONSTRAINT ck_detalle_venta_cantidad
    CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Pago (permite pagos parciales o múltiples métodos)
-- -------------------------------------------------------------
CREATE TABLE pago (
  id         INT           NOT NULL AUTO_INCREMENT,
  venta_id   INT           NOT NULL,
  monto      DECIMAL(10,2) NOT NULL,
  metodo     ENUM('efectivo','tarjeta','transferencia') NOT NULL,
  referencia VARCHAR(100)      NULL,
  fecha      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_pago_venta
    FOREIGN KEY (venta_id) REFERENCES venta (id)
      ON DELETE CASCADE,
  CONSTRAINT ck_pago_monto
    CHECK (monto > 0)
) ENGINE=InnoDB;

-- =============================================================
--  5. COMPRAS
-- =============================================================

-- -------------------------------------------------------------
--  Compra (orden a proveedor)
-- -------------------------------------------------------------
CREATE TABLE compra (
  id               INT           NOT NULL AUTO_INCREMENT,
  proveedor_id     INT           NOT NULL,
  empleado_id      INT           NOT NULL,
  fecha            TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total            DECIMAL(10,2) NOT NULL,
  estado           ENUM('pendiente','recibida','cancelada') NOT NULL DEFAULT 'pendiente',
  notas            TEXT              NULL,
  fecha_recepcion  TIMESTAMP         NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_compra_proveedor
    FOREIGN KEY (proveedor_id) REFERENCES proveedor (id),
  CONSTRAINT fk_compra_empleado
    FOREIGN KEY (empleado_id)  REFERENCES empleado (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Detalle de compra
-- -------------------------------------------------------------
CREATE TABLE detalle_compra (
  id            INT           NOT NULL AUTO_INCREMENT,
  compra_id     INT           NOT NULL,
  producto_id   INT           NOT NULL,
  cantidad      INT           NOT NULL,
  precio_costo  DECIMAL(10,2) NOT NULL,
  subtotal      DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_detalle_compra_compra
    FOREIGN KEY (compra_id)   REFERENCES compra (id)
      ON DELETE CASCADE,
  CONSTRAINT fk_detalle_compra_producto
    FOREIGN KEY (producto_id) REFERENCES producto (id),
  CONSTRAINT ck_detalle_compra_cantidad
    CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- =============================================================
--  6. INVENTARIO
-- =============================================================

-- -------------------------------------------------------------
--  Movimiento de inventario (auditoría de stock)
-- -------------------------------------------------------------
CREATE TABLE movimiento_inventario (
  id                INT          NOT NULL AUTO_INCREMENT,
  producto_id       INT          NOT NULL,
  empleado_id       INT          NOT NULL,
  tipo              ENUM('entrada','salida','ajuste') NOT NULL,
  cantidad          INT          NOT NULL,
  stock_anterior    INT          NOT NULL,
  stock_resultante  INT          NOT NULL,
  motivo            VARCHAR(200)     NULL,
  referencia_id     INT              NULL  COMMENT 'ID de venta o compra que originó el movimiento',
  fecha             TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_movimiento_producto
    FOREIGN KEY (producto_id)  REFERENCES producto (id),
  CONSTRAINT fk_movimiento_empleado
    FOREIGN KEY (empleado_id)  REFERENCES empleado (id)
) ENGINE=InnoDB;

-- =============================================================
--  7. CRÉDITO
-- =============================================================

-- -------------------------------------------------------------
--  Cuenta por cobrar (crédito otorgado al cliente)
-- -------------------------------------------------------------
CREATE TABLE cuenta_por_cobrar (
  id                INT           NOT NULL AUTO_INCREMENT,
  cliente_id        INT           NOT NULL,
  venta_id          INT           NOT NULL,
  monto_total       DECIMAL(10,2) NOT NULL,
  monto_pagado      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  saldo             DECIMAL(10,2) NOT NULL,
  fecha_vencimiento DATE          NOT NULL,
  estado            ENUM('pendiente','pagada','vencida') NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (id),
  CONSTRAINT fk_cxc_cliente
    FOREIGN KEY (cliente_id) REFERENCES cliente (id),
  CONSTRAINT fk_cxc_venta
    FOREIGN KEY (venta_id)   REFERENCES venta (id),
  CONSTRAINT ck_cxc_saldo
    CHECK (saldo >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Cuenta por pagar (deuda con proveedor)
-- -------------------------------------------------------------
CREATE TABLE cuenta_por_pagar (
  id                INT           NOT NULL AUTO_INCREMENT,
  proveedor_id      INT           NOT NULL,
  compra_id         INT           NOT NULL,
  monto_total       DECIMAL(10,2) NOT NULL,
  monto_pagado      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  saldo             DECIMAL(10,2) NOT NULL,
  fecha_vencimiento DATE          NOT NULL,
  estado            ENUM('pendiente','pagada','vencida') NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (id),
  CONSTRAINT fk_cxp_proveedor
    FOREIGN KEY (proveedor_id) REFERENCES proveedor (id),
  CONSTRAINT fk_cxp_compra
    FOREIGN KEY (compra_id)    REFERENCES compra (id),
  CONSTRAINT ck_cxp_saldo
    CHECK (saldo >= 0)
) ENGINE=InnoDB;

-- =============================================================
--  8. ÍNDICES DE RENDIMIENTO
-- =============================================================

CREATE INDEX idx_producto_categoria  ON producto (categoria_id);
CREATE INDEX idx_producto_proveedor  ON producto (proveedor_id);
CREATE INDEX idx_producto_nombre     ON producto (nombre);
CREATE INDEX idx_producto_stock      ON producto (stock_actual);

CREATE INDEX idx_venta_fecha         ON venta (fecha);
CREATE INDEX idx_venta_cliente       ON venta (cliente_id);
CREATE INDEX idx_venta_empleado      ON venta (empleado_id);
CREATE INDEX idx_venta_estado        ON venta (estado);

CREATE INDEX idx_compra_fecha        ON compra (fecha);
CREATE INDEX idx_compra_proveedor    ON compra (proveedor_id);
CREATE INDEX idx_compra_estado       ON compra (estado);

CREATE INDEX idx_movimiento_producto ON movimiento_inventario (producto_id);
CREATE INDEX idx_movimiento_fecha    ON movimiento_inventario (fecha);

CREATE INDEX idx_cxc_cliente         ON cuenta_por_cobrar (cliente_id);
CREATE INDEX idx_cxc_estado          ON cuenta_por_cobrar (estado);
CREATE INDEX idx_cxp_proveedor       ON cuenta_por_pagar  (proveedor_id);
CREATE INDEX idx_cxp_estado          ON cuenta_por_pagar  (estado);

-- =============================================================
--  9. DATOS INICIALES (SEEDS)
-- =============================================================

-- Unidades de medida
INSERT INTO unidad_medida (nombre, abreviatura) VALUES
  ('Pieza',   'pza'),
  ('Caja',    'cja'),
  ('Docena',  'doc'),
  ('Resma',   'rsm'),
  ('Paquete', 'pqt'),
  ('Rollo',   'rll'),
  ('Litro',   'ltr'),
  ('Metro',   'mtr');

-- Roles
INSERT INTO rol (nombre, descripcion, puede_vender, puede_comprar, puede_administrar, puede_reportes) VALUES
  ('Administrador', 'Acceso total al sistema',             TRUE,  TRUE,  TRUE,  TRUE),
  ('Cajero',        'Realiza ventas y cobros',             TRUE,  FALSE, FALSE, FALSE),
  ('Almacenista',   'Gestiona inventario y recepciones',   FALSE, TRUE,  FALSE, FALSE),
  ('Gerente',       'Supervisa operaciones y reportes',    TRUE,  TRUE,  FALSE, TRUE);

-- Categorías principales
INSERT INTO categoria (categoria_padre_id, nombre, descripcion) VALUES
  (NULL, 'Escritura',        'Plumas, lápices, marcadores'),
  (NULL, 'Papel y cuadernos','Hojas, libretas, cuadernos'),
  (NULL, 'Arte y manualidades','Materiales artísticos'),
  (NULL, 'Organización',     'Carpetas, archiveros, clips'),
  (NULL, 'Tecnología',       'Cartuchos, USB, accesorios');

-- Subcategorías
INSERT INTO categoria (categoria_padre_id, nombre) VALUES
  (1, 'Plumas'),
  (1, 'Lápices'),
  (1, 'Marcadores'),
  (2, 'Cuadernos'),
  (2, 'Papel bond'),
  (3, 'Pinturas'),
  (3, 'Cartulinas'),
  (4, 'Carpetas'),
  (4, 'Clips y broches'),
  (5, 'Cartuchos de tinta');

-- Sucursal demo
INSERT INTO sucursal (nombre, direccion, telefono) VALUES
  ('Matriz', 'Av. Principal 100, Centro', '614-000-0000');

-- Empleado administrador (password: admin123 — cambiar en producción)
INSERT INTO empleado (rol_id, sucursal_id, nombre, apellidos, puesto, usuario, password_hash) VALUES
  (1, 1, 'Admin', 'Sistema', 'Administrador',
   'admin',
   '$2b$12$examplehashforadmin123replacewithrealhash');

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
--  FIN DEL SCRIPT
-- =============================================================
