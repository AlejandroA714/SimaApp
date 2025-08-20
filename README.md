# 📱 App de Mapas con Rutas, Notificaciones y Reportes

> Demo de funcionalidades: abrir la app, cambiar entre múltiples rutas, recibir notificaciones en tiempo real, cambiar el tipo de mapa y abrir un reporte dentro de un WebView.

---

## Índice

* [Vista rápida](#vista-rápida)
* [Funcionalidades](#funcionalidades)
* [Medios (GIF/MP4) para el README](#medios-gifmp4-para-el-readme)
* [Requisitos](#requisitos)
* [Instalación](#instalación)
* [Configuración](#configuración)

  * [Deep Links (Abrir app)](#deep-links-abrir-app)
  * [Notificaciones](#notificaciones)
  * [Mapa y tipos de mapa](#mapa-y-tipos-de-mapa)
  * [Reporte en WebView](#reporte-en-webview)
* [Uso](#uso)

  * [Abrir la app](#abrir-la-app)
  * [Cambiar entre múltiples rutas](#cambiar-entre-múltiples-rutas)
  * [Recibir notificaciones](#recibir-notificaciones)
  * [Cambiar el tipo de mapa](#cambiar-el-tipo-de-mapa)
  * [Abrir un reporte en WebView](#abrir-un-reporte-en-webview)
* [Arquitectura (breve)](#arquitectura-breve)
* [Contribuir](#contribuir)
* [Licencia](#licencia)

---

## Vista rápida

### Abrir app

![Abrir app](docs/abrir-app.gif)


### Cambiar entre múltiples rutas (mapa / navegación)


![Cambiar rutas](docs/cambiar-rutas.gif)

### Mostrar datos actualizados


![Data](docs/data.png)


### Recibir notificaciones


![Notificaciones](docs/notificaciones.gif)


### Cambiar tipo de mapa


![Tipo de mapa](docs/tipo-mapa.gif)


### Mostrar datos historicos

```html
<video src="docs/reporte-webview.mp4" controls loop muted playsinline style="max-width:100%"></video>
```

> **Sugerencia**: usa MP4 (H.264) en lugar de GIF para mantener tamaños bajos. Si prefieres GIF, mantén ≤10s, 600–900px de ancho y 10–15 fps.

---


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


## Licencia

Este proyecto se distribuye bajo la licencia MIT (o la que corresponda). Consulta `LICENSE` para más información.
