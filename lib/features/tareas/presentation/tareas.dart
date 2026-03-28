import 'package:agenda/features/tareas/presentation/desktop.dart';
import 'package:agenda/features/tareas/presentation/mobile.dart';
import 'package:agenda/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(mobile: MyMobileBody(), desktop: MyDesktopBody()),
    );
  }
}
