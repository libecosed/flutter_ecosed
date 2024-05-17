import 'package:flutter/material.dart';

final class MoreCard extends StatelessWidget {
  const MoreCard({
    super.key,
    required this.launchUrl,
  });

  final VoidCallback launchUrl;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '了解 flutter_ecosed',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '了解如何使用 flutter_ecosed 进行开发。',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: launchUrl,
              icon: const Icon(Icons.open_in_browser),
            )
          ],
        ),
      ),
    );
  }
}
