# 📱 App de Mapas con Rutas, Notificaciones y Reportes

> Demo de funcionalidades: abrir la app, cambiar entre múltiples rutas, recibir notificaciones en tiempo real, cambiar el tipo de mapa y abrir un reporte dentro de un WebView.

## Requisitos

* **Xcode 15+**, **iOS 18+**
* **Swift 5.9+**.
* SDK de mapas: **Google Maps iOS SDK** 

---

## Uso

### Recibir notificaciones

* Permite notificaciones en el primer arranque.

### Cambiar el tipo de mapa

* Toca el control **Tipo de mapa** y elige **Estándar / Satélite / Terreno / Híbrido**.

---

## Arquitectura (breve)

* **Capas**: `View (SwiftUI)` → `ViewModel (ObservableObject)` → `Service (Networking/WebSocket)`.
* **Estado**: `@StateObject` para ViewModels de larga vida, `@ObservedObject` en sub-vistas. Comunicación con `Combine`/`async`.
* **Tiempo real**: `URLSessionWebSocketTask` o librería equivalente; desacople por protocolo (p. ej. `EntitiesProtocol`).
* **Navegación**: `NavigationStack` + rutas tipadas; soporte para Deep Links.
* **Configuración**: `.xcconfig`/`Info.plist`/Variables de entorno para URLs y claves.


## Vista rápida

### Abrir app
<p align="center">
  <img src="./docs/abrir-app.gif" width="480" alt="Abrir app">
</p>

### Cambiar entre múltiples rutas (mapa / navegación)

<p align="center">
  <img src="./docs/cambiar-rutas.gif" width="480" alt="Abrir app">
</p>

### Mostrar datos actualizados


<p align="center">
  <img src="./docs/data.png" width="480" alt="Abrir app">
</p>


### Recibir notificaciones

<p align="center">
  <img src="./docs/ask.png" width="480" alt="Abrir app">
</p>

<p align="center">
  <img src="./docs/notificaciones.png" width="480" alt="Abrir app">
</p>


### Cambiar tipo de mapa

<p align="center">
  <img src="./docs/tipo-mapa.png" width="480" alt="Abrir app">
</p>


### Mostrar datos historicos

<p align="center">
  <img src="./docs/webview.gif" width="480" alt="Abrir app">
</p>

### Alterna tema entre dia/noche

<p align="center">
  <img src="./docs/theme.gif" width="480" alt="Abrir app">
</p>

### Navegacion entre las funcionalidades del APP

<p align="center">
  <img src="./docs/navigation.gif" width="480" alt="Abrir app">
</p>


---

## Licencia

Este proyecto se distribuye bajo la licencia MIT (o la que corresponda). Consulta `LICENSE` para más información.
