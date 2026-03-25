import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:agenda/screens/home.dart';
import 'package:agenda/screens/schedule.dart';
import 'package:agenda/screens/calendar.dart';
import 'package:agenda/screens/settings.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // Índice para controlar la página activa
  int _currentIndex = 0;

  // Lista de páginas (Asegúrate de que Homepage, SchedulePage, etc., existan en tus archivos)
  final List<Widget> _pages = [
    const Homepage(),
    const SchedulePage(),
    const CalendarPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Se muestra la página correspondiente al índice actual
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.blueAccent,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
              color: Colors.black,

              // Vinculación del estado
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: const [
                GButton(icon: Icons.home, text: 'Inicio'),
                GButton(icon: Icons.schedule, text: 'Horario'),
                GButton(icon: Icons.calendar_today, text: 'Calendario'),
                GButton(icon: Icons.settings, text: 'Ajustes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
