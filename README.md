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

```md
![Abrir app](docs/abrir-app.gif)
```

### Cambiar entre múltiples rutas (mapa / navegación)

```md
![Cambiar rutas](docs/cambiar-rutas.gif)
```

### Recibir notificaciones

```md
![Notificaciones](docs/notificaciones.gif)
```

### Cambiar tipo de mapa

```md
![Tipo de mapa](docs/tipo-mapa.gif)
```

### Abrir reporte en WebView

```html
<video src="docs/reporte-webview.mp4" controls loop muted playsinline style="max-width:100%"></video>
```

> **Sugerencia**: usa MP4 (H.264) en lugar de GIF para mantener tamaños bajos. Si prefieres GIF, mantén ≤10s, 600–900px de ancho y 10–15 fps.

---

## Funcionalidades

* **Abrir app** vía deep link o desde el ícono (con soporte de parámetros iniciales).
* **Cambiar entre múltiples rutas**:

  * **Rutas del mapa** (ej. distintas polilíneas/trayectos) y
  * **Rutas de navegación** (pantallas/flows dentro de la app).
* **Notificaciones** en tiempo real (push y/o WebSocket) con filtro por contexto.
* **Cambiar tipo de mapa** (estándar, satélite, terreno, híbrido).
* **Reporte en WebView** con controles de navegación, compartir y recarga.

---

## Medios (GIF/MP4) para el README

Coloca tus archivos en `docs/` y usa los snippets de arriba. Para convertir `.mov` del simulador:

**MOV → MP4 (recomendado)**

```bash
ffmpeg -i input.mov -vf "scale=1280:-2" -c:v libx264 -crf 23 -preset medium -pix_fmt yuv420p -movflags +faststart -an docs/reporte-webview.mp4
```

**MOV → GIF (ligero y corto)**

```bash
ffmpeg -i input.mov -filter_complex "[0:v]fps=12,scale=800:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer:bayer_scale=3" -loop 0 docs/abrir-app.gif
```

> Requiere `ffmpeg`. Instálalo con Homebrew: `brew install ffmpeg`.

---

## Requisitos

* **Xcode 15+**, **iOS 16+** (o ajustar el `Minimum Deployment` según tu proyecto).
* **Swift 5.9+**.
* SDK de mapas: **MapKit** o **Google Maps iOS SDK** (opcional según tu implementación).

---

## Instalación

1. Clona el repo:

   ```bash
   git clone https://github.com/tu-org/tu-app.git
   cd tu-app
   ```
2. Abre el proyecto en Xcode:

   ```bash
   xed .
   ```
3. (Opcional) Si usas **Google Maps SDK**, agrega tu clave en `Info.plist` con la key `GMSApiKey` o iníciala en `AppDelegate`.
4. Corre la app en un simulador o dispositivo.

---

## Configuración

### Deep Links (Abrir app)

* Registra un **URL Scheme** (ej. `myapp://`) en **TARGETS → Info → URL Types**.
* Ejemplos de enlaces:

  * `myapp://home`
  * `myapp://rutas?selected=A`
  * `myapp://reporte?id=123`

### Notificaciones

* Activa **Push Notifications** y **Background Modes** (Remote notifications) en `Signing & Capabilities`.
* Solicita permiso en el primer arranque y maneja el token de APNs.
* (Opcional) **WebSocket** para tiempo real:

  * URL configurable (ej. `wss://api.tuapp.com/rt`)
  * Filtrado por *servicePath* o canal (ej. `/#`, `/ruta/A`, etc.).

### Mapa y tipos de mapa

* Si usas **MapKit**: tipos `standard`, `satellite`, `hybrid`.
* Si usas **Google Maps**: `normal`, `terrain`, `satellite`, `hybrid`.
* Expón un control (SegmentedControl/Picker) para cambiar el tipo en tiempo real.

### Reporte en WebView

* Implementa con **WKWebView** (control completo) o **SFSafariViewController** (más simple, UX consistente).
* URL configurable (ej. `https://reportes.tuapp.com/diario?id=123`).

---

## Uso

### Abrir la app

* Toca el ícono en el Springboard o usa un **deep link** (desde Safari/Notas/Terminal):

  ```bash
  open "myapp://home"
  ```

### Cambiar entre múltiples rutas

* **Rutas del mapa**: usa el selector en la parte superior para alternar entre `Ruta A`, `Ruta B`, `Ruta C`. Cada cambio replotea polilíneas y puntos de interés.
* **Rutas de navegación** (pantallas): la app utiliza un Router/Navigator (ej. `NavigationStack` en SwiftUI) para moverte entre Home → Detalle → Reporte.

### Recibir notificaciones

* Permite notificaciones en el primer arranque.
* Las notificaciones entrantes (push/WebSocket) se muestran como banners y se registran en la bandeja de notificaciones dentro de la app.
* Si el mensaje pertenece a una **ruta** o **servicePath** específico, la UI se filtra automáticamente.

### Cambiar el tipo de mapa

* Toca el control **Tipo de mapa** y elige **Estándar / Satélite / Terreno / Híbrido**.
* La preferencia se guarda localmente para futuras sesiones.

### Abrir un reporte en WebView

* Desde la sección **Reportes**, selecciona el reporte y se abrirá dentro de la app con navegación, recarga y compartir.

---

## Arquitectura (breve)

* **Capas**: `View (SwiftUI)` → `ViewModel (ObservableObject)` → `Service (Networking/WebSocket)`.
* **Estado**: `@StateObject` para ViewModels de larga vida, `@ObservedObject` en sub-vistas. Comunicación con `Combine`/`async`.
* **Tiempo real**: `URLSessionWebSocketTask` o librería equivalente; desacople por protocolo (p. ej. `EntitiesProtocol`).
* **Navegación**: `NavigationStack` + rutas tipadas; soporte para Deep Links.
* **Configuración**: `.xcconfig`/`Info.plist`/Variables de entorno para URLs y claves.

---

## Contribuir

1. Haz un fork y crea una rama: `feat/mi-funcionalidad`.
2. Asegúrate de incluir **capturas/GIF/MP4** de la nueva funcionalidad en `docs/`.
3. Abre un PR con descripción clara y checklist de pruebas.

---

## Licencia

Este proyecto se distribuye bajo la licencia MIT (o la que corresponda). Consulta `LICENSE` para más información.
