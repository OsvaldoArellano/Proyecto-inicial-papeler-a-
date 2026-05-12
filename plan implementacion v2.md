# 📋 Plan de Implementación Conciso — Sistema "Papelería"
## Flutter + Firebase + Provider | Android • Web • Windows


---

## 🎯 Visión Técnica

```
✅ Objetivo: Sistema de gestión multiplataforma para papelería
✅ Stack: Flutter 3.19+ | Dart 3.3+ | Firebase | Provider
✅ Plataformas: Android (móvil) • Web (PWA) • Windows (escritorio)
✅ Arquitectura: Capas + Feature-first + Repository Pattern
✅ Entrega: Código modular, testeable y listo para producción
```

---

## 🔍 1. Análisis y Arquitectura (Semana 1)

### Requerimientos Priorizados
| Tipo | Esenciales | Secundarios |
|------|-----------|-------------|
| **Funcionales** | Auth con roles, CRUD productos, POS ventas, control de stock, reportes básicos | Multi-sucursal, CRM avanzado, facturación electrónica |
| **No Funcionales** | <3s carga inicial, offline básico, reglas Firestore estrictas, responsive | PWA instalable, impresión térmica, sincronización en tiempo real |

### Decisiones Arquitectónicas Clave
```
🏗️ Patrón: Clean Architecture lite (3 capas)
   → presentation/ (UI + Provider) 
   → domain/ (entities + usecases) 
   → data/ (repositories + Firebase)

📁 Estructura: Feature-first modular
   lib/features/{auth, inventory, sales, crm, admin}/
   → Cada módulo autocontenido y testeable

🔄 Estado: Provider + ChangeNotifier
   → Suficiente para complejidad media, migrable a futuro

🧭 Navegación: go_router con named routes
   → Protección por roles, deep linking, transiciones responsivas
```

---

## 🛠 2. Entorno de Desarrollo (Setup Inicial)

### Checklist de Instalación
```bash
# 1. Flutter SDK ≥3.19 (canal stable)
flutter doctor -v  # Verificar Android, Web, Windows

# 2. IDE: VS Code + extensiones oficiales
#    • Flutter • Dart • Firebase Tools • Pubspec Assist

# 3. Firebase CLI + proyecto
firebase login
flutterfire configure  # Genera firebase_options.dart automático

# 4. Habilitar plataformas objetivo
flutter config --enable-web --enable-windows-desktop

# 5. Estructura base del proyecto
flutter create --org com.papeleria --project-name papeleria_app .
```

### Configuración Mínima de Firebase
| Servicio | Configuración | Propósito |
|----------|--------------|-----------|
| Authentication | Email/Password + email verification | Acceso seguro por roles |
| Firestore | Modo producción + índices compuestos | Base de datos en tiempo real |
| Storage | Reglas por rol + compresión cliente | Imágenes de productos/tickets |
| Crashlytics | Habilitar en release | Monitoreo de errores |

---

## 🏗 3. Estructura del Proyecto (Feature-First)

```
lib/
├── main.dart                    # Inicialización: Firebase + Provider + Router
├── core/                        # Núcleo compartido
│   ├── constants/               # Roles, permisos, UI constants
│   ├── errors/                  # Failures + Exceptions tipados
│   ├── utils/                   # Validators, formatters, helpers
│   └── network/                 # Firebase wrapper + connectivity
│
├── features/                    # Módulos por funcionalidad
│   ├── auth/                    # Login, registro, recuperación
│   ├── inventory/               # Productos, categorías, stock
│   ├── sales/                   # POS, carrito, pagos, tickets
│   ├── crm/                     # Clientes, proveedores, historial
│   └── admin/                   # Reportes, configuración, usuarios
│
└── shared/                      # Recursos transversales
    ├── widgets/                 # Componentes reutilizables
    ├── providers/               # AppProvider, SyncProvider
    ├── routes/                  # go_router config + guards
    └── styles/                  # Tema Material 3 + spacing
```

---

## 🔥 4. Firebase: Datos y Seguridad

### Modelo de Firestore (Colecciones Principales)
```
📁 users/          → uid, email, role, branchId, permissions[]
📁 products/       → sku, name, price, cost, stock, minStock, categoryId
📁 categories/     → name, iconUrl, order, parentId?
📁 sales/          → items[], total, paymentMethod, cashierId, timestamp
📁 stock_movements/→ productId, type, quantity, referenceId, audit trail
📁 customers/      → name, email, totalSpent, creditLimit, points
📁 branches/       → config, settings, multi-sucursal ready
```

### Reglas de Seguridad (Principios)
```js
// ✅ Least privilege + validación server-side
// Ejemplo products/:
allow read: if request.auth != null;  // Solo usuarios autenticados
allow write: if get(/users/$(request.auth.uid)).data.role == 'admin';

// ✅ Transacciones para operaciones críticas (ventas/stock)
// ✅ Auditoría: stock_movements se escribe solo vía Cloud Functions
// ✅ Denormalización estratégica: categoryName en products para lecturas rápidas
```

### Optimización de Consultas
- Índices compuestos para: `[branchId, categoryId, stock]` y `[createdAt DESC]`
- Paginación con `startAfterDocument()` (20-50 docs/página)
- Proyección de campos: `.select(['name', 'price', 'stock'])`
- Cache local con Hive para datos de solo-lectura (categorías, config)

---

## 🎨 5. UI/UX: Diseño Adaptativo

### Sistema de Diseño Mínimo
```
🎨 Tema: Material 3 con paleta profesional (azul primario, grises neutros)
📏 Espaciado: Base 8px (XS:4, S:8, M:16, L:24, XL:32)
🔤 Tipografía: Roboto (títulos bold, cuerpo regular, mono para códigos)
♿ Accesibilidad: Contraste WCAG AA, texto dinámico, navegación por teclado
```

### Adaptación por Plataforma
| Plataforma | Layout | Navegación | Enfoque UX |
|-----------|--------|-----------|-----------|
| **Windows/Web** | Sidebar + contenido principal | Menú lateral + breadcrumbs | Productividad: tablas, atajos de teclado, multi-ventana |
| **Android** | BottomNav + pantallas completas | BottomBar + gestos | Rapidez: búsqueda predictiva, escáner, toques mínimos |
| **Tablet** | Grid responsive 2-3 columnas | Mixto: sidebar colapsable | Balance: información densa + interacción táctil |

### Componentes Críticos Reutilizables
- `ResponsiveDataTable`: Sorting, pagination, export (Web/Desktop)
- `ProductSearchBar`: Búsqueda predictiva con debounce 300ms
- `StockIndicator`: Visual de estado (✅ suficiente / ⚠️ bajo / ❌ agotado)
- `RoleAwareWidget`: Muestra/oculta UI según permisos del usuario
- `LoadingSkeleton`: Feedback visual durante cargas asíncronas

---

## 🔐 6. Autenticación y Roles (RBAC)

### Flujo de Auth Esencial
```
1. Login → Firebase Auth + validación local de formularios
2. Verificación → authStateChanges() + redirección por rol
3. Sesión → Persistencia automática de Firebase + limpieza al logout
4. Recuperación → Email link + validación de fortaleza de contraseña
```

### Matriz de Permisos (RBAC)
| Acción | Admin | Cajero | Empleado | Auditor |
|--------|-------|--------|----------|---------|
| CRUD Productos | ✅ | ❌ | 📖 | 📖 |
| Ajustar Stock | ✅ | 🔄(ventas) | 🔄(recepción) | 📖 |
| Realizar Ventas | ✅ | ✅ | ❌ | ❌ |
| Ver Reportes Financieros | ✅ | ❌ | ❌ | ✅ |
| Gestionar Usuarios | ✅ | ❌ | ❌ | ❌ |

### Implementación Técnica
```dart
// 1. Definir roles y permisos en constants/role_constants.dart
enum AppRole { admin, cashier, employee, auditor }
const rolePermissions = { AppRole.cashier: {'sales:create', 'products:read'} };

// 2. Middleware de rutas (go_router)
RouteGuard(allowedRoles: [AppRole.admin]) → redirige si no tiene permiso

// 3. Validación en UI y backend
context.can('products:delete') → muestra/oculta botón
Firestore rules → valida permisos a nivel de servidor (nunca confiar en cliente)
```

---

## 📦 7. Módulos CRUD: Patrón Estándar

### Flujo Genérico para Cualquier Entidad
```
📋 Listado: 
   • Query paginada con filtros + búsqueda (debounce 300ms)
   • DataTable responsive + acciones contextuales por rol
   • Empty state con CTA para crear primer registro

✏️ Formulario (Crear/Editar):
   • Validación en tiempo real + feedback por campo
   • Guardado borrador local (SharedPreferences)
   • Confirmación antes de cambios críticos

🗑️ Eliminación:
   • Soft delete: isActive = false (no borrar físicamente)
   • Auditoría: registrar quién, cuándo y por qué
   • Diálogo de confirmación con resumen de impacto
```

### Módulo Crítico: POS (Ventas)
```
🔄 Transacción Atómica en Firestore:
1. Crear documento en sales/ con items y totales
2. Decrementar stock en products/ (validar >= 0)
3. Registrar movimiento en stock_movements/ (auditoría)
4. Actualizar customer.totalSpent si aplica
→ Todo en runTransaction() para consistencia

⚡ Optimizaciones POS:
• Búsqueda predictiva por nombre/SKU/código de barras
• Carrito con actualización optimista (UI inmediata, sync después)
• Atajos de teclado (Web/Desktop): F1=buscar, F2=pagar, ESC=cancelar
• Modo offline básico: guardar venta local + sincronizar al reconectar
```

---

## ⚙️ 8. Lógica de Negocio e Inventario

### Reglas de Negocio Críticas
```
✅ Stock: No negativo (excepto configuración "permitir sobreventa")
✅ Precios: Venta > Costo (advertencia si margen < umbral configurable)
✅ Descuentos: Máximo por rol + validación de total >= costo
✅ Caja: Validar (inicial + ventas - retiros) == final con tolerancia
✅ Auditoría: Todo movimiento de stock registra who/when/why
```

### Estrategia Offline-First (Básica)
```
📥 Lecturas: Cache local con Hive + invalidación por snapshot de Firestore
📤 Escrituras: Cola local (Hive) + sincronización automática al reconectar
⚠️ Conflictos: "Última escritura gana" con timestamp de servidor
🔔 Feedback: Indicador visual de estado (🟢 Online / 🟡 Sync / 🔴 Offline)
```

---

## 🚀 9. Optimización y Buenas Prácticas

### Rendimiento Clave
```
⚡ Flutter UI:
• const constructors + Selector<T,R> para evitar rebuilds innecesarios
• ListView.builder para listas largas + cached_network_image para assets

⚡ Firestore:
• Proyectar campos necesarios: .select(['name', 'price'])
• Índices compuestos para queries frecuentes
• Count aggregation en lugar de leer todos los docs para contar

⚡ Memoria:
• Dispose() de StreamSubscription en providers
• Limitar snapshot listeners activos (solo sucursal actual)
• compute() para procesamiento pesado (PDF, reportes)
```

### Calidad de Código
```
🧹 Estándares:
• very_good_analysis en analysis_options.yaml (linting estricto)
• Dartdoc en APIs públicas + README.md por módulo
• Manejo de errores tipado: Failure subclasses + mensajes amigables

🧪 Testing:
• Unit tests: domain/ (usecases, entities) → 80% cobertura
• Widget tests: componentes UI críticos (forms, validation)
• Integration tests: flujos completos con Firebase Emulator Suite
```

---

## 🧪 10. Pruebas y Despliegue

### Estrategia de Testing Mínima
| Tipo | Enfoque | Herramientas |
|------|---------|-------------|
| **Unit** | Lógica pura (validadores, usecases) | test + mockito |
| **Widget** | Interacción UI, estados visuales | flutter_test |
| **Integration** | Flujos completos (login → venta → sync) | integration_test + Firebase Emulator |
| **Manual** | Matriz de dispositivos + escenarios de red | Firebase Test Lab + dispositivos reales |

### Checklist de Despliegue
```
✅ Seguridad: Reglas Firestore en producción, App Check habilitado, datos de prueba eliminados
✅ Rendimiento: flutter build --analyze-size, web-renderer canvaskit, caching headers
✅ Experiencia: Íconos/splash por plataforma, deep links configurados, accesibilidad validada
✅ Legal: Política de privacidad + términos en ajustes, backup automático de Firestore configurado
```

### Builds por Plataforma
```bash
# Android: 
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# Web: 
flutter build web --release --web-renderer canvaskit && firebase deploy --only hosting

# Windows: 
flutter build windows --release + empaquetado con Inno Setup/MSIX
```

---

## 📎 Anexo: Dependencias Esenciales (`pubspec.yaml`)

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
  flutter_svg: ^2.0.9    # Íconos escalables
  skeletonizer: ^1.4.1   # Loading states
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3           # Caché offline
  
  # PDF & Printing
  pdf: ^3.10.7
  printing: ^5.12.0
  
  # Quality
  flutter_lints: ^3.0.1
  logger: ^2.0.2+1       # Logging estructurado
```

---

> ✅ **Próximo Paso**: Con este plan aprobado, iniciar desarrollo con:  
> 1. Estructura de carpetas + `pubspec.yaml` configurado  
> 2. Inicialización de Firebase + `go_router` base  
> 3. Módulo de autenticación como prueba de concepto  
>   
> *¿Procedemos con la generación de código para el módulo de autenticación?* 🚀


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
