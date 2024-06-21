import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnMoreCard extends StatelessWidget {
  const LearnMoreCard({super.key});

  /// PubDev 统一资源定位符
  static const String _pubDev = 'https://pub.dev/packages/flutter_ecosed';

  @override
  Widget build(BuildContext context) {
    return Card(
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
              onPressed: () => launchUrl(Uri.parse(_pubDev)),
              icon: Icon(
                Icons.open_in_browser,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }
}
