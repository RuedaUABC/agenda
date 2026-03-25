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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const SchedulePage(),
    const CalendarPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      // 1. Agregamos el botón flotante central
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes abrir un formulario para agregar nueva tarea
          debugPrint("Agregar nueva tarea");
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        notchMargin: 8.0,
        shape: const CircularNotchedRectangle(), // Crea la curva para el botón
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 5, // Reducimos el gap para que quepan bien con el botón
            activeColor: Colors.blueAccent,
            iconSize: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
            color: Colors.black,
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: const [
              GButton(icon: Icons.home, text: 'Inicio'),
              GButton(icon: Icons.schedule, text: 'Horario'),
              // Espaciador invisible para el botón central
              GButton(icon: Icons.calendar_today, text: 'Calendario'),
              GButton(icon: Icons.settings, text: 'Ajustes'),
            ],
          ),
        ),
      ),
    );
  }
}
