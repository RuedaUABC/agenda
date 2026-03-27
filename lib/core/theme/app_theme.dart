import 'package:flutter/material.dart';

class AppTheme {
  // Colores extraídos de tu configuración .dark (OKLCH)
  static const Color _background = Color(0xFF000000); // oklch(0 0 0)
  static const Color _foreground = Color(
    0xFFE1E7EF,
  ); // oklch(0.9328 0.0025 228.7857)
  static const Color _primary = Color(
    0xFF3B82F6,
  ); // oklch(0.6692 0.1607 245.0110)
  static const Color _card = Color(0xFF1E1E2E); // oklch(0.2097 0.0080 274.5332)
  static const Color _mutedForeground = Color(0xFF8F9BB3);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Aplicamos tu paleta OKLCH
      colorScheme: const ColorScheme.dark(
        surface: _background,
        onSurface: _foreground,
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _card,
        onSecondary: _foreground,
        error: Color(0xFFEF4444), // oklch(0.6188 0.2376 25.7658)
      ),

      scaffoldBackgroundColor: _background,

      // Aplicamos la fuente sans-serif por defecto
      fontFamily: 'Roboto', // Equivalente a ui-sans-serif
    );
  }
}
