import 'package:flutter/material.dart';

final class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.pluginCount,
  });

  final String appName;
  final String appVersion;
  final int pluginCount;

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
                  InfoItem(
                    title: '应用名称',
                    subtitle: appName,
                  ),
                  const SizedBox(height: 16),
                  InfoItem(
                    title: '应用版本',
                    subtitle: appVersion,
                  ),
                  const SizedBox(height: 16),
                  InfoItem(
                    title: '当前平台',
                    subtitle: Theme.of(context).platform.name,
                  ),
                  const SizedBox(height: 16),
                  InfoItem(
                    title: '插件数量',
                    subtitle: pluginCount.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
