import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '应用版本',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  '1.0',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                Text(
                  '内核版本',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  '1.0',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '设备架构',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  '1.0',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Shizuku版本',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  '1.0',
                  textAlign: TextAlign.start,
                  style: textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
