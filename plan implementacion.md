# 📋 Plan de Implementación: Aplicación "Papelería" (Flutter + Firebase)

Este documento describe el procedimiento completo, paso a paso, para desarrollar la aplicación multiplataforma **"Papelería"**. No incluye fragmentos de código; se enfoca exclusivamente en arquitectura, herramientas, diseño, dependencias y flujo de desarrollo.

---

## 🛠 1. Entorno y Herramientas Requeridas

| Categoría | Herramienta / Recurso | Propósito |
|-----------|----------------------|-----------|
| **IDE Principal** | Visual Studio Code | Edición, depuración, extensiones oficiales Flutter/Dart |
| **Alternativa** | Android Studio / IntelliJ | Gestión de emuladores, herramientas nativas avanzadas |
| *Nota* | `Antigravity` no es un IDE estándar para Flutter. Se recomienda VS Code con las extensiones `Flutter`, `Dart`, `Error Lens` y `Pubspec Assist`. |
| **SDK** | Flutter SDK (≥3.19) + Dart (≥3.3) | Framework base y lenguaje |
| **Control de Versiones** | Git + GitHub/GitLab | Historial, ramas, CI/CD básico |
| **Diseño UI/UX** | Figma / Penpot / Adobe XD | Prototipado, sistema de diseño, handoff |
| **Emuladores** | Android Emulator + iOS Simulator + Chrome | Pruebas multiplataforma |
| **Backend** | Firebase Console + Firebase CLI | Autenticación, Firestore, Hosting, Cloud Functions (opcional) |
| **Emuladores Locales** | Firebase Emulator Suite | Desarrollo offline, pruebas seguras sin consumo de cuota |

---

## 🎨 2. Diseño UI/UX

### 2.1. Principios de Diseño
- **Sistema Visual:** Material 3 (adaptativo), paleta centrada en tonos profesionales (azules/grises) con acentos cálidos para CTAs.
- **Responsive Layout:** `LayoutBuilder` + `MediaQuery` + `Grid` adaptativo para móvil, tablet, web y escritorio.
- **Accesibilidad:** Contraste WCAG AA, soporte para texto dinámico, navegación por teclado/táctil, semántica de botones y formularios.
- **Microinteracciones:** `Hero` animations, transiciones suaves entre pantallas, estados de carga (`shimmer`/`CircularProgressIndicator`), feedback háptico.

### 2.2. Flujo de Pantallas Principales
1. **Splash / Onboarding** → 2. **Login / Registro** → 3. **Home / Catálogo** → 4. **Detalle de Producto** → 5. **Carrito** → 6. **Perfil / Historial** → 7. **Ajustes / Cerrar sesión**

### 2.3. Entregables de Diseño
- Wireframes de baja fidelidad
- Prototipo interactivo en Figma
- Kit de UI: componentes reutilizables (botones, cards, inputs, dialogs, bottom nav, app bar)
- Guía de tipografía, espaciado y colores

---

## 🏗 3. Arquitectura y Gestión de Estado

- **Patrón:** Capas separadas (`presentation`, `domain`, `data`) con inyección manual o `get_it`/`riverpod` si se escala (para este proyecto se mantiene `provider` por simplicidad y control).
- **State Management:** `provider` + `ChangeNotifier` para:
  - Estado de autenticación (`AuthNotifier`)
  - Catálogo y filtros (`ProductNotifier`)
  - Carrito (`CartNotifier`)
  - UI global (tema, idioma, modo offline)
- **Navegación:** `go_router` para rutas declarativas, deep linking y protección de rutas autenticadas.
- **Separación de Responsabilidades:** 
  - `services/` → Comunicación con Firebase
  - `models/` → Clases de datos serializables
  - `providers/` → Notificadores de estado
  - `screens/` → Vistas UI
  - `widgets/` → Componentes reutilizables

---

## 🔐 4. Configuración de Firebase y Autenticación

1. Crear proyecto en Firebase Console
2. Registrar aplicaciones: Android (SHA-1), iOS, Web (Firebase config), Windows/macOS/Linux si aplica
3. Habilitar **Authentication → Email/Password**
4. Configurar políticas de seguridad:
   - Verificación de email (opcional pero recomendada)
   - Restablecimiento de contraseña
   - Tiempo de expiración de sesión
5. Implementar flujo de autenticación:
   - Validación local de formularios
   - Manejo de estados: `idle`, `loading`, `success`, `error`
   - Persistencia de sesión gestionada por Firebase Auth SDK
   - Redirección automática según estado de autenticación

---

## 🗃 5. Estructura de Base de Datos (Firestore)

| Colección | Campos Principales | Propósito |
|-----------|-------------------|-----------|
| `users` | `uid`, `email`, `displayName`, `createdAt`, `role`, `preferences` | Perfiles y configuración |
| `categories` | `id`, `name`, `iconUrl`, `description`, `order` | Clasificación de productos |
| `products` | `id`, `name`, `description`, `price`, `stock`, `categoryId`, `imageUrl`, `createdAt`, `isActive` | Catálogo principal |
| `cart_items` | `userId`, `productId`, `quantity`, `addedAt` | Carrito por usuario |
| `orders` | `orderId`, `userId`, `items[]`, `total`, `status`, `createdAt`, `shippingAddress` | Historial de compras |

**Índices y Reglas de Seguridad:**
- Índices compuestos para consultas por categoría + precio + stock
- Reglas: solo el propietario accede a `cart_items` y `orders`, lectura pública limitada a productos activos
- Validación de tipos y rangos en escritura

---

## 📦 6. Dependencias (`pubspec.yaml`)

| Dependencia | Función |
|-------------|---------|
| `flutter` | Core del framework |
| `firebase_core` | Inicialización de Firebase |
| `firebase_auth` | Autenticación email/password |
| `cloud_firestore` | Base de datos en tiempo real |
| `provider` | Gestión de estado |
| `go_router` | Enrutamiento declarativo |
| `cached_network_image` | Carga y caché de imágenes de productos |
| `intl` | Formateo de moneda, fechas y localización |
| `flutter_localizations` | Soporte multiidioma (es, en) |
| `shared_preferences` | Configuración local (tema, idioma, última sesión) |
| `flutter_secure_storage` (opcional) | Almacenamiento seguro de tokens sensibles |
| `skeletonizer` / `shimmer` | Estados de carga visuales |
| `flutter_lints` / `very_good_analysis` | Linting y calidad de código |

*Nota:* Las versiones se fijarán según compatibilidad con el canal `stable` de Flutter al momento del desarrollo.

---

## 📝 7. Procedimiento Paso a Paso

### 🔹 Fase 1: Preparación del Entorno
1. Instalar Flutter SDK y Dart. Verificar con `flutter doctor`.
2. Configurar VS Code con extensiones oficiales y formateadores.
3. Inicializar repositorio Git, crear ramas: `main`, `dev`, `feature/*`.
4. Crear proyecto Flutter multiplataforma: `flutter create papeleria_app`.
5. Configurar `pubspec.yaml` con las dependencias listadas.

### 🔹 Fase 2: Diseño y Prototipado
1. Definir wireframes y flujo de navegación en Figma.
2. Validar usabilidad con 3-5 usuarios objetivo.
3. Exportar assets, paleta y guía de componentes.
4. Documentar estados de UI (vacío, carga, error, éxito).

### 🔹 Fase 3: Configuración de Firebase
1. Crear proyecto y registrar apps multiplataforma.
2. Descargar archivos de configuración (`google-services.json`, `GoogleService-Info.plist`, web config).
3. Inicializar Firebase en `main.dart`.
4. Habilitar Auth y Firestore en consola.
5. Configurar reglas de seguridad básicas y probar en emulador local.

### 🔹 Fase 4: Arquitectura y Estado
1. Estructurar carpetas por capas (`presentation`, `data`, `providers`, `models`, `routes`).
2. Crear `AuthNotifier`, `ProductNotifier`, `CartNotifier`.
3. Configurar `go_router` con rutas protegidas y parámetros.
4. Implementar `MultiProvider` en la raíz de la app.

### 🔹 Fase 5: Autenticación y Perfil
1. Diseñar pantallas de login, registro y recuperación.
2. Conectar formularios con `firebase_auth`.
3. Manejar errores de red, credenciales inválidas y contraseñas débiles.
4. Persistir estado de sesión y redirigir según autenticación.
5. Implementar pantalla de perfil y cierre de sesión.

### 🔹 Fase 6: Catálogo y Firestore
1. Diseñar vista de lista/grid de productos con filtros y búsqueda.
2. Implementar `cloud_firestore` para lectura paginada y en tiempo real.
3. Sincronizar estado con `ProductNotifier`.
4. Crear vista de detalle con galería, descripción y stock.
5. Implementar lógica de carrito (`CartNotifier`) con agregado, edición y eliminación.

### 🔹 Fase 7: UI/UX Final y Optimización
1. Aplicar tema Material 3, animaciones y transiciones.
2. Implementar estados de carga, errores y vistas vacías.
3. Optimizar imágenes, caché y consultas Firestore.
4. Validar responsividad en móvil, tablet, web y escritorio.
5. Añadir accesibilidad y localización.

### 🔹 Fase 8: Pruebas y Calidad
1. Pruebas unitarias: validadores, modelos, lógica de estado.
2. Pruebas de widget: navegación, renderizado condicional, interacción UI.
3. Pruebas de integración: flujo completo login → catálogo → carrito → perfil.
4. Ejecutar Firebase Emulator Suite para validar reglas y consultas.
5. Revisar métricas: rendimiento, consumo de red, memoria, startup time.

---

## 🚀 8. Despliegue y Mantenimiento

1. **Compilación Multiplataforma:**
   - Android: `flutter build appbundle`
   - iOS: `flutter build ios --release` (requiere macOS/Xcode)
   - Web: `flutter build web --release`
   - Desktop: `flutter build windows/macos/linux --release`
2. **Firebase Hosting** (para web) o distribución nativa (Play Store, App Store, instaladores).
3. **Monitoreo:** Firebase Crashlytics, Performance Monitoring, Analytics.
4. **CI/CD (Opcional):** GitHub Actions para lint, tests, build y despliegue automático.
5. **Mantenimiento:** Actualizaciones de SDK, revisión de reglas Firestore, backups, rotación de claves si se usan APIs externas.

---

✅ **Próximo Paso:** Una vez aprobado este plan, se puede proceder a la generación de la estructura de carpetas, configuración inicial de `pubspec.yaml`, y el esqueleto de navegación/autenticación con `provider` y `go_router`. ¿Deseas que avancemos a la fase de generación de código o prefieres ajustar algún punto del plan primero?
