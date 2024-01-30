import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/widget/ecosed_logo.dart';

import '../../flutter_ecosed.dart';
import '../layout/manager.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';

class PluginItem extends StatefulWidget {
  const PluginItem(
      {super.key, required this.details, required this.thirdPlugin});

  final PluginDetails details;
  final EcosedPlugin? thirdPlugin;

  @override
  State<PluginItem> createState() => _PluginItemState();
}

class _PluginItemState extends State<PluginItem> {
  String _getType() {
    switch (widget.details.type) {
      case PluginType.native:
        return '内置插件';
      case PluginType.flutter:
        return widget.details.initial ? '内置插件' : '普通插件';
      default:
        return 'Unknown';
    }
  }

  bool isAllowPush() {
    return !widget.details.initial &&
        widget.details.type == PluginType.flutter &&
        widget.thirdPlugin != null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
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
                        widget.details.title,
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
                        '通道: ${widget.details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: textTheme.bodySmall?.fontSize,
                          fontFamily: textTheme.bodySmall?.fontFamily,
                          height: textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: ${widget.details.author}',
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
                      widget.details.type == PluginType.native
                          ? const EcosedLogo()
                          : const FlutterLogo(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.details.description,
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
                  IgnorePointer(
                    ignoring: !isAllowPush(),
                    child: TextButton(
                      onPressed: () {
                        if (isAllowPush()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  widget.thirdPlugin!.pluginWidget(context),
                            ),
                          );
                        }
                      },
                      child: Text(
                        isAllowPush() ? '打开' : '无界面',
                        style: TextStyle(
                            fontFamily: textTheme.labelMedium?.fontFamily,
                            fontStyle: textTheme.labelMedium?.fontStyle,
                            color: isAllowPush()
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
