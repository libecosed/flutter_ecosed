import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';

class Plugin extends StatefulWidget {
  const Plugin(
      {super.key, required this.pluginDetailsList, required this.pluginList});

  final List<PluginDetails> pluginDetailsList;
  final List<EcosedPlugin> pluginList;

  @override
  State<Plugin> createState() => _PluginState();
}

class _PluginState extends State<Plugin> {
  EcosedPlugin? _plugin(PluginDetails details) {
    if (widget.pluginList.isNotEmpty) {
      for (var element in widget.pluginList) {
        if (element.pluginChannel() == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  String _getType(PluginDetails details) {
    switch (details.type) {
      case PluginType.native:
        return '内置插件 - Platform';
      case PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件';
      default:
        return 'Unknown';
    }
  }

  bool _isAllowPush(PluginDetails details) {
    return details.type == PluginType.flutter && _plugin(details) != null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Column(
        children: widget.pluginDetailsList
            .map(
              (element) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                                  element.title,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: textTheme.titleMedium?.fontSize,
                                    fontFamily:
                                        textTheme.titleMedium?.fontFamily,
                                    height: textTheme.bodySmall?.height,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '通道: ${element.channel}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: textTheme.bodySmall?.fontSize,
                                    fontFamily: textTheme.bodySmall?.fontFamily,
                                    height: textTheme.bodySmall?.height,
                                  ),
                                ),
                                Text(
                                  '作者: ${element.author}',
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
                              children: [
                                element.type == PluginType.native
                                    ? Icon(
                                        Icons.keyboard_command_key,
                                        size: IconTheme.of(context).size,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const FlutterLogo(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          element.description,
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
                              _getType(element),
                              textAlign: TextAlign.start,
                              style: textTheme.bodySmall,
                            ),
                            const Spacer(flex: 1),
                            IgnorePointer(
                              ignoring: !_isAllowPush(element),
                              child: TextButton(
                                onPressed: () {
                                  if (_isAllowPush(element)) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => _plugin(element)!
                                            .pluginWidget(context),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  _isAllowPush(element) ? '打开' : '无界面',
                                  style: TextStyle(
                                    fontFamily:
                                        textTheme.labelMedium?.fontFamily,
                                    fontStyle: textTheme.labelMedium?.fontStyle,
                                    color: _isAllowPush(element)
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
