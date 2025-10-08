# zona44app

Aplicación móvil desarrollada en Flutter para la gestión de reservas y perfiles de usuario en Zona 44.

---

## Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Características Principales](#características-principales)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Dependencias](#dependencias)
- [Instalación y Ejecución](#instalación-y-ejecución)
- [Notas y Buenas Prácticas](#notas-y-buenas-prácticas)

---

## Descripción General

**zona44app** es una aplicación móvil multiplataforma (Android/iOS) que permite a los usuarios:
- Registrarse e iniciar sesión de forma segura.
- Realizar reservas de mesas indicando nombre, teléfono, número de personas y fecha/hora.
- Visualizar una pantalla principal (Home) tras autenticarse.
- Gestionar su perfil de usuario.
- Realizar pedidos en tiempo real

La app utiliza el patrón BLoC para la gestión de estados y anima las transiciones entre pantallas y formularios.

---

## Características Principales

- **Autenticación de usuarios:**  
  Registro e inicio de sesión con validación de formularios y almacenamiento seguro del token de sesión (`SharedPreferences`).

- **Gestión de reservas:**  
  Formulario para crear reservas con validación de campos, selección de fecha/hora y número de personas, y confirmación visual mediante un `AlertDialog`.

- **Campos inteligentes:**  
  - Campo de teléfono internacional con selección de país y validación (`intl_phone_field`).
  - Selectores personalizados para fecha, hora y cantidad de personas.

- **Animaciones:**  
  Transiciones suaves en formularios y tarjetas usando `FadeTransition` y `SlideTransition`.

- **Navegación:**  
  Navegación entre pantallas usando `Navigator`, con botón de retroceso personalizado.

---

## Estructura del Proyecto

```
lib/
├── pages/
│   ├── Home/
│   │   └── home.dart
│   ├── Perfil/
│   │   ├── login/
│   │   │   ├── bloc/
│   │   │   │   └── login_bloc.dart
│   │   │   └── login.dart
│   │   └── register/
│   │       ├── bloc/
│   │       │   └── register_bloc.dart
│   │       └── register.dart
│   └── reservas/
│       ├── booking_pages.dart
│       └── widgets/
│           ├── boton_confirmar.dart
│           ├── campo_fecha_hora.dart
│           ├── campo_nombre.dart
│           ├── campo_personas.dart
│           └── campo_telefono.dart
├── services/
│   └── user_service.dart
└── main.dart
```

- **pages/Perfil/login/**: Pantalla y lógica de inicio de sesión.
- **pages/Perfil/register/**: Pantalla y lógica de registro de usuario.
- **pages/Home/**: Pantalla principal tras autenticación.
- **pages/reservas/**: Pantalla y widgets para la gestión de reservas.
- **services/**: Servicios para la comunicación con la API y gestión de usuarios.

---

## Dependencias

- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): Gestión de estados.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): Almacenamiento local seguro.
- [`intl_phone_field`](https://pub.dev/packages/intl_phone_field): Campo de teléfono internacional.
- Otros paquetes estándar de Flutter.

---

## Instalación y Ejecución

1. Clona este repositorio:
   ```sh
   git clone https://github.com/tu_usuario/zona44app.git
   cd zona44app
   ```
2. Instala las dependencias:
   ```sh
   flutter pub get
   ```
3. Ejecuta la aplicación:
   ```sh
   flutter run
   ```

---

## Notas y Buenas Prácticas

- El proyecto sigue en desarrollo y puede contener funcionalidades en progreso.
- Se recomienda seguir el patrón BLoC para nuevas funcionalidades.
- Para dudas o sugerencias, contacta al equipo de desarrollo.

---