import 'package:flutter/material.dart';
import 'package:agenda/widgets/task_list.dart';
import 'package:agenda/widgets/panel_progress.dart';

class MyMobileHome extends StatelessWidget {
  const MyMobileHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [PanelProgress(), Tasklist()]));
  }
}
