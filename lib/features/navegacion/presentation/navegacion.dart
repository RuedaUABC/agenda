import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// Importa tus páginas reales aquí
import 'package:agenda/features/home/presentation/home.dart';
import 'package:agenda/features/horario/presentation/schedule.dart';
import 'package:agenda/features/calendario/presentation/calendar.dart';
import 'package:agenda/features/configuracion/presentation/settings.dart';

class nav extends StatefulWidget {
  const nav({super.key});

  @override
  State<nav> createState() => _navState();
}

class _navState extends State<nav> {
  int _currentIndex = 0;

  // SOLUCIÓN: Asegúrate de que la lista tenga las páginas reales
  final List<Widget> _pages = [
    const Homepage(),
    const SchedulePage(),
    const CalendarPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Extraemos el esquema de colores global
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // Usamos el fondo del tema global para evitar parpadeos blancos
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            // Colores extraídos del tema global
            activeColor: colors.primary,
            tabBackgroundColor: colors.primary.withOpacity(0.1),
            color: colors.onSurface.withOpacity(0.5),

            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            // SOLUCIÓN: Quitamos el 'const' de la lista de tabs
            tabs: [
              GButton(icon: Icons.home_rounded, text: 'Inicio'),
              GButton(icon: Icons.schedule_rounded, text: 'Horario'),
              GButton(icon: Icons.calendar_month_rounded, text: 'Calendario'),
              GButton(icon: Icons.settings_rounded, text: 'Ajustes'),
            ],
          ),
        ),
      ),
    );
  }
}
