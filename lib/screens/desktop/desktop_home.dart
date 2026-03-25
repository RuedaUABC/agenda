import 'package:flutter/material.dart';
import 'package:agenda/widgets/task_list.dart';
import 'package:agenda/widgets/panel_progress.dart';

class MyDesktopHome extends StatelessWidget {
  const MyDesktopHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Column(children: [PanelProgress(), Tasklist()])),
        Expanded(child: Tasklist()),
      ],
    );
  }
}
