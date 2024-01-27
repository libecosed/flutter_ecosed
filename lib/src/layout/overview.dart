import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/widget/info_card.dart';

import '../widget/state_card.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: StateCard(
            color: Theme.of(context).colorScheme.errorContainer,
            icon: Icons.keyboard_command_key,
            title: 'Flutter Ecosed',
            subtitle: '1.0.0',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: InfoCard(),
        )
      ],
    );
  }
}
