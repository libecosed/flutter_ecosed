import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/plugin/plugin_person.dart';

import '../plugin/plugin_type.dart';

class PluginItem extends StatelessWidget {
  const PluginItem({super.key, required this.person});

  final PluginPerson person;

  String _getType() {
    switch (person.type) {
      case PluginType.native:
        return '内置模块 - Native';
      case PluginType.flutter:
        return person.initial ? '内置模块 - Flutter' : '普通模块';
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
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.title,
                            textAlign: TextAlign.start,
                            style: textTheme.titleMedium),
                        Text(
                          '通道: ${person.channel}',
                          textAlign: TextAlign.start,
                          style: textTheme.bodySmall,
                        ),
                        Text(
                          '作者: ${person.author}',
                          textAlign: TextAlign.start,
                          style: textTheme.bodySmall,
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
                  person.description,
                  textAlign: TextAlign.start,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    Text(
                      _getType(),
                      style: textTheme.bodySmall,
                    ),
                    const Spacer(flex: 1),
                    TextButton(onPressed: () {}, child: const Text('设置')),
                    TextButton(onPressed: () {}, child: const Text('卸载'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
