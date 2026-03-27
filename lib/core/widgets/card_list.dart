import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String title;
  final List<Widget> cards;
  const CardList({super.key, required this.cards, this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != "") Text(title),
        Expanded(child: ListView(children: cards)),
      ],
    );
  }
}
