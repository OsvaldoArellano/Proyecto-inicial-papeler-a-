# 📋 Plan de Implementación Técnico — Sistema de Gestión "Papelería"
## Flutter + Firebase + Provider | Multiplataforma (Android • Web • Windows)

> **Documento Técnico v2.0** | Arquitecto de Software Senior  
> *Guía completa de desarrollo sin código — Enfoque en arquitectura, escalabilidad y producción*

---

## 🎯 Visión General del Sistema

```
🏪 Papelería Management System
├── 📱 Multiplataforma: Android • Web • Windows
├── 🔐 Backend: Firebase (Auth • Firestore • Storage)
├── 🧱 Arquitectura: Modular por capas + Provider
├── 👥 Roles: Admin • Cajero • Empleado • Auditor
├── 📦 Módulos: Inventario • Ventas • Compras • CRM • Reportes
├── 🚀 Objetivo: Solución escalable, segura y lista para producción
```

---

## 🔍 1. Análisis y Planeación del Sistema

### 1.1. Identificación de Requerimientos

#### ✅ Requerimientos Funcionales (RF)
| ID | Módulo | Descripción | Prioridad |
|----|--------|-------------|-----------|
| RF-01 | Autenticación | Login con email/password, recuperación, gestión de sesión | Crítico |
| RF-02 | Roles y Permisos | Sistema RBAC con 4 niveles de acceso | Crítico |
| RF-03 | Productos | CRUD completo con variantes, imágenes, códigos de barra | Crítico |
| RF-04 | Inventario | Control de stock en tiempo real, alertas, ajustes | Crítico |
| RF-05 | Ventas (POS) | Proceso de venta con carrito, descuentos, múltiples pagos | Crítico |
| RF-06 | Compras | Registro de proveedores, órdenes de compra, recepción | Alta |
| RF-07 | Clientes | CRM básico: datos, historial, créditos, puntos | Alta |
| RF-08 | Empleados | Registro, asignación de roles, control de actividad | Media |
| RF-09 | Caja | Apertura/cierre, arqueos, movimientos de efectivo | Alta |
| RF-10 | Reportes | Ventas diarias, inventario, ganancias, exportación | Media |
| RF-11 | Multi-sucursal | Estructura preparada para escalado a múltiples tiendas | Futuro |

#### ⚙️ Requerimientos No Funcionales (RNF)
| ID | Categoría | Especificación | Métrica |
|----|-----------|----------------|---------|
| RNF-01 | Rendimiento | Carga inicial < 3s, consultas Firestore < 500ms | P95 |
| RNF-02 | Disponibilidad | 99.5% uptime, manejo offline básico | SLA |
| RNF-03 | Seguridad | Datos en tránsito (TLS), reglas Firestore estrictas | OWASP |
| RNF-04 | Escalabilidad | Soporte hasta 10k productos, 1k ventas/día | Crecimiento |
| RNF-05 | Usabilidad | UX consistente, accesibilidad WCAG AA, responsive | NPS > 40 |
| RNF-06 | Mantenibilidad | Código documentado, tests > 70%, CI/CD básico | Technical Debt |
| RNF-07 | Multiplataforma | Mismo código base para Android, Web, Windows | Flutter |

### 1.2. Organización de Módulos Principales

```
📦 Sistema Papelería
│
├── 🔐 Módulo de Seguridad
│   ├── Autenticación Firebase
│   ├── Gestión de roles y permisos
│   ├── Auditoría de accesos
│   └── Recuperación y políticas de contraseña
│
├── 📦 Módulo de Inventario
│   ├── Productos (CRUD + variantes)
│   ├── Categorías y subcategorías
│   ├── Proveedores y compras
│   ├── Control de stock y alertas
│   └── Ajustes de inventario (mermas, devoluciones)
│
├── 💰 Módulo de Ventas (POS)
│   ├── Interfaz de punto de venta
│   ├── Carrito de ventas con descuentos
│   ├── Múltiples métodos de pago
│   ├── Tickets y facturación básica
│   └── Historial y reimpresión
│
├── 👥 Módulo de CRM
│   ├── Clientes y historial de compras
│   ├── Créditos y estados de cuenta
│   ├── Programa de puntos/lealtad
│   └── Segmentación para promociones
│
├── 📊 Módulo Administrativo
│   ├── Dashboard con KPIs en tiempo real
│   ├── Reportes exportables (PDF/CSV)
│   ├── Gestión de caja (aperturas/cierres)
│   └── Configuración del sistema
│
└── ⚙️ Módulo de Configuración
    ├── Perfiles de usuario y preferencias
    ├── Sucursales (estructura multi-tenant)
    ├── Respaldos y sincronización
    └── Logs y monitoreo
```

### 1.3. Decisiones Arquitectónicas Críticas

```dart
// 🎯 Por qué estas decisiones importan:

✅ Arquitectura por Capas (Clean Architecture lite)
   → Separa responsabilidades: UI no conoce de Firebase
   → Facilita testing, mantenimiento y cambios de backend
   → Ejemplo: Repository Pattern para abstracción de datos

✅ Provider + ChangeNotifier (no Riverpod/Bloc inicialmente)
   → Curva de aprendizaje suave para equipos pequeños
   → Suficiente para complejidad media del proyecto
   → Migración futura posible sin reescribir todo

✅ Named Routes con go_router
   → Navegación declarativa y tipada
   → Protección de rutas por roles integrada
   → Deep linking listo para web y móvil

✅ Firestore con estructura "denormalizada controlada"
   → Lecturas rápidas para operaciones críticas (POS)
   → Duplicación estratégica de datos de solo-lectura
   → Reglas de seguridad granulares por colección

✅ Modularización por feature (no por tipo de archivo)
   → /features/inventory/, /features/sales/, etc.
   → Cada módulo es autocontenido y testeable
   → Facilita trabajo en equipo y escalado
```

> ⚠️ **Lección de arquitectura**: Una mala decisión inicial (ej: mezclar UI con lógica de Firebase) puede duplicar el tiempo de desarrollo en fase de mantenimiento. Invertir 2-3 días en planificación ahorra 2-3 semanas después.

---

## 🛠 2. Configuración del Entorno de Desarrollo

### 2.1. Instalación y Verificación de Herramientas

#### 📋 Checklist de Instalación
```bash
# 1. Flutter SDK (≥3.19, canal stable)
→ Descargar desde flutter.dev o usar fvm para gestión de versiones
→ Agregar a PATH: export PATH="$PATH:`pwd`/flutter/bin"
→ Verificar: flutter doctor -v

# 2. Dart SDK (viene con Flutter, verificar versión ≥3.3)
→ dart --version

# 3. IDE: Visual Studio Code (Recomendado)
→ Extensiones obligatorias:
   • Flutter & Dart (oficiales)
   • Error Lens (mejora visibilidad de errores)
   • Pubspec Assist (gestión de dependencias)
   • Firebase Tools (integración con CLI)
   • Code Spell Checker (calidad de código)

# 4. Alternativa: Android Studio
→ Solo si se requiere emulador avanzado o profiling nativo
→ Configurar plugin Flutter/Dart y SDK paths

# 5. Firebase CLI
→ npm install -g firebase-tools
→ firebase login
→ firebase --version

# 6. Git + GitHub/GitLab
→ Configurar SSH keys, .gitignore para Flutter
→ Crear repositorio con ramas: main, develop, feature/*

# 7. Emuladores / Dispositivos
→ Android: Android Studio → AVD Manager (API 24+)
→ Web: Chrome con flutter run -d chrome
→ Windows: Habilitar desktop: flutter config --enable-windows-desktop
```

#### 🔧 Variables de Entorno Recomendadas
```bash
# ~/.bashrc o ~/.zshrc
export FLUTTER_HOME=/path/to/flutter
export PATH="$FLUTTER_HOME/bin:$PATH"
export PUB_CACHE="$HOME/.pub-cache"  # Opcional: caché personalizado

# Variables del proyecto (no commitear .env)
FIREBASE_API_KEY=xxx
FIREBASE_APP_ID=xxx
FIREBASE_PROJECT_ID=papeleria-prod
```

### 2.2. Creación del Proyecto Inicial

```bash
# 1. Crear proyecto Flutter multiplataforma
flutter create --org com.papeleria --project-name papeleria_app papeleria_app

# 2. Configurar plataformas objetivo
cd papeleria_app
flutter config --enable-web
flutter config --enable-windows-desktop
# (iOS/macOS si aplica: flutter config --enable-ios)

# 3. Estructura inicial de carpetas (limpiar ejemplo)
rm -rf lib/main.dart test/
mkdir -p lib/{core,features,shared}
mkdir -p lib/core/{constants,errors,utils,network}
mkdir -p lib/features/{auth,inventory,sales,crm,admin}
mkdir -p lib/shared/{widgets,providers,routes,styles}

# 4. Archivo pubspec.yaml base (dependencias mínimas)
# → Se detallan en sección 4
```

### 2.3. Integración Inicial de Firebase

```
🔥 Pasos en Firebase Console:

1. Crear nuevo proyecto: "papeleria-prod"
2. Habilitar servicios:
   ✓ Authentication (Email/Password)
   ✓ Cloud Firestore (modo producción)
   ✓ Firebase Storage (para imágenes de productos)
   ✓ (Opcional) Performance Monitoring, Crashlytics

3. Registrar aplicaciones:
   • Android: 
     - Package: com.papeleria.app
     - SHA-1: (debug y release)
     - Descargar google-services.json → android/app/
   
   • Web:
     - Registrar y copiar firebaseConfig
     - Guardar en lib/core/config/firebase_options.dart
   
   • Windows:
     - Usar configuración web o crear app separada
     - Considerar uso de variables de entorno para config

4. Descargar archivos de configuración y verificar estructura:
papeleria_app/
├── android/app/google-services.json
├── lib/core/config/
│   ├── firebase_options.dart (Web)
│   └── firebase_config.dart (Multiplataforma)
└── windows/flutter/CMakeLists.txt (configurar si aplica)

5. Probar conexión inicial:
   → Crear main.dart mínimo que inicialice Firebase
   → Ejecutar en Chrome/Android para verificar
```

> ✅ **Verificación exitosa**: La app inicia sin errores, Firebase se inicializa, y puedes ver el proyecto en Firebase Console → Analytics en tiempo real.

---

## 🏗 3. Arquitectura y Estructura del Proyecto

### 3.1. Estructura de Carpetas Profesional (Feature-First)

```
lib/
│
├── main.dart                    # Punto de entrada, configuración global
├── core/                        # Núcleo compartido (no depende de features)
│   ├── constants/
│   │   ├── app_constants.dart   # URLs, timeouts, límites
│   │   ├── role_constants.dart  # Definición de roles y permisos
│   │   └── ui_constants.dart    # Spacing, border radius, z-index
│   ├── errors/
│   │   ├── failures.dart        # Clase base Failure + subclases
│   │   └── exceptions.dart      # Excepciones personalizadas
│   ├── utils/
│   │   ├── validators.dart      # Validadores reutilizables
│   │   ├── formatters.dart      # Formato de moneda, fechas
│   │   └── helpers.dart         # Funciones utilitarias puras
│   ├── network/
│   │   ├── firebase_service.dart # Wrapper para Firestore con manejo de errores
│   │   └── connectivity.dart    # Detección de estado de red
│   └── config/
│       ├── firebase_options.dart # Configuración multi-plataforma
│       ├── router.dart          # Configuración de go_router
│       └── theme.dart           # Tema Material 3 personalizado
│
├── features/                    # Módulos por funcionalidad (autocontenidos)
│   │
│   ├── auth/                    # Módulo de autenticación
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_session_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── check_auth_status_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── recovery_screen.dart
│   │       └── widgets/
│   │           ├── auth_form.dart
│   │           └── role_selector.dart
│   │
│   ├── inventory/               # Módulo de inventario (ejemplo completo)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── product_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── product_model.dart
│   │   │   │   ├── category_model.dart
│   │   │   │   └── stock_movement_model.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── product_entity.dart
│   │   │   │   └── stock_alert_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_products_usecase.dart
│   │   │       ├── update_stock_usecase.dart
│   │   │       └── check_low_stock_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── product_provider.dart
│   │       │   └── inventory_filter_provider.dart
│   │       ├── screens/
│   │       │   ├── product_list_screen.dart
│   │       │   ├── product_form_screen.dart
│   │       │   └── stock_alerts_screen.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           ├── stock_indicator.dart
│   │           └── product_search_bar.dart
│   │
│   ├── sales/                   # Módulo de ventas (POS)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── cart_provider.dart      # Estado del carrito
│   │       │   ├── pos_session_provider.dart # Sesión de caja
│   │       │   └── payment_provider.dart   # Procesamiento de pagos
│   │       ├── screens/
│   │       │   ├── pos_screen.dart         # Interfaz principal de venta
│   │       │   ├── cart_summary_screen.dart
│   │       │   └── receipt_screen.dart
│   │       └── widgets/
│   │           ├── cart_item_tile.dart
│   │           ├── payment_method_selector.dart
│   │           └── quick_product_search.dart
│   │
│   ├── crm/                     # Clientes y proveedores
│   ├── admin/                   # Reportes, configuración, usuarios
│   └── dashboard/               # Vista principal con KPIs
│
├── shared/                      # Recursos compartidos entre features
│   ├── widgets/
│   │   ├── app_bar/
│   │   │   ├── responsive_app_bar.dart
│   │   │   └── role_aware_app_bar.dart
│   │   ├── forms/
│   │   │   ├── labeled_text_field.dart
│   │   │   ├── currency_input.dart
│   │   │   └── date_picker_field.dart
│   │   ├── feedback/
│   │   │   ├── error_banner.dart
│   │   │   ├── loading_overlay.dart
│   │   │   └── success_snackbar.dart
│   │   └── layout/
│   │       ├── responsive_grid.dart
│   │       ├── desktop_sidebar.dart
│   │       └── mobile_bottom_nav.dart
│   ├── providers/
│   │   ├── app_provider.dart    # Estado global (tema, idioma, sucursal)
│   │   └── sync_provider.dart   # Manejo de sincronización offline
│   ├── routes/
│   │   ├── app_router.dart      # Configuración central de go_router
│   │   ├── route_guard.dart     # Middleware para protección por roles
│   │   └── route_names.dart     # Constantes de nombres de rutas
│   └── styles/
│       ├── app_theme.dart       # Tema Material 3 personalizado
│       ├── text_styles.dart     # Tipografía escalable
│       └── spacing.dart         # Sistema de espaciado consistente
│
└── services/                    # Servicios transversales
    ├── pdf_generator.dart       # Generación de tickets/reportes
    ├── printer_service.dart     # Integración con impresoras térmicas (Web/Desktop)
    ├── backup_service.dart      # Exportación/respaldo de datos
    └── analytics_service.dart   # Eventos personalizados para Firebase Analytics
```

### 3.2. Patrón de Arquitectura: Capas con Provider

```
🔄 Flujo de Datos (Ejemplo: Actualizar Stock)

[Presentation Layer]
│
├── ProductFormScreen (UI)
│   └── onSubmit() → llama a ProductProvider.updateStock()
│
├── ProductProvider (ChangeNotifier)
│   ├── Valida datos localmente
│   ├── Cambia estado a 'loading'
│   └── Llama a UseCase: UpdateStockUseCase.call(params)
│
[Domain Layer]
│
├── UpdateStockUseCase
│   ├── Recibe ProductEntity + cantidad
│   ├── Valida reglas de negocio (stock no negativo, permisos)
│   └── Llama a Repository: productRepository.updateStock()
│
├── ProductRepository (interface)
│   └── Define contrato: Future<void> updateStock(String productId, int delta)
│
[Data Layer]
│
├── ProductRepositoryImpl (implementación)
│   ├── Llama a DataSource: productRemoteDataSource.updateStock()
│   ├── Maneja errores de red → convierte a Failure
│   └── Retorna Either<Failure, void>
│
├── ProductRemoteDataSource
│   ├── Usa FirebaseFirestore.instance.collection('products')
│   ├── Ejecuta transacción atómica para consistencia
│   ├── Actualiza también colección 'stock_movements' para auditoría
│   └── Lanza excepción si falla
│
[Retorno]
│
└── El resultado fluye de regreso:
    Data → Domain → Presentation → UI se actualiza con Provider
    Errores se muestran con feedback amigable al usuario
```

### 3.3. Navegación con go_router (Named Routes + Protección)

```dart
// 📍 lib/shared/routes/app_router.dart (conceptual, sin código)

✅ Configuración Centralizada:
• Definir todas las rutas en una sola lista de GoRoute
• Usar nombres constantes: RouteNames.login, RouteNames.pos
• Parámetros tipados: /product/:productId
• Query params para filtros: /inventory?category=office&lowStock=true

✅ Protección por Roles (Route Guard):
• Middleware que verifica AuthProvider.currentUser.role
• Redirige a /unauthorized si no tiene permiso
• Ejemplo: Ruta /admin/* solo accesible para role: admin

✅ Navegación Responsiva:
• En móvil: BottomNavigationBar con 4-5 ítems principales
• En escritorio: Sidebar lateral colapsable + breadcrumbs
• Transiciones suaves con PageTransitionsBuilder personalizado

✅ Deep Linking:
• Web: papeleria.app/inventory/abc123 abre producto directo
• Móvil: Links desde email/notificaciones abren pantalla específica
• Configuración de android/app/src/main/AndroidManifest.xml y web/index.html
```

### 3.4. Gestión de Estado con Provider (Escalable)

```
🎯 Estrategia por Nivel de Estado:

┌─────────────────────────────────────┐
│ 🔴 Estado Global (AppProvider)      │
│ • Tema (claro/oscuro)               │
│ • Idioma (es/en)                    │
│ • Sucursal activa (para multi-tenant)│
│ • Conexión a internet               │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 🟡 Estado de Sesión (AuthProvider)  │
│ • Usuario actual + rol              │
│ • Token de sesión (manejado por Firebase)│
│ • Permisos calculados               │
│ • Última actividad (para timeout)   │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 🟢 Estado de Feature (ej: CartProvider)│
│ • Lista de items en carrito         │
│ • Total calculado                   │
│ • Descuentos aplicados              │
│ • Método de pago seleccionado       │
│ • Solo vive mientras dura la venta  │
└─────────────────────────────────────┘

✅ Buenas Prácticas con Provider:
• Usar ChangeNotifierProvider.value() para evitar rebuilds innecesarios
• Separar providers grandes: ProductProvider ≠ InventoryFilterProvider
• Usar Selector<T, R> en lugar de Consumer<T> cuando solo se necesita un campo
• Implementar dispose() correctamente para evitar memory leaks
• Para estados complejos: considerar ValueNotifier + ProxyProvider
```

---

## 🔥 4. Configuración de Firebase y Base de Datos

### 4.1. Integración de Servicios Firebase

| Servicio | Propósito | Configuración Clave |
|----------|-----------|-------------------|
| **Firebase Authentication** | Login email/password, gestión de sesión | Habilitar email verification, configurar password policy |
| **Cloud Firestore** | Base de datos principal, tiempo real | Modo producción, índices compuestos, reglas de seguridad |
| **Firebase Storage** | Imágenes de productos, logos, tickets | Reglas de acceso por rol, compresión en cliente |
| **Firebase Analytics** | Métricas de uso, embudos de venta | Eventos personalizados: `sale_completed`, `low_stock_alert` |
| **Firebase Crashlytics** | Monitoreo de errores en producción | Habilitar en builds de release, reportes agrupados |
| **Firebase Performance** | Monitoreo de rendimiento de consultas | Tracing personalizado para operaciones críticas (POS) |

### 4.2. Estructura de Firestore: Colecciones y Relaciones

```
🗄️ Modelo de Datos (Denormalización Estratégica)

📁 users/ (documentos por uid)
├── uid: string
├── email: string
├── displayName: string
├── role: 'admin' | 'cashier' | 'employee' | 'auditor'
├── branchId: string (referencia a sucursal)
├── permissions: string[] (calculado desde role)
├── createdAt: timestamp
├── lastLogin: timestamp
└── isActive: boolean

📁 branches/ (sucursales)
├── id: string
├── name: string
├── address: string
├── config: {
│     currency: 'MXN',
│     taxRate: 0.16,
│     lowStockThreshold: 10
│   }
└── settings: { ... }

📁 categories/
├── id: string
├── name: string
├── slug: string (para URLs amigables)
├── iconUrl: string (Storage)
├── parentId: string? (para subcategorías)
├── order: number
└── isActive: boolean

📁 products/ (colección principal)
├── id: string
├── name: string
├── description: string
├── sku: string (único, código de barras)
├── categoryId: string (referencia)
├── branchId: string (para multi-sucursal)
├── price: number (precio de venta)
├── cost: number (precio de compra, solo admin)
├── stock: number (stock actual, denormalizado para lecturas rápidas)
├── minStock: number (alerta)
├── images: string[] (URLs de Storage)
├── variants: [ { name: 'Color', options: ['Rojo', 'Azul'] } ]?
├── isActive: boolean
├── createdAt: timestamp
└── updatedAt: timestamp

📁 stock_movements/ (auditoría de inventario)
├── id: string
├── productId: string
├── branchId: string
├── type: 'in' | 'out' | 'adjustment' | 'sale' | 'return'
├── quantity: number (positivo para entradas, negativo para salidas)
├── referenceId: string? (orderId, purchaseId, etc.)
├── performedBy: string (uid del usuario)
├── notes: string?
├── timestamp: timestamp
└── previousStock: number (para trazabilidad)

📁 sales/ (ventas)
├── id: string
├── branchId: string
├── cashierId: string (uid)
├── items: [ {
│     productId: string,
│     name: string (denormalizado para historial),
│     price: number,
│     quantity: number,
│     discount: number,
│     subtotal: number
│   } ]
├── subtotal: number
├── tax: number
├── total: number
├── paymentMethod: 'cash' | 'card' | 'transfer' | 'credit'
├── paymentDetails: { ... } (datos de tarjeta, referencia, etc.)
├── status: 'completed' | 'cancelled' | 'refunded'
├── customerEmail: string? (para CRM)
├── createdAt: timestamp
└── receiptUrl: string? (PDF generado en Storage)

📁 customers/ (CRM)
├── id: string (o email como ID)
├── name: string
├── email: string
├── phone: string
├── totalSpent: number (denormalizado)
├── visitCount: number
├── creditLimit: number
├── currentDebt: number
├── points: number (programa de lealtad)
├── tags: string[] (ej: 'frecuente', 'mayorista')
└── createdAt: timestamp

📁 purchases/ (compras a proveedores)
├── id: string
├── supplierId: string
├── branchId: string
├── items: [ { productId, quantity, cost, subtotal } ]
├── total: number
├── status: 'ordered' | 'received' | 'cancelled'
├── receivedAt: timestamp?
└── notes: string

📁 suppliers/ (proveedores)
├── id: string
├── name: string
├── contact: { email, phone, address }
├── products: string[] (referencias a products)
└── isActive: boolean

📁 cash_registers/ (caja)
├── id: string
├── branchId: string
├── openedBy: string (uid)
├── openedAt: timestamp
├── closedAt: timestamp?
├── initialAmount: number
├── finalAmount: number
├── salesTotal: number (calculado)
├── discrepancies: number
├── status: 'open' | 'closed' | 'discrepancy'
└── notes: string
```

### 4.3. Reglas de Seguridad de Firestore (Estrategia)

```js
// 📜 lib/core/security/firestore.rules (conceptual)

✅ Principios:
• Least privilege: solo acceso necesario para cada rol
• Validación en backend: nunca confiar en el cliente
• Auditoría: registrar cambios críticos en colecciones separadas

✅ Ejemplo de reglas por colección:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // 🔐 Users: solo el propio usuario o admin puede leer/escribir
    match /users/{userId} {
      allow read: if request.auth != null && 
                  (request.auth.uid == userId || 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'auditor']);
      allow write: if request.auth != null && 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // 📦 Products: lectura pública para roles activos, escritura solo admin
    match /products/{productId} {
      allow read: if request.auth != null && 
                  get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isActive == true;
      allow write: if request.auth != null && 
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin' &&
                   request.resource.data.keys().hasAll(['name', 'price', 'stock']); // validación de campos
    }
    
    // 💰 Sales: cajero puede crear, admin puede leer todas, cliente solo las suyas
    match /sales/{saleId} {
      allow create: if request.auth != null && 
                    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'cashier'];
      allow read: if request.auth != null && 
                  (get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin' ||
                   resource.data.cashierId == request.auth.uid);
      allow update, delete: if false; // ventas no se editan, solo se cancelan con nueva transacción
    }
    
    // 📊 Stock movements: solo escritura por sistema o admin, lectura para auditoría
    match /stock_movements/{movementId} {
      allow read: if request.auth != null && 
                  get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'auditor'];
      allow write: if false; // solo se escribe desde Cloud Functions o backend seguro
    }
  }
}
```

### 4.4. Optimización de Consultas Firestore

```
🚀 Estrategias de Rendimiento:

✅ Índices Compuestos (definir en firebase.json o consola):
• products: [branchId ASC, categoryId ASC, stock DESC] → filtro por sucursal + categoría + stock bajo
• sales: [branchId ASC, createdAt DESC] → historial de ventas por sucursal
• stock_movements: [productId ASC, timestamp DESC] → auditoría de producto

✅ Paginación con Query Cursors:
• Nunca cargar todos los productos: usar startAfterDocument()
• Límite por página: 20-50 documentos según plataforma
• Infinite scroll con Firestore snapshots

✅ Lecturas Denormalizadas para POS:
• En productos: incluir categoryName e imageUrl para evitar joins
• En ventas: guardar nombre del producto (no solo ID) para historial inmutable
• Trade-off: más escritura, menos lectura → ideal para operaciones frecuentes

✅ Cache Local Estratégico:
• Provider + Hive/SharedPreferences para datos de solo-lectura (categorías, config)
• Sincronización en segundo plano cuando hay conexión
• Invalidar caché al detectar actualizaciones en Firestore (snapshots)

✅ Evitar N+1 Queries:
• No hacer query de productos + query individual por categoría
• Usar dondeIn() para múltiples IDs (límite 10) o rediseñar estructura
• Considerar Cloud Functions para agregaciones complejas
```

---

## 🎨 5. Diseño UI/UX del Sistema

### 5.1. Principios de Diseño Visual

```
🎨 Sistema de Diseño "Papelería UI Kit"

✅ Paleta de Colores (Material 3 Adaptado):
• Primario: #2563EB (azul profesional) → botones principales, headers
• Secundario: #64748B (gris azulado) → textos secundarios, bordes
• Éxito: #10B981 → stock suficiente, ventas completadas
• Alerta: #F59E0B → stock bajo, advertencias
• Error: #EF4444 → errores, stock negativo, cancelaciones
• Fondo: #F8FAFC (claro) / #0F172A (oscuro) → adaptable por tema

✅ Tipografía Escalable:
• Títulos: Roboto Bold 24-32px (desktop) / 20-24px (móvil)
• Cuerpo: Roboto Regular 14-16px, line-height 1.5
• Monospace: para códigos SKU, precios → Roboto Mono
• Soporte para texto dinámico del sistema (accessibility)

✅ Sistema de Espaciado (8px baseline):
• XS: 4px, S: 8px, M: 16px, L: 24px, XL: 32px, XXL: 48px
• Consistente en padding, margin, gap de grids
• Definido en lib/shared/styles/spacing.dart

✅ Componentes Reutilizables:
• Botones: Primary, Secondary, Danger, Icon, Loading states
• Inputs: Labeled, Currency, Search, Date, with validation states
• Cards: ProductCard, StatCard, TransactionCard con hover/press effects
• Tables: ResponsiveDataTable con sorting, pagination, export
• Feedback: ErrorBanner, LoadingSkeleton, SuccessToast, EmptyState
```

### 5.2. Diseño por Rol y Dispositivo

#### 👨‍💼 Administrador (Desktop/Web First)
```
🖥️ Dashboard Principal:
• Grid de KPIs en tiempo real: Ventas hoy, Stock crítico, Caja actual
• Gráfico de ventas últimos 7 días (usar fl_chart)
• Tabla de últimas transacciones con acciones rápidas
• Alertas prioritarias: productos agotados, caja por cerrar

📊 Reportes:
• Filtros avanzados: fecha, sucursal, categoría, empleado
• Exportación a PDF/CSV con un clic
• Vista previa antes de exportar
• Programación de reportes automáticos (futuro con Cloud Functions)

⚙️ Configuración:
• Formularios con validación en tiempo real
• Confirmación antes de cambios críticos (eliminar producto)
• Historial de cambios (auditoría) para configuraciones sensibles
```

#### 💰 Cajero (Móvil/Tablet First - POS)
```
🛒 Interfaz de Punto de Venta:
• Búsqueda rápida: por nombre, SKU, código de barras (escáner)
• Grid de productos frecuentes con imágenes grandes
• Carrito lateral/resumen siempre visible
• Atajos de teclado (Web/Desktop): F1 buscar, F2 pagar, ESC cancelar

⌨️ Flujo de Venta Optimizado:
1. Agregar producto → búsqueda predictiva
2. Ajustar cantidad/descuento → toques mínimos
3. Seleccionar pago → botones grandes para métodos frecuentes
4. Confirmar → animación de éxito + opción de reimprimir
5. Volver automáticamente a nuevo venta

📱 Adaptación Móvil:
• Bottom sheet para carrito en pantallas pequeñas
• Gestos: swipe para eliminar item del carrito
• Modo offline básico: guardar venta local y sincronizar después
```

#### 🧑‍🔧 Empleado (Funcionalidades Limitadas)
```
✅ Acceso Permitido:
• Consultar inventario (solo lectura)
• Registrar entrada de mercancía (compras recibidas)
• Ver sus propias ventas/historial
• Actualizar perfil y preferencias

❌ Acceso Denegado:
• Eliminar productos o categorías
• Ver costos de compra o márgenes de ganancia
• Acceder a reportes financieros
• Gestionar usuarios o permisos

🎯 UX para Roles Restringidos:
• Botones/acciones no permitidas: ocultos (no solo deshabilitados)
• Mensajes claros si intenta acceder por URL directa: "No tienes permiso"
• Redirección automática a pantalla permitida más cercana
```

### 5.3. Experiencia de Usuario (UX) Clave

```
✨ Microinteracciones que Marcan la Diferencia:

✅ Feedback Inmediato:
• Al agregar al carrito: animación de "fly-to-cart" + vibración háptica
• Al guardar formulario: skeleton loading + toast de éxito
• Error de validación: shake animation + mensaje contextual

✅ Estados Vacíos Amigables:
• "No hay productos" → ilustración + botón "Agregar primero"
• "Sin ventas hoy" → mensaje motivador + acceso rápido a POS
• "Offline" → indicador claro + modo limitado funcional

✅ Accesibilidad (WCAG AA):
• Contraste mínimo 4.5:1 para texto normal
• Etiquetas semánticas en botones e inputs (Screen Reader)
• Navegación por teclado completa (Web/Desktop)
• Tamaño de toque mínimo 48x48px en móvil

✅ Rendimiento Percibido:
• Skeleton screens mientras cargan datos
• Optimistic UI: actualizar carrito localmente antes de confirmar en servidor
• Precarga de pantallas probables (ej: después de login → dashboard)
```

---

## 🔐 6. Sistema de Autenticación y Seguridad

### 6.1. Flujo de Autenticación Completo

```
🔄 Ciclo de Vida de Sesión:

1️⃣ Login Inicial:
   • Formulario con validación local (email formato, password fortaleza)
   • Firebase Auth.signInWithEmailAndPassword()
   • Manejo de errores específicos:
     - user-not-found → "Cuenta no registrada"
     - wrong-password → "Contraseña incorrecta" + opción recuperación
     - too-many-requests → "Intenta más tarde" + captcha si aplica

2️⃣ Verificación de Estado:
   • Al iniciar app: AuthProvider.checkAuthStatus()
   • Suscribirse a authStateChanges() de Firebase
   • Si hay sesión válida → redirigir a dashboard según rol
   • Si expiró → forzar re-login con mensaje amigable

3️⃣ Recuperación de Contraseña:
   • Flujo: Email → Link → Nueva contraseña → Confirmación
   • Validar fortaleza de nueva contraseña (regex: mayúscula, número, 8+ chars)
   • Invalidar sesiones anteriores tras cambio (Firebase reauthenticate)

4️⃣ Cierre de Sesión Seguro:
   • Firebase Auth.signOut()
   • Limpiar providers locales (AuthProvider, CartProvider)
   • Borrar caché sensible (SharedPreferences con prefijo 'auth_')
   • Redirigir a login con mensaje "Sesión cerrada correctamente"
```

### 6.2. Sistema de Roles y Permisos (RBAC)

```
👥 Matriz de Permisos por Rol:

| Acción / Módulo          | Admin | Cajero | Empleado | Auditor |
|--------------------------|-------|--------|----------|---------|
| 🔐 Gestionar usuarios    | ✅    | ❌     | ❌       | ❌      |
| 📦 CRUD Productos        | ✅    | ❌     | ✅(solo lectura) | ✅(lectura) |
| 📦 Ajustar stock         | ✅    | ✅(ventas) | ✅(recepción) | ✅(ver) |
| 💰 Realizar ventas       | ✅    | ✅     | ❌       | ❌      |
| 💰 Ver reportes financieros | ✅ | ❌     | ❌       | ✅      |
| 👥 Gestionar clientes    | ✅    | ✅(básico) | ❌    | ✅(lectura) |
| ⚙️ Configuración sistema | ✅    | ❌     | ❌       | ❌      |
| 📊 Exportar datos        | ✅    | ❌     | ❌       | ✅      |

✅ Implementación Técnica:

1. Definir roles en constants/role_constants.dart:
   ```dart
   enum AppRole { admin, cashier, employee, auditor }
   const rolePermissions = {
     AppRole.admin: {'*'}, // wildcard: acceso total
     AppRole.cashier: {'sales:create', 'products:read', 'cart:manage'},
     // ...
   };
   ```

2. Middleware de Rutas (RouteGuard):
   • Verificar currentUser.role antes de permitir navegación
   • Si no tiene permiso: redirigir a /unauthorized o pantalla fallback
   • Logging de intentos de acceso no autorizado (para auditoría)

3. Widgets Condicionales:
   • Extension method: context.can(Permission.salesCreate)
   • Usar en UI: if (context.can('products:delete')) ShowDeleteButton()
   • Nunca confiar solo en UI: validar también en backend/Firestore rules

4. Permisos Granulares (futuro):
   • Preparar estructura para permisos personalizados por sucursal
   • Ej: "cajero_sucursal_1" vs "cajero_sucursal_2"
   • Usar claims personalizadas de Firebase Auth para escalar
```

### 6.3. Estrategias de Seguridad Adicionales

```
🛡️ Capas de Defensa en Profundidad:

✅ Nivel Cliente:
• Validación de formularios en tiempo real (UX + seguridad básica)
• Ofuscación de código en release (flutter build --obfuscate)
• No almacenar credenciales en código o SharedPreferences

✅ Nivel Comunicación:
• Todas las peticiones vía Firebase SDK (TLS 1.2+ automático)
• Validar respuestas del servidor antes de actualizar UI
• Timeout en consultas para evitar bloqueos por red lenta

✅ Nivel Base de Datos:
• Reglas de Firestore estrictas (ver sección 4.3)
• Validación de esquemas con Firestore validators (paquete externo)
• Auditoría de cambios críticos en colecciones separadas

✅ Nivel Operativo:
• Rotación de claves de API si se usan servicios externos
• Monitoreo de accesos inusuales con Firebase Analytics + Alerts
• Backup automático de Firestore (exportación programada a GCS)

✅ Nivel Humano:
• Capacitación a usuarios sobre phishing y seguridad de contraseñas
• Política de contraseñas: mínimo 8 caracteres, complejidad, rotación opcional
• Registro de actividad: último login, intentos fallidos (para detección de ataques)
```

---

## 📦 7. Desarrollo de Módulos CRUD

### 7.1. Patrón Estándar para CRUDs

```
🔁 Flujo Genérico para Cualquier Entidad (ej: Productos):

1️⃣ Listado (Read Multiple)
   ├── Widget: ProductListScreen
   ├── Provider: ProductProvider.fetchAll(filters)
   ├── UI: DataTable responsive con:
   │   • Búsqueda en tiempo real (debounce 300ms)
   │   • Filtros desplegables (categoría, stock, estado)
   │   • Ordenamiento por columnas (nombre, precio, stock)
   │   • Paginación con Firestore cursors
   │   • Acciones por fila: editar, ver, eliminar (según permisos)
   └── Optimización: 
       • Cache local de última consulta
       • Skeleton loading mientras fetch
       • Empty state con CTA para crear primero

2️⃣ Detalle (Read Single)
   ├── Widget: ProductDetailScreen
   ├── Provider: ProductProvider.fetchById(productId)
   ├── UI: 
   │   • Galería de imágenes (carousel si >1)
   │   • Información estructurada en secciones
   │   • Historial de movimientos de stock (tabla)
   │   • Botones de acción contextual (editar, ajustar stock)
   └── Optimización:
       • Precarga al hacer hover/tap en listado (web/desktop)
       • Compartir instancia de producto entre pantallas para evitar refetch

3️⃣ Creación/Edición (Create/Update)
   ├── Widget: ProductFormScreen
   ├── Provider: ProductProvider.save(product)
   ├── UI:
   │   • Formulario con validación en tiempo real
   │   • Campos condicionales (ej: variantes solo si aplica)
   │   • Upload de imágenes con preview y compresión
   │   • Guardado borrador automático (SharedPreferences)
   │   • Confirmación antes de guardar cambios críticos
   └── Validaciones:
       • Local: formato SKU, precio positivo, campos requeridos
       • Remoto: unicidad de SKU (Firestore transaction), permisos de rol
       • Feedback: errores específicos por campo, no genéricos

4️⃣ Eliminación (Delete)
   ├── Widget: ConfirmDialog (reutilizable)
   ├── Provider: ProductProvider.delete(productId)
   ├── UI:
   │   • Modal con resumen de lo que se eliminará
   │   • Advertencia si hay dependencias (ej: producto en ventas)
   │   • Opción de "deshacer" por 5 segundos (optimistic UI)
   └── Seguridad:
       • Soft delete: marcar isActive=false en lugar de borrar
       • Auditoría: registrar quién, cuándo y por qué eliminó
       • Restauración posible desde panel de admin (futuro)
```

### 7.2. Módulos Especiales con Lógica Compleja

#### 💰 Módulo de Ventas (POS) - Flujo Crítico
```
🛒 Proceso de Venta Paso a Paso:

1. 🎯 Inicio de Sesión de Caja
   • Cajero abre caja con monto inicial
   • Sistema registra cash_registers.open() con timestamp y usuario
   • Validar que no haya otra caja abierta en esta sucursal

2. 🔍 Búsqueda y Agregado de Productos
   • Opciones: escanear código de barras, búsqueda por nombre/SKU, grid de favoritos
   • Al agregar: verificar stock disponible en tiempo real
   • Si stock insuficiente: sugerir cantidad máxima o producto alternativo

3. 🧮 Gestión del Carrito
   • Ajustar cantidades con +/- o input directo
   • Aplicar descuentos: % o monto fijo (con permiso de rol)
   • Calcular subtotal, impuestos, total en tiempo real
   • Permitir eliminar items con confirmación

4. 💳 Procesamiento de Pago
   • Selección de método: efectivo, tarjeta, transferencia, crédito
   • Para efectivo: cálculo de cambio automático
   • Para tarjeta: integración futura con pasarela (dejar hook)
   • Validar que total pagado ≥ total venta

5. ✅ Confirmación y Ticket
   • Resumen final antes de confirmar (prevent double-sell)
   • Transacción atómica en Firestore:
     - Crear documento en sales/
     - Actualizar stock en products/ (decrementar)
     - Registrar movimiento en stock_movements/
     - Actualizar total vendido en customer/ si aplica
   • Generar PDF de ticket (pdf package) y subir a Storage
   • Mostrar pantalla de éxito con opciones: reimprimir, nueva venta, cerrar

6. 🔄 Post-Venta
   • Actualizar KPIs en dashboard en tiempo real (Firestore snapshots)
   • Enviar notificación de stock bajo si aplica (Cloud Functions trigger)
   • Registrar evento en Analytics: sale_completed con metadata
```

#### 📦 Módulo de Inventario - Consistencia de Datos
```
⚠️ Operaciones Críticas y Cómo Protegerlas:

✅ Actualización de Stock (Transaccional):
• Usar Firestore runTransaction() para:
  1. Leer documento actual de producto
  2. Validar que stock + cambio >= 0
  3. Actualizar campo stock
  4. Crear documento en stock_movements/
  5. Commit o rollback automático si falla algún paso
• Beneficio: evita condiciones de carrera en ventas simultáneas

✅ Recepción de Compra (Múltiples Productos):
• Batch write para actualizar varios productos a la vez
• Validar que todos los productos existen y están activos
• Registrar purchase_id como referencia en cada stock_movement
• Notificar a admin si algún producto recibido difiere de orden

✅ Ajuste Manual de Inventario:
• Requerir motivo obligatorio (merma, daño, corrección)
• Solo roles admin/auditor pueden ejecutar
• Generar reporte automático de ajustes del día para revisión
• Alertar si ajuste supera umbral configurado (posible error o robo)

✅ Prevención de Errores Comunes:
• Bloquear edición de producto mientras hay venta en progreso (optimistic lock)
• Validar que precio de venta > costo (advertencia, no bloqueo)
• Confirmación doble para operaciones que afectan >10 productos
• Logging detallado de todas las operaciones de inventario
```

### 7.3. Búsquedas, Filtros y Relaciones

```
🔍 Estrategias de Búsqueda Eficiente:

✅ Búsqueda en Tiempo Real (Productos, Clientes):
• Implementar con debounce (300ms) para evitar queries por cada tecla
• Usar Firestore queries con startAt/endAt para búsqueda por prefijo
• Para búsqueda full-text: considerar extensión con Algolia (futuro) o mantener en cliente para <1k registros

✅ Filtros Combinados:
• Diseñar UI con filtros "stackables": categoría + stock + fecha
• Traducir a query de Firestore con múltiples where()
• Manejar caso sin resultados: sugerir quitar filtros o buscar en otra categoría

✅ Relaciones entre Entidades:
• Productos → Categoría: almacenar categoryName en producto (denormalizado) para evitar join
• Ventas → Productos: guardar snapshot de datos del producto al momento de la venta (inmutabilidad)
• Clientes → Ventas: usar subcolección o query con where('customerEmail', isEqualTo: ...)
• Evitar referencias cíclicas o cadenas largas de relaciones

✅ Paginación Inteligente:
• Para listas largas: usar query.limit(20).startAfter(lastDoc)
• Guardar último documento en Provider para navegación adelante/atrás
• Indicador visual de "cargando más..." al final del scroll
```

---

## ⚙️ 8. Lógica de Negocio e Inventario

### 8.1. Reglas de Negocio Críticas

```
📜 Motor de Reglas (Implementado en Domain Layer):

✅ Control de Stock:
• Regla: stock no puede ser negativo en operaciones normales
  → Excepción: ventas con "permitir sobreventa" (configurable por admin)
  → Acción: si stock < minStock, disparar alerta a admin (Firestore trigger)

✅ Cálculo de Precios:
• Precio de venta = costo * (1 + margen) + impuestos
  → Margen mínimo configurable por categoría
  → Validar al crear/editar producto: mostrar advertencia si margen < umbral

✅ Descuentos y Promociones:
• Descuento máximo por rol: cajero 10%, admin 50%
• Descuentos acumulables: solo si están marcados como "combinable"
• Validar que total después de descuento >= costo (evitar pérdidas)

✅ Gestión de Caja:
• No permitir cerrar caja con ventas pendientes de sincronizar
• Validar que (inicial + ventas - retiros) == final (tolerancia configurable)
• Registrar discrepancias automáticamente para revisión

✅ Consistencia Multi-Dispositivo:
• Usar timestamps del servidor (FieldValue.serverTimestamp()) para ordenar eventos
• En operaciones críticas (ventas): usar transactions para atomicidad
• Para lecturas: preferir snapshots en tiempo real sobre get() único
```

### 8.2. Manejo de Estados y Sincronización

```
🔄 Estrategia Offline-First (Básica):

✅ Datos de Solo-Lectura (Categorías, Config):
• Cache local con Hive o SharedPreferences
• Sincronizar en segundo plano al detectar conexión
• Invalidar caché cuando Firestore emita actualización (snapshot listener)

✅ Operaciones de Escritura (Ventas, Ajustes):
• Intentar enviar inmediatamente si hay conexión
• Si offline: guardar en cola local (Hive box 'pending_operations')
• Al reconectar: procesar cola en orden, con reintentos exponenciales
• Feedback al usuario: "Guardado localmente, se sincronizará al conectar"

✅ Resolución de Conflictos:
• Para stock: "última escritura gana" con timestamp de servidor
• Para datos de perfil: merge estratégico (no sobrescribir campos no modificados)
• Para operaciones críticas: requerir conexión o bloquear acción con mensaje claro

✅ Indicadores de Estado:
• Badge en UI: 🟢 Online, 🟡 Sincronizando, 🔴 Offline
• Tooltip explicativo al hover/tap
• Opción manual: "Sincronizar ahora" cuando se recupera conexión
```

### 8.3. Alertas y Notificaciones Proactivas

```
🔔 Sistema de Alertas Inteligentes:

✅ Tipos de Alertas:
• Stock bajo: producto < minStock → notificar a admin y cajeros
• Caja por cerrar: 30 min antes del horario configurado → recordar a cajero
• Venta inusual: monto > umbral o cantidad > límite → alertar a admin
• Error de sincronización: operación pendiente > 1 hora → notificar para revisión

✅ Implementación:
• Firestore Triggers (Cloud Functions) para alertas basadas en datos:
  ```js
  // Ejemplo conceptual: onProductUpdate trigger
  exports.checkLowStock = functions.firestore
    .document('products/{productId}')
    .onUpdate(async (change, context) => {
      const product = change.after.data();
      if (product.stock <= product.minStock) {
        await admin.firestore().collection('alerts').add({
          type: 'low_stock',
          productId: product.id,
          branchId: product.branchId,
          severity: 'warning',
          createdAt: admin.firestore.FieldValue.serverTimestamp()
        });
      }
    });
  ```
• En cliente: Provider que escucha colección 'alerts' filtrada por branchId y rol
• UI: Badge en app bar con contador, modal de alertas prioritarias al iniciar

✅ Gestión de Alertas:
• Marcar como leída/archivada por usuario
• Agrupar alertas similares para evitar spam
• Permitir silenciar temporalmente alertas no críticas (ej: durante inventario)
```

---

## 🚀 9. Optimización y Buenas Prácticas

### 9.1. Rendimiento en Flutter y Firestore

```
⚡ Optimizaciones Clave:

✅ Flutter UI:
• Usar const constructors en widgets siempre que sea posible
• Evitar rebuilds innecesarios con Selector<T, R> en lugar de Consumer<T>
• Implementar ListView.builder para listas largas (no Column + scroll)
• Precargar imágenes con cached_network_image + placeholder
• Usar RepaintBoundary para aislar zonas de alta frecuencia de redraw

✅ Consultas Firestore:
• Proyectar solo campos necesarios: .select(['name', 'price']) en lugar de todo el documento
• Evitar queries sin índice: revisar Firestore console → Indexes para sugerencias
• Usar count() aggregation (nuevo en Firestore) en lugar de leer todos los docs para contar
• Para búsquedas complejas: considerar colecciones de "índice invertido" mantenidas con Cloud Functions

✅ Gestión de Memoria:
• Dispose() de StreamSubscription en providers al destruir
• Limitar número de snapshot listeners activos (ej: solo escuchar alerts de sucursal activa)
• Usar compute() para procesamiento pesado de datos (ej: generar reporte PDF)

✅ Carga Inicial:
• Lazy load de módulos: no inicializar todos los providers al inicio
• Splash screen con progreso real (no fake timer)
• Precargar datos críticos en segundo plano tras login
```

### 9.2. Calidad de Código y Mantenibilidad

```
🧹 Estándares de Desarrollo:

✅ Linting y Análisis Estático:
• Usar very_good_analysis o flutter_lints estricto en pubspec.yaml
• Configurar analysis_options.yaml para:
  - Requerir documentación en funciones públicas
  - Prohibir print() en producción (usar logger)
  - Forzar manejo de errores con try/catch o Either
• Integrar con pre-commit hook: dart format + dart analyze

✅ Documentación:
• Dartdoc en clases y métodos públicos: /// Descripción con ejemplos
• README.md por módulo en features/ explicando propósito y flujo
• Diagramas de secuencia en /docs/ para flujos complejos (ventas, sincronización)

✅ Manejo de Errores:
• Nunca dejar errores sin manejar: siempre try/catch o .catchError()
• Clasificar errores: NetworkFailure, AuthFailure, ValidationFailure
• Mostrar mensajes amigables al usuario, logs detallados para desarrollador
• Integrar con Firebase Crashlytics para reportes automáticos en producción

✅ Testing Strategy:
• Unit tests: lógica de negocio en domain/ (usecases, entities) → 80% cobertura
• Widget tests: componentes UI críticos (forms, buttons, validation) 
• Integration tests: flujos completos (login → venta → cierre de caja)
• Ejecutar en CI: GitHub Actions en cada PR a develop

✅ Versionado y Cambios:
• Semantic Versioning para la app: MAJOR.MINOR.PATCH
• CHANGELOG.md actualizado en cada release con cambios y migraciones
• Feature flags para lanzamientos graduales (ej: nuevo módulo de reportes)
```

---

## 🧪 10. Pruebas y Control de Calidad

### 10.1. Estrategia de Testing por Capa

```
🧪 Pirámide de Testing:

✅ Unit Tests (Base - 70% de tests):
• Ubicación: test/unit/
• Enfoque: lógica pura sin dependencias externas
• Ejemplos:
  - Validadores: Validators.isValidSku('ABC123') → true
  - UseCases: UpdateStockUseCase.call() con mock repository
  - Entities: ProductEntity.calculateMargin() con distintos valores
• Herramientas: test package, mockito para mocks

✅ Widget Tests (Centro - 20% de tests):
• Ubicación: test/widget/
• Enfoque: interacción UI, estados visuales, navegación básica
• Ejemplos:
  - ProductForm: validar que muestra error si precio < 0
  - LoginScreen: redirige a dashboard tras login exitoso (con mock auth)
  - CartWidget: actualiza total al cambiar cantidad de item
• Herramientas: flutter_test, integration_test para interacciones táctiles

✅ Integration Tests (Cúspide - 10% de tests):
• Ubicación: test/integration/
• Enfoque: flujos completos con Firebase Emulator Suite
• Ejemplos:
  - Flujo POS: login → buscar producto → vender → verificar stock actualizado
  - Sincronización offline: crear venta sin red → reconectar → verificar en Firestore
  - Roles: intentar acceder a ruta de admin con rol cajero → verificar redirección
• Herramientas: integration_test, firebase_emulator, patrol para automatización

✅ Pruebas Manuales Esenciales:
• Matriz de dispositivos: Android (móvil/tablet), Web (Chrome/Firefox), Windows
• Escenarios de red: 3G lento, offline, reconexión intermitente
• Casos borde: stock = 0, descuento = 100%, usuario inactivo, sesión expirada
```

### 10.2. Herramientas de Depuración y Monitoreo

```
🔧 Stack de Calidad:

✅ Desarrollo:
• Flutter DevTools: performance, memory, network inspector
• Firebase Emulator Suite: probar reglas de seguridad sin costo ni riesgo
• Logger con niveles: solo mostrar debug en dev, error/warning en prod
• Extensiones VS Code: Flutter Intl (para i18n), Firebase Data Explorer

✅ Pre-Producción:
• Firebase Test Lab: ejecutar tests en dispositivos reales en la nube
• Lighthouse (para web): auditoría de performance, accessibility, SEO
• flutter build apk --analyze-size: identificar bundles grandes

✅ Producción:
• Firebase Crashlytics: agrupación de errores, trazas completas, alertas
• Firebase Performance Monitoring: trazas personalizadas para operaciones críticas
• Firebase Analytics: embudos de conversión (ej: login → primera venta)
• Sentry (opcional): si se requiere más control sobre reporting de errores

✅ Monitoreo Proactivo:
• Dashboard en Data Studio con métricas clave: ventas/hora, errores/día, stock crítico
• Alertas en Slack/Email cuando: error rate > 1%, ventas caen 50% vs promedio
• Revisión semanal de logs de auditoría para detectar patrones inusuales
```

---

## 🚢 11. Despliegue y Mantenimiento

### 11.1. Preparación para Producción

```
🔐 Checklist Pre-Lanzamiento:

✅ Seguridad:
• Verificar que firebase.json tiene reglas en modo producción (no allow all)
• Eliminar datos de prueba de Firestore y Storage
• Rotar claves de API si se usaron servicios externos en desarrollo
• Habilitar App Check para Flutter (Firebase) para prevenir abuso

✅ Rendimiento:
• Ejecutar flutter build apk --release --analyze-size y optimizar si >25MB
• Para web: flutter build web --release --web-renderer canvaskit + minify
• Configurar caching headers en Firebase Hosting para assets estáticos
• Habilitar compresión GZIP/Brotli en servidor (automático en Firebase Hosting)

✅ Experiencia de Usuario:
• Configurar nombres de app, íconos y splash screens por plataforma
• Definir deep links y app links para compartir productos/ventas
• Preparar textos de onboarding y ayuda contextual en la app
• Validar accesibilidad con screen readers (TalkBack, VoiceOver)

✅ Legal y Operativo:
• Incluir política de privacidad y términos de uso (enlaces en ajustes)
• Configurar respaldo automático de Firestore a Google Cloud Storage
• Documentar procedimiento de recuperación ante desastres
• Capacitar a usuarios finales con guía rápida y video tutorial
```

### 11.2. Estrategia de Despliegue Multiplataforma

```
📦 Builds y Distribución:

✅ Android:
• Generar keystore firmado y guardar en lugar seguro (no en repo)
• flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
• Subir a Google Play Console: rollout gradual (5% → 20% → 100%)
• Monitorear crash rate y ANR en Play Console post-lanzamiento

✅ Web:
• flutter build web --release --base-href "/papeleria/"
• Deploy a Firebase Hosting: firebase deploy --only hosting
• Configurar custom domain con SSL automático (Firebase)
• Habilitar PWA: manifest.json, service worker para offline básico

✅ Windows:
• flutter build windows --release
• Empaquetar con Inno Setup o MSIX para instalación fácil
• Distribuir vía: tienda Microsoft, descarga directa, o despliegue interno
• Considerar auto-update con paquete: flutter_auto_updater (futuro)

✅ Actualizaciones en Vivo:
• Para Web: cache busting con versionado de assets (automático en Flutter)
• Para Móvil/Desktop: usar CodePush (App Center) o notificar nueva versión
• Estrategia de migración: si cambia estructura de Firestore, usar Cloud Functions para migración progresiva
```

### 11.3. Mantenimiento y Evolución del Sistema

```
🔄 Ciclo de Vida Post-Lanzamiento:

✅ Monitoreo Continuo:
• Revisar diariamente: Crashlytics, Performance, Analytics
• Alertas automáticas: error rate > umbral, ventas = 0 en horario laboral
• Revisión semanal: feedback de usuarios, tickets de soporte, métricas de negocio

✅ Actualizaciones Planificadas:
• Parches de seguridad: priorizar y desplegar en <24h
• Mejoras de UX: agrupar en releases mensuales con notas de versión claras
• Nuevas funcionalidades: desarrollar en ramas feature/, probar en staging, lanzar con feature flag

✅ Escalamiento:
• Multi-sucursal: activar módulo de branches cuando haya >1 tienda
• Multi-idioma: preparar i18n con flutter_localizations desde el inicio
• Integraciones: dejar hooks para futuros: facturación electrónica, pasarelas de pago, ERP

✅ Documentación Viva:
• Mantener /docs/ actualizado con decisiones arquitectónicas (ADR)
• Registrar lecciones aprendidas en post-mortems de incidentes
• Compartir conocimiento: wiki interna, sesiones de pairing, código como documentación

✅ Roadmap Sugerido (Próximos 6 meses):
| Mes | Hito | Impacto |
|-----|------|---------|
| 1 | Lanzamiento MVP (1 sucursal) | Validar flujo core con usuarios reales |
| 2 | Módulo de reportes básicos + exportación | Mejorar toma de decisiones administrativas |
| 3 | Soporte offline robusto + sincronización | Habilitar uso en zonas con conectividad intermitente |
| 4 | Integración con impresoras térmicas (Web/Desktop) | Profesionalizar experiencia de punto de venta |
| 5 | Módulo multi-sucursal + transferencia entre tiendas | Preparar escalamiento a cadena de papelerías |
| 6 | App móvil para clientes (consulta de pedidos, puntos) | Expandir valor a CRM y fidelización |
```

---

## 📎 Anexos

### A. Dependencias Recomendadas (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.18
  firebase_performance: ^0.9.3+17
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^13.2.0
  
  # UI & UX
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.9
  fl_chart: ^0.66.0          # Gráficos para dashboard
  skeletonizer: ^1.4.1       # Loading states
  fluttertoast: ^8.2.4       # Feedback no intrusivo
  
  # Forms & Validation
  formz: ^0.7.0              # Validaciones tipadas
  
  # Utils
  intl: ^0.19.0              # Formato de moneda/fechas
  uuid: ^4.3.3               # IDs únicos
  collection: ^1.18.0        # Utilidades para listas/maps
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3               # Para caché offline
  hive_flutter: ^1.1.0
  
  # PDF & Printing
  pdf: ^3.10.7
  printing: ^5.12.0          # Integración con impresoras
  
  # Dev & Quality
  flutter_lints: ^3.0.1
  logger: ^2.0.2+1           # Logging estructurado
  envied: ^0.5.3             # Variables de entorno seguras

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.8
  envied_generator: ^0.5.3
```

### B. Estructura de Firebase (Resumen Visual)
```
🔥 Firebase Project: papeleria-prod
│
├── 🔐 Authentication
│   ├── Providers: Email/Password
│   ├── Settings: Email verification enabled, Password policy: strong
│   └── Users: almacenados con custom claims para roles (futuro)
│
├── 🗄️ Firestore Database
│   ├── Collections: users, branches, products, sales, customers, etc.
│   ├── Indexes: definidos para queries frecuentes (ver sección 4.4)
│   └── Rules: estrictas por colección y rol (ver sección 4.3)
│
├── 📦 Storage
│   ├── Buckets: papeleria-prod.appspot.com
│   ├── Estructura: /products/{productId}/{image}.jpg
│   └── Rules: solo admin puede subir, todos autenticados pueden leer productos activos
│
├── ⚙️ Cloud Functions (Opcional pero recomendado)
│   ├── Triggers: 
│   │   • onSaleCreate → actualizar customer.totalSpent
│   │   • onProductUpdate → verificar stock bajo y crear alerta
│   │   • scheduled: daily backup, cleanup de sesiones expiradas
│   └── Deploy: con firebase-tools, testing local con emulators
│
└── 📊 Monitoring
    ├── Crashlytics: habilitado para builds de release
    ├── Performance: traces personalizados para POS flow
    └── Analytics: eventos personalizados para embudos de negocio
```

### C. Checklist de Aprobación para Pasar a Código
```
✅ Antes de escribir la primera línea de código de negocio:

[ ] Plan de implementación aprobado por stakeholder técnico
[ ] Wireframes y flujo de navegación validados en Figma
[ ] Estructura de carpetas creada y vacía (solo main.dart base)
[ ] Firebase project configurado con apps registradas para Android/Web/Windows
[ ] Archivos de configuración (google-services.json, etc.) en sus rutas correctas
[ ] pubspec.yaml con dependencias base y versiones compatibles
[ ] .gitignore configurado para Flutter + Firebase + IDE
[ ] Rama develop creada en Git, con protección de main
[ ] Documento de decisiones arquitectónicas (ADR) inicial en /docs/
[ ] Acuerdo de definición de "hecho" (DoD) para cada módulo

🎯 Próximo paso: Iniciar desarrollo del módulo de autenticación (feature/auth/)
   → Siguiendo este plan, el código será una implementación, no una exploración.
```

---

> 🏁 **Conclusión del Plan**  
> Este documento sirve como contrato técnico para el desarrollo del sistema "Papelería". Cualquier desviación significativa debe ser documentada como una nueva decisión arquitectónica (ADR) y aprobada por el equipo técnico.  
>   
> **Próximo entregable**: Una vez aprobado este plan, se generará:  
> 1. Estructura inicial de carpetas y archivos base  
> 2. Configuración de `pubspec.yaml` y `analysis_options.yaml`  
> 3. Esqueleto de navegación con `go_router` y `MultiProvider`  
> 4. Implementación del módulo de autenticación como prueba de concepto  
>   
> *¿Listo para comenzar la fase de codificación? Indica qué módulo deseas desarrollar primero.* 🚀
