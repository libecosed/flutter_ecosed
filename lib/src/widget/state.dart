import 'package:flutter/material.dart';

class StateCard extends StatelessWidget {
  const StateCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
