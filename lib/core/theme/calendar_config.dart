import 'package:flutter/material.dart';

class CalendarConfig {
  // Configuración centralizada para colores y estilos del calendario
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color accentColor = Color(0xFFFFA000);
  
  static double get desktopCalendarFlex => 13;
  static double get desktopListFlex => 8;

  static DateTimeRange get defaultDisplayRange => DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 365)),
        end: DateTime.now().add(const Duration(days: 365)),
      );

  static EdgeInsetsGeometry get pagePadding => const EdgeInsets.all(16.0);
  static BorderRadius get cardRadius => BorderRadius.circular(12.0);
}
