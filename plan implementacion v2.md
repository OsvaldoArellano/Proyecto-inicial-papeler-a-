# 📋 Plan de Implementación — Sistema "Papelería Escolar"
## Flutter + Firebase + Provider | Android • Web • Windows

> **Proyecto Escolar** | Enfoque: Arquitectura, Escalabilidad, Funcionalidad

---

## 🎯 Visión Técnica

```
✅ Objetivo: Sistema de gestión multiplataforma para papelería escolar
✅ Stack: Flutter 3.19+ | Dart 3.3+ | Firebase | Provider
✅ Plataformas: Android (móvil) • Web • Windows (escritorio)
✅ Arquitectura: Capas + Feature-first + Repository Pattern
✅ Entrega: Código modular, organizado y funcional
```

---

## 🔍 1. Análisis y Arquitectura (Semana 1)

### Requerimientos Priorizados
| Tipo | Esenciales | Secundarios |
|------|-----------|-------------|
| **Funcionales** | Login con roles, CRUD productos, ventas, control de stock, reportes básicos | Múltiples sucursales, historial de clientes, facturación |
| **No Funcionales** | <3s carga inicial, offline básico, reglas Firestore seguras, diseño responsivo | PWA, impresión de tickets, sincronización |

### Decisiones Arquitectónicas Clave
```
🏗️ Patrón: Clean Architecture simplificado (3 capas)
   → presentation/ (UI + Provider) 
   → domain/ (entidades + casos de uso) 
   → data/ (repositorios + Firebase)

📁 Estructura: Feature-first modular
   lib/features/{auth, inventory, sales, clients, admin}/
   → Cada módulo con su propia lógica

🔄 Estado: Provider + ChangeNotifier
   → Suficiente para el proyecto, fácil de entender

🧭 Navegación: go_router con rutas nombradas
   → Protección por roles, fácil de mantener
```

---

## 🛠 2. Entorno de Desarrollo (Setup Inicial)

### Checklist de Instalación
```bash
# 1. Flutter SDK ≥3.19 (canal stable)
flutter doctor -v  # Verificar Android, Web, Windows

# 2. IDE: VS Code + extensiones oficiales
#    • Flutter • Dart • Firebase Tools

# 3. Firebase CLI + proyecto
firebase login
flutterfire configure  # Genera firebase_options.dart automático

# 4. Habilitar plataformas objetivo
flutter config --enable-web --enable-windows-desktop

# 5. Estructura base del proyecto
flutter create --org com.papelería --project-name papeleria_app .
```

### Configuración Mínima de Firebase
| Servicio | Configuración | Propósito |
|----------|--------------|-----------|
| Authentication | Email/Password + verificación email | Acceso seguro por roles |
| Firestore | Modo producción + índices | Base de datos principal |
| Storage | Reglas por rol | Imágenes de productos |

---

## 🏗 3. Estructura del Proyecto (Feature-First)

```
lib/
├── main.dart                    # Inicialización: Firebase + Provider + Router
├── core/                        # Núcleo compartido
│   ├── constants/               # Roles, permisos, constantes UI
│   ├── errors/                  # Manejo de errores tipados
│   ├── utils/                   # Validadores, formateadores
│   └── network/                 # Wrapper de Firebase
│
├── features/                    # Módulos por funcionalidad
│   ├── auth/                    # Login, registro, recuperación
│   ├── inventory/               # Productos, categorías, stock
│   ├── sales/                   # Punto de venta, carrito, tickets
│   ├── clients/                 # Clientes, historial de compras
│   └── admin/                   # Reportes, configuración, usuarios
│
└── shared/                      # Recursos transversales
    ├── widgets/                 # Componentes reutilizables
    ├── providers/               # Providers principales
    ├── routes/                  # Configuración de rutas
    └── styles/                  # Tema y estilos
```

---


Carpetas

      lib/
      ├── main.dart
      │
      ├── core/
      │   ├── constants/
      │   │   ├── app_constants.dart
      │   │   ├── role_constants.dart
      │   │   └── routes_constants.dart
      │   │
      │   ├── errors/
      │   │   ├── failures.dart
      │   │   └── exceptions.dart
      │   │
      │   ├── utils/
      │   │   ├── validators.dart
      │   │   ├── formatters.dart
      │   │   ├── helpers.dart
      │   │   └── network_utils.dart
      │   │
      │   └── network/
      │       ├── firebase_service.dart
      │       └── connectivity_service.dart
      │
      ├── features/
      │   ├── auth/
      │   │   ├── screens/
      │   │   │   ├── login_screen.dart
      │   │   │   ├── register_screen.dart
      │   │   │   └── forgot_password_screen.dart
      │   │   ├── widgets/
      │   │   │   ├── login_form.dart
      │   │   │   └── register_form.dart
      │   │   ├── providers/
      │   │   │   └── auth_provider.dart
      │   │   ├── models/
      │   │   │   └── user_model.dart
      │   │   └── repositories/
      │   │       └── auth_repository.dart
      │   │
      │   ├── inventory/
      │   │   ├── screens/
      │   │   │   ├── products_screen.dart
      │   │   │   ├── product_detail_screen.dart
      │   │   │   ├── categories_screen.dart
      │   │   │   └── stock_adjustment_screen.dart
      │   │   ├── widgets/
      │   │   │   ├── product_card.dart
      │   │   │   ├── product_form.dart
      │   │   │   ├── category_list.dart
      │   │   │   └── stock_indicator.dart
      │   │   ├── providers/
      │   │   │   └── inventory_provider.dart
      │   │   ├── models/
      │   │   │   ├── product_model.dart
      │   │   │   └── category_model.dart
      │   │   └── repositories/
      │   │       └── inventory_repository.dart
      │   │
      │   ├── sales/
      │   │   ├── screens/
      │   │   │   ├── pos_screen.dart
      │   │   │   ├── cart_screen.dart
      │   │   │   ├── payment_screen.dart
      │   │   │   └── sales_history_screen.dart
      │   │   ├── widgets/
      │   │   │   ├── product_search_bar.dart
      │   │   │   ├── cart_item_card.dart
      │   │   │   ├── payment_method_selector.dart
      │   │   │   └── ticket_preview.dart
      │   │   ├── providers/
      │   │   │   └── sales_provider.dart
      │   │   ├── models/
      │   │   │   ├── sale_model.dart
      │   │   │   └── cart_item_model.dart
      │   │   └── repositories/
      │   │       └── sales_repository.dart
      │   │
      │   ├── clients/
      │   │   ├── screens/
      │   │   │   ├── clients_screen.dart
      │   │   │   ├── client_detail_screen.dart
      │   │   │   └── client_form_screen.dart
      │   │   ├── widgets/
      │   │   │   ├── client_card.dart
      │   │   │   └── client_search.dart
      │   │   ├── providers/
      │   │   │   └── client_provider.dart
      │   │   ├── models/
      │   │   │   └── client_model.dart
      │   │   └── repositories/
      │   │       └── client_repository.dart
      │   │
      │   └── admin/
      │       ├── screens/
      │       │   ├── dashboard_screen.dart
      │       │   ├── reports_screen.dart
      │       │   ├── users_screen.dart
      │       │   └── settings_screen.dart
      │       ├── widgets/
      │       │   ├── report_card.dart
      │       │   ├── user_role_selector.dart
      │       │   └── stats_overview.dart
      │       ├── providers/
      │       │   └── admin_provider.dart
      │       ├── models/
      │       │   └── report_model.dart
      │       └── repositories/
      │           └── admin_repository.dart
      │
      ├── shared/
      │   ├── widgets/
      │   │   ├── custom_button.dart
      │   │   ├── custom_text_field.dart
      │   │   ├── loading_widget.dart
      │   │   ├── error_widget.dart
      │   │   ├── empty_state_widget.dart
      │   │   ├── confirm_dialog.dart
      │   │   └── responsive_data_table.dart
      │   │
      │   ├── providers/
      │   │   ├── app_provider.dart
      │   │   └── sync_provider.dart
      │   │
      │   ├── routes/
      │   │   ├── app_router.dart
      │   │   └── route_guard.dart
      │   │
      │   └── styles/
      │       ├── app_theme.dart
      │       ├── app_colors.dart
      │       └── text_styles.dart
      │
      └── firebase_options.dart

## 🔥 4. Firebase: Datos y Seguridad

### Modelo de Firestore (Colecciones Principales)
```
📁 users/          → uid, email, role, name, active
📁 products/       → sku, name, price, cost, stock, minStock, categoryId
📁 categories/     → name, description, active
📁 sales/          → items[], total, paymentMethod, sellerId, date
📁 stock_movements/→ productId, type, quantity, userId, date
📁 clients/        → name, email, phone, totalPurchases
```

### Reglas de Seguridad (Principios)
```
// ✅ Reglas básicas de Firestore
// Ejemplo products/:
allow read: if request.auth != null;  // Solo usuarios autenticados
allow write: if get(/databases/.../users/$(request.auth.uid)).data.role == 'admin';

// ✅ Transacciones para operaciones críticas (ventas/stock)
// ✅ stock_movements para auditoría
```

### Optimización de Consultas
- Índices compuestos para búsquedas frecuentes
- Paginación con límite de 20-50 documentos
- Selección de campos específicos para ahorrar ancho de banda

---

## 🎨 5. UI/UX: Diseño Adaptativo

### Sistema de Diseño
```
🎨 Tema: Material 3 con colores escolares (azul, verde, tonos neutros)
📏 Espaciado: Base 8px (XS:4, S:8, M:16, L:24, XL:32)
🔤 Tipografía: Roboto (títulos, cuerpo, mono para códigos)
♿ Accesibilidad: Contraste legible, texto ajustable
```

### Adaptación por Plataforma
| Plataforma | Layout | Navegación | Enfoque UX |
|-----------|--------|-----------|-----------|
| **Windows/Web** | Sidebar + contenido | Menú lateral | Productividad: tablas, teclado |
| **Android** | BottomNav + pantallas | Barra inferior | Rapidez: búsqueda, toques |
| **Tablet** | Grid responsive | Mixto | Balance información+toque |

### Componentes Reutilizables
- `DataTable`: Tablas con ordenamiento y paginación
- `SearchBar`: Búsqueda con debounce
- `StockIndicator`: Indicador visual de stock (verde/amarillo/rojo)
- `LoadingWidget`: Feedback durante cargas
- `CustomDialog`: Confirmaciones estilizadas

---

## 🔐 6. Autenticación y Roles

### Flujo de Autenticación
```
1. Login → Firebase Auth + validación de formularios
2. Verificación → Ver estado de autenticación
3. Sesión → Persistencia automática
4. Recuperación → Enlace al email
```

### Matriz de Permisos
| Acción | Admin | Cajero | Empleado |
|--------|-------|--------|----------|
| CRUD Productos | ✅ | ❌ | ❌ |
| Ajustar Stock | ✅ | ❌ | ❌ |
| Realizar Ventas | ✅ | ✅ | ❌ |
| Ver Reportes | ✅ | ❌ | ❌ |
| Gestionar Usuarios | ✅ | ❌ | ❌ |

### Implementación Técnica
```dart
// 1. Definir roles
enum AppRole { admin, cashier, employee }

// 2. Protección de rutas (go_router)
RouteGuard(allowedRoles: [AppRole.admin])

// 3. Validación en UI
if (currentUser.role == 'admin') showAdminButton();
```

---

## 📦 7. Módulos CRUD: Patrón Estándar

### Flujo Genérico
```
📋 Listado: 
   • Consulta paginada con filtros
   • Tarjeta o tabla según plataforma
   • Botón para crear nuevo

✏️ Formulario (Crear/Editar):
   • Validación en tiempo real
   • Guardado al enviar
   • Confirmación de cambios

🗑️ Eliminación:
   • Soft delete (isActive = false)
   • Diálogo de confirmación
```

### Módulo Principal: Punto de Venta
```
🔄 Transacción en Firestore:
1. Crear documento en sales/ con items
2. Actualizar stock en products/ (validar suficiente)
3. Registrar movimiento en stock_movements/
→ Todo en transacción para consistencia

⚡ Optimizaciones:
• Búsqueda por nombre/SKU
• Carrito con actualización inmediata
• Atajos de teclado básicos
```

---

## ⚙️ 8. Lógica de Negocio e Inventario

### Reglas de Negocio
```
✅ Stock: No puede ser negativo
✅ Precios: Precio de venta > costo
✅ Descuentos: Máximo 30% para cajeros
✅ Auditoría: Registrar todo cambio de stock
```

### Estrategia Offline (Básica)
```
📥 Lecturas: Cache local simple
📤 Escrituras: Queue local + sincronización al reconectar
🔔 Indicador visual: Ícono de estado de conexión
```

---

## 🚀 9. Optimización y Buenas Prácticas

### Rendimiento
```
⚡ Flutter UI:
• const constructors
• ListView.builder para listas largas

⚡ Firestore:
• Seleccionar campos necesarios
• Índices para queries comunes

⚡ Memoria:
• Dispose() de streams
• Limitar listeners activos
```

### Calidad de Código
```
🧹 Estándares:
• Código limpio y comentado
• Documentación básica
• Manejo de errores amigable

🧪 Testing básico:
• Pruebas unitarias para lógica importante
• Pruebas de widgets críticos
```

---

## 🧪 10. Pruebas y Despliegue

### Estrategia de Testing
| Tipo | Enfoque | Herramientas |
|------|---------|-------------|
| **Unit** | Validadores, cálculos | test |
| **Widget** | Componentes UI | flutter_test |
| **Integration** | Flujos completos | integration_test |

### Checklist de Despliegue
```
✅ Seguridad: Reglas Firestore configuradas
✅ Rendimiento: Build optimizado por plataforma
✅ Experiencia: Íconos y splash screens
✅ Legal: Política básica de privacidad
```

### Builds por Plataforma
```bash
# Android: 
flutter build apk --release

# Web: 
flutter build web --release

# Windows: 
flutter build windows --release
```

---

## 📎 Anexo: Dependencias Esenciales

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  
  # State & Navigation
  provider: ^6.1.1
  go_router: ^13.2.0
  
  # UI & Utils
  cached_network_image: ^3.3.1
  intl: ^0.19.0          # Formato moneda/fechas
  flutter_svg: ^2.0.9    # Íconos
  skeletonizer: ^1.4.1   # Loading states
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3           # Caché offline
  
  # PDF & Printing
  pdf: ^3.10.7
  printing: ^5.12.0
  
  # Quality
  flutter_lints: ^3.0.1
```

---

> ✅ **Próximo Paso**: Iniciar desarrollo con:  
> 1. Estructura de carpetas  
> 2. Configuración de Firebase  
> 3. Módulo de autenticación  
>   
> *¿Procedemos con la implementación del módulo de autenticación?* 🚀

## Prompt

Este es el plan técnico detallado para la implementación del sistema de papelería, redactado de forma narrativa y estructurada para guiar cada etapa del proceso de desarrollo bajo una visión de arquitectura profesional.

## Análisis, Planeación y Arquitectura del Sistema

El éxito de una solución multiplataforma reside en un análisis exhaustivo antes de escribir la primera línea de código. En esta fase, identificamos que el sistema no solo debe registrar transacciones, sino garantizar la integridad de los datos entre dispositivos. Los requerimientos funcionales se centran en la gestión integral de inventario, ventas y roles, mientras que los no funcionales priorizan la baja latencia y la sincronización en tiempo real. Para lograr esto, adoptaremos una arquitectura de capas que separe la interfaz de usuario de la lógica de negocio y el acceso a datos. Esta separación de responsabilidades asegura que el sistema sea mantenible a largo plazo, permitiendo que cambios en las reglas de negocio no afecten la estabilidad de las vistas en Android, Web o Windows.

## Configuración del Entorno y Estructura del Proyecto

Para el desarrollo, prepararemos un entorno robusto utilizando el SDK de Flutter en su canal estable, configurando los compiladores específicos para cada plataforma: Build Tools de C++ para Windows, Java 17 para Android y Xcode para el ecosistema Apple. La integración con Firebase se realizará mediante el CLI de FlutterFire, lo que garantiza una configuración nativa y segura desde el inicio. La estructura del proyecto será modular, organizada en carpetas de modelos para la definición de datos, servicios para la comunicación externa y repositorios para la lógica de persistencia. Utilizaremos el paquete Provider como motor de gestión de estado, inyectándolo en la raíz de la aplicación para permitir que la información fluya de manera reactiva y eficiente entre los diferentes módulos del sistema.

## Integración de Firebase y Gestión de Datos

La persistencia de la información se confiará a Firebase, aprovechando Cloud Firestore por su capacidad de respuesta en tiempo real y su escalabilidad. Estructuraremos la base de datos de forma no relacional, optimizando las colecciones para reducir los costos de lectura y mejorar la velocidad de respuesta en la web y dispositivos móviles. Implementaremos Firebase Authentication para gestionar el acceso seguro de los usuarios, mientras que Firebase Storage se encargará de almacenar evidencias visuales de los productos y comprobantes. La seguridad será una prioridad, por lo que diseñaremos reglas de seguridad en Firestore que validen los permisos de cada usuario a nivel de servidor, evitando que un empleado pueda acceder a información financiera restringida al administrador.

## Diseño de Interfaz y Experiencia de Usuario (UI/UX)

El diseño del sistema será adaptativo, lo que significa que la interfaz se transformará según el tamaño de la pantalla y el sistema operativo. En Windows y Web, el sistema presentará un panel lateral expansivo y tablas de datos detalladas que faciliten la administración masiva. En Android e iOS, la interfaz se simplificará para priorizar la rapidez de uso, con menús táctiles y escaneo de códigos de barras mediante la cámara. Crearemos una biblioteca de componentes reutilizables, como botones de acción, diálogos de confirmación y campos de entrada validados, lo que garantiza una estética profesional y coherente en todas las pantallas del sistema, desde el dashboard de ventas hasta la gestión de sucursales.

## Lógica de Negocio y Operaciones CRUD

El núcleo del sistema será el desarrollo de los módulos CRUD (Crear, Leer, Actualizar y Borrar) para cada entidad, como productos, proveedores y clientes. La lógica de negocio más crítica residirá en el manejo de inventarios; utilizaremos transacciones atómicas de Firestore para asegurar que, al realizar una venta, el stock se descuente de forma precisa sin riesgo de duplicidad o errores por pérdida de conexión. Cada movimiento de caja o cambio de inventario quedará registrado en un historial de auditoría. El sistema de roles y permisos controlará el flujo de navegación, asegurando que cada perfil de usuario vea únicamente las funciones necesarias para su trabajo, optimizando así la operatividad diaria de la papelería.

## Optimización, Pruebas y Despliegue

En la fase final, nos enfocaremos en la optimización del rendimiento, implementando estrategias de almacenamiento en caché para permitir el trabajo en condiciones de internet inestable y reduciendo el consumo de recursos en la web. Realizaremos un ciclo riguroso de pruebas unitarias y de integración para validar que los cálculos de ventas y los permisos de seguridad funcionen perfectamente en Android, Windows e iOS. Finalmente, el despliegue se realizará de forma nativa para cada plataforma: generaremos App Bundles para la Play Store, ejecutables optimizados para Windows y utilizaremos Firebase Hosting para la versión web. Este plan garantiza que la aplicación no solo sea funcional, sino una herramienta empresarial sólida, escalable y lista para la producción.
