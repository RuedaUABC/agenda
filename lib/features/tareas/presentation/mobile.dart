import 'package:flutter/material.dart';
import 'package:agenda/core/widgets/card_list.dart';

class MyMobileBody extends StatelessWidget {
  const MyMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [CardList(cards: [], title: "Hoy")],
      ),
    );
  }
}
