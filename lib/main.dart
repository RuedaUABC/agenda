import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importaciones de tu proyecto
import 'package:agenda/core/theme/app_theme.dart';
import 'package:agenda/features/navegacion/presentation/navegacion.dart';

void main() async {
  // 1. Asegura que los bindings de Flutter estén listos para código asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Firebase antes de lanzar la aplicación
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Dark Mode', // Título actualizado para tu proyecto
      // CONFIGURACIÓN DE TEMA ÚNICO OSCURO
      // Usamos darkTheme para ambos casos para garantizar consistencia total
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,

      // Forzamos el modo oscuro sin importar el sistema del usuario
      themeMode: ThemeMode.dark,

      // Tu widget de navegación (BasePage/nav)
      home: const nav(),
    );
  }
}
