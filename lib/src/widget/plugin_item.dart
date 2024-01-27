import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';

class PluginItem extends StatelessWidget {
  const PluginItem({super.key, required this.details});

  final PluginDetails details;

  String _getType() {
    switch (details.type) {
      case PluginType.native:
        return '内置模块 - Native';
      case PluginType.flutter:
        return details.initial ? '内置模块 - Flutter' : '普通模块';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: textTheme.titleMedium?.fontSize,
                          fontFamily: textTheme.titleMedium?.fontFamily,
                          height: textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '通道: ${details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: textTheme.bodySmall?.fontSize,
                          fontFamily: textTheme.bodySmall?.fontFamily,
                          height: textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: ${details.author}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: textTheme.bodySmall?.fontSize,
                          fontFamily: textTheme.bodySmall?.fontFamily,
                          height: textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Switch(value: true, onChanged: (value) {})],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                details.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: textTheme.bodySmall?.fontSize,
                  fontFamily: textTheme.bodySmall?.fontFamily,
                  height: textTheme.bodySmall?.height,
                  fontWeight: textTheme.bodySmall?.fontWeight,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                children: [
                  Text(
                    _getType(),
                    textAlign: TextAlign.start,
                    style: textTheme.bodySmall,
                  ),
                  const Spacer(flex: 1),
                  TextButton(onPressed: () {}, child: const Text('设置')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
