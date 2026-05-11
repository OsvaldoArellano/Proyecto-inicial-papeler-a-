## actúa como un administrador de base de datos: proyecto Papelería, que entidades se necesitan para su gestión.

## Proyecto Papelería — Entidades para su Gestión

<img width="721" height="216" alt="image" src="https://github.com/user-attachments/assets/b8177891-d7b8-42e8-8f9c-e5fb345931b0" />

Como DBA, modelaría el sistema con las siguientes entidades principales:

---

### 🏪 核心 del Negocio

**1. Producto**
campos clave: id, nombre, descripción, precio_venta, precio_costo, stock_actual, stock_mínimo, código_barras, imagen

**2. Categoría**
campos clave: id, nombre, descripción, categoría_padre (para subcategorías)

**3. Proveedor**
campos clave: id, nombre, RFC, teléfono, email, dirección, condiciones_pago

---

### 👥 Personas

**4. Cliente**
campos clave: id, nombre, apellidos, teléfono, email, dirección, tipo (mayoreo/menudeo), crédito_disponible

**5. Empleado**
campos clave: id, nombre, apellidos, puesto, turno, usuario_sistema, contraseña_hash

---

### 💰 Transacciones de Venta

**6. Venta**
campos clave: id, fecha, cliente_id, empleado_id, total, descuento, tipo_pago, estado

**7. Detalle_Venta**
campos clave: id, venta_id, producto_id, cantidad, precio_unitario, subtotal

**8. Pago**
campos clave: id, venta_id, monto, método (efectivo/tarjeta/transferencia), fecha, referencia

---

### 📦 Inventario y Compras

**9. Compra** *(a proveedor)*
campos clave: id, proveedor_id, empleado_id, fecha, total, estado (pendiente/recibida)

**10. Detalle_Compra**
campos clave: id, compra_id, producto_id, cantidad, precio_costo, subtotal

**11. Movimiento_Inventario**
campos clave: id, producto_id, tipo (entrada/salida/ajuste), cantidad, fecha, motivo, referencia_id

---

### 💳 Crédito y Cuentas

**12. Cuenta_por_Cobrar**
campos clave: id, cliente_id, venta_id, monto_total, monto_pagado, saldo, fecha_vencimiento, estado

**13. Cuenta_por_Pagar**
campos clave: id, proveedor_id, compra_id, monto_total, monto_pagado, saldo, fecha_vencimiento

---

### ⚙️ Configuración

**14. Unidad_Medida** — pieza, caja, docena, resma, etc.
**15. Sucursal** — si hay más de un punto de venta
**16. Caja** — control de apertura/cierre de caja por turno
**17. Permiso / Rol** — control de acceso por perfil de usuario

---

### 🔗 Relaciones Clave

```
Categoría ──< Producto >── Proveedor
Producto ──< Detalle_Venta >── Venta ──> Cliente
Venta ──< Pago
Compra ──< Detalle_Compra >── Producto
Empleado ──> Venta / Compra / Movimiento_Inventario
```

---

¿Quieres que profundice en alguna entidad, genere el **DDL en SQL**, el **diagrama ER**, o defina las **reglas de negocio** específicas?



## las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades

## tablas
<img width="758" height="446" alt="image" src="https://github.com/user-attachments/assets/d5fc8eaa-871d-4612-a467-58a69c3d953c" />
<img width="753" height="342" alt="image" src="https://github.com/user-attachments/assets/68c5494b-25c7-4087-ae51-1d496878668d" />
<img width="800" height="426" alt="image" src="https://github.com/user-attachments/assets/0ca8cc2c-aea0-47ab-ad96-5f4a0afc595b" />
<img width="742" height="415" alt="image" src="https://github.com/user-attachments/assets/9ab4aba8-30a4-49e3-a76e-ef5207eee0f2" />
<img width="796" height="589" alt="image" src="https://github.com/user-attachments/assets/bb8b6a2d-b4e9-46d7-a798-925180301aab" />
<img width="743" height="630" alt="image" src="https://github.com/user-attachments/assets/f6eb630b-4d07-4e33-bc7d-9b4ebc0db827" />
<img width="849" height="604" alt="image" src="https://github.com/user-attachments/assets/5f7ba48f-3d77-4b9f-ad9d-395b3ddb9a27" />



## de acuerdo a tu respuesta anterior puedes generar un script en sql para descargar con el nombre de bdpapeleria.sql para las entidades con sus relaciones


