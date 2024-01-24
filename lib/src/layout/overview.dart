import 'package:flutter/material.dart';

import '../widget/state.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: StateCard(
              icon: Icons.keyboard_command_key,
              title: 'FlutterEcosed',
              subtitle: '版本: 1.0',
            ))
      ],
    );
  }
}
