import 'package:flutter/material.dart';

import '../widget/state_card.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: StateCard(
                icon: Icons.keyboard_command_key,
                title: 'Flutter Ecosed',
                subtitle: '1.0.0'))
      ],
    );
  }
}
