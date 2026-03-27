import 'package:flutter/material.dart';
import 'package:agenda/core/widgets/card_list.dart';

class DesktopColumns extends StatelessWidget {
  final List<Widget> columnLeft;
  final List<Widget> columnRight;
  const DesktopColumns({
    super.key,
    required this.columnLeft,
    required this.columnRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CardList(cards: columnLeft, title: "Hoy"),
        ),
        Expanded(
          child: CardList(cards: columnRight, title: "Mañana"),
        ),
      ],
    );
  }
}
