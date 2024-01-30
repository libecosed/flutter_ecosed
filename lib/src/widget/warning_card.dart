import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key, required this.title, required this.actions});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        child: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      backgroundColor: Colors.transparent,
      content: Text(title),
      actions: actions,
      dividerColor: Colors.transparent,
      forceActionsBelow: true,
    );
  }
}
