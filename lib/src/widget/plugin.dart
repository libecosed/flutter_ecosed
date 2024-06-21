import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';

final class PluginListCard extends StatelessWidget {
  const PluginListCard({
    super.key,
    required this.pluginDetailsList,
    required this.appName,
    required this.appVersion,
    required this.isAllowPush,
    required this.isRuntime,
    required this.pluginWidget,
  });

  final List<PluginDetails> pluginDetailsList;
  final String appName;
  final String appVersion;
  final bool Function(PluginDetails details) isAllowPush;
  final bool Function(PluginDetails details) isRuntime;
  final Widget Function(
    BuildContext context,
    PluginDetails details,
  ) pluginWidget;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: pluginDetailsList
          .map(
            (element) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Builder(
                builder: (context) => PluginCard(
                  details: element,
                  appName: appName,
                  appVersion: appVersion,
                  isAllowPush: isAllowPush,
                  isRuntime: isRuntime,
                  pluginWidget: pluginWidget,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.details,
    required this.appName,
    required this.appVersion,
    required this.isAllowPush,
    required this.isRuntime,
    required this.pluginWidget,
  });

  final PluginDetails details;
  final String appName;
  final String appVersion;
  final bool Function(PluginDetails details) isAllowPush;
  final bool Function(PluginDetails details) isRuntime;
  final Widget Function(
    BuildContext context,
    PluginDetails details,
  ) pluginWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '通道: ${details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: ${details.author}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                ),
                PluginIcon(details: details),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              details.description,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _getPluginType(details),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: isAllowPush(details)
                      ? () {
                          if (!isRuntime(details)) {
                            // 非运行时打开插件页面
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(
                                      details.title,
                                    ),
                                  ),
                                  body: pluginWidget(context, details),
                                ),
                              ),
                            );
                          } else {
                            // 运行时打开关于对话框
                            showAboutDialog(
                              context: context,
                              applicationName: appName,
                              applicationVersion: appVersion,
                              applicationLegalese: 'Powered by FlutterEcosed',
                              useRootNavigator: false,
                            );
                          }
                        }
                      : null,
                  child: PluginAction(
                    details: details,
                    isAllowPush: isAllowPush,
                    isRuntime: isAllowPush,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class PluginIcon extends StatelessWidget {
  const PluginIcon({
    super.key,
    required this.details,
  });

  final PluginDetails details;

  @override
  Widget build(BuildContext context) {
    switch (details.type) {
      case PluginType.platform:
        return Icon(
          Icons.android,
          size: Theme.of(context).iconTheme.size,
          color: Colors.green,
        );
      case PluginType.runtime:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.flutter:
        return const FlutterLogo();
      case PluginType.unknown:
        return Icon(
          Icons.error_outline,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
      default:
        return Icon(
          Icons.error_outline,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }
}

/// 获取插件类型
String _getPluginType(PluginDetails details) {
  switch (details.type) {
    // 平台插件
    case PluginType.platform:
      return '平台插件';
    // 框架运行时
    case PluginType.runtime:
      return '框架运行时';
    // 普通插件
    case PluginType.flutter:
      return '普通插件';
    // 未知
    case PluginType.unknown:
      return '未知插件类型';
    // 未知
    default:
      return 'Unknown';
  }
}

class PluginAction extends StatelessWidget {
  const PluginAction({
    super.key,
    required this.details,
    required this.isAllowPush,
    required this.isRuntime,
  });

  final PluginDetails details;
  final bool Function(PluginDetails details) isAllowPush;
  final bool Function(PluginDetails details) isRuntime;

  @override
  Widget build(BuildContext context) {
    return Text(isAllowPush(details)
        ? isRuntime(details)
            ? '打开'
            : '关于'
        : '无界面');
  }
}
