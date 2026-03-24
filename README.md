# agenda

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Estructura
lib/
 ├── main.dart              # Punto de entrada de la app
 ├── models/                # Clases de datos
 │    └── tarea.dart
 ├── services/              # Lógica de negocio / APIs
 │    └── google_api_service.dart
 ├── screens/               # Pantallas de la app
 │    ├── home_screen.dart
 │    └── tarea_screen.dart
 ├── widgets/               # Widgets reutilizables
 │    └── tarea_card.dart
 └── utils/                 # Funciones auxiliares
      └── formatters.dart
