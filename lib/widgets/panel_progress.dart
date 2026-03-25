import 'package:flutter/material.dart';

class PanelProgress extends StatelessWidget {
  const PanelProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(8.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(color: Colors.blueAccent),
      ),
    );
  }
}
