import 'package:flutter/material.dart';

import 'info_item.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key,
      required this.appName,
      required this.state,
      required this.platform,
      required this.count,
      f});

  final String appName;
  final String state;
  final String platform;
  final String count;

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
                    title: '当前状态',
                    subtitle: state,
                  ),
                  const SizedBox(height: 16),
                  InfoItem(
                    title: '当前平台',
                    subtitle: platform,
                  ),
                  const SizedBox(height: 16),
                  InfoItem(
                    title: '插件数量',
                    subtitle: count,
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
