# 📱 Flutter Parallelo App

Aplicación móvil desarrollada con Flutter y backend en Node.js con base de datos MySQL. Permite la gestión de usuarios, productos, imágenes y el consumo de una API externa con monitoreo en tiempo real del estado de servicios del dispositivo (Wi-Fi, GPS, Bluetooth, Internet).

---

## 🚀 Tecnologías utilizadas

- **Frontend:** Flutter (Dart)
- **Backend:** Node.js (Express.js)
- **Base de datos:** MySQL
- **APIs externas:** [API Softecard](https://softecard.com)
- **Plugins clave:** `connectivity_plus`, `geolocator`, `flutter_reactive_ble`, `image_picker`, `provider`, `wifi_iot`

---

## 🛠️ Requisitos previos

### Sistema

- Flutter SDK (v3.8.1 o superior)
- Node.js (v18 o superior recomendado)
- MySQL Server (localhost)
- Android Studio o Visual Studio Code
- Emulador o dispositivo físico

### Base de Datos

Crear base de datos `flutter1` y tabla `imagenes`:

```sql
CREATE DATABASE flutter1;

USE flutter1;

CREATE TABLE imagenes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ruta VARCHAR(255)
);
```

---

## ⚙️ Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/flutter-paralelo.git
cd flutter-paralelo
```

### 2. Instalar dependencias Flutter

```bash
flutter pub get
```

### 3. Configurar backend

```bash
cd backend
npm install
```

### 4. Ejecutar backend

```bash
node server.js
```

### 5. Correr la app Flutter

```bash
cd ..
flutter run
```

---

## 📋 Estructura del Proyecto

```bash
lib/
├── articulos/
├── auth/
├── home/
├── imagenes/
├── login/
├── mantenimientos/
├── models/
├── productos/
├── usuarios/

backend/
├── controllers/
├── routes/
├── uploads/
```

---

## ✅ Funcionalidades principales

- Autenticación básica
- Gestión de productos y usuarios
- Subida de imágenes con visualización en galería
- Verificación en tiempo real de estado del sistema (Wi-Fi, GPS, Bluetooth, Internet)
- Búsqueda y listado de artículos desde una API externa
- Acceso por módulos organizados (Login → Home → Módulos)

---

## 🧪 Validar funcionamiento

1. **Inicio de sesión:** accede con credenciales configuradas en tu backend.
2. **Subida de imagen:** selecciona una imagen y verifica que se guarde en la carpeta `/uploads` y en la BD.
3. **Galería:** accede al botón de galería y asegúrate de que se vean las imágenes.
4. **Pantalla API:** valida que se muestre el estado de los servicios y que la búsqueda funcione correctamente.

---

## 🐞 Posibles errores y soluciones

| Problema | Solución |
|---------|----------|
| ❌ API externa no devuelve datos | Verifica que el enlace de la API esté bien formado (con `consulta=` al final) |
| ❌ Bluetooth siempre aparece inactivo | Asegúrate de que estás usando `flutter_reactive_ble` correctamente, y que los permisos estén habilitados |
| ❌ No se suben imágenes | Verifica que la carpeta `uploads/` exista y tenga permisos de escritura |
| ❌ `10.0.2.2` no responde en Android | Solo funciona en emuladores; si usas dispositivo físico, cambia por tu IP local |
| ❌ Permisos | Asegúrate de tener en `AndroidManifest.xml` los permisos: `INTERNET`, `ACCESS_FINE_LOCATION`, `BLUETOOTH`, etc. |

---

## 📲 Permisos Android requeridos

Agrega en tu `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
```

---

## 📌 Notas finales

- Se recomienda probar en un dispositivo físico para validar correctamente Wi-Fi, GPS y Bluetooth.
- El servidor debe estar corriendo en todo momento para operaciones con imágenes y autenticación.
- Esta app está pensada para uso académico o como base para proyectos empresariales.

---

## 📧 Contacto

Desarrollado por Jeremy Suriel.  
¿Dudas? Escríbeme o abre un issue en el repositorio.
