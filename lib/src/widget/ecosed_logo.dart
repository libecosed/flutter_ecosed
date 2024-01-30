import 'package:flutter/material.dart';

class EcosedLogo extends StatelessWidget {
  const EcosedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      size: IconTheme.of(context).size,
      Icons.keyboard_command_key,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
