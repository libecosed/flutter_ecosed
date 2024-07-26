import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_type.dart';
import '../values/url.dart';

class ManagerViewModel extends ChangeNotifier {
  ManagerViewModel();

  void launchPubDev() {
    launchUrl(
      Uri.parse(pubDevUrl),
    );
  }

  /// 插件是否可以打开
  bool isAllowPush({
    required PluginDetails details,
    required EcosedRuntimePlugin? Function(
      PluginDetails details,
    ) getPlugin,
  }) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        getPlugin(details) != null;
  }

  /// 统计普通插件数量
  int pluginCount({required List<PluginDetails> list}) {
    var count = 0;
    for (var element in list) {
      if (element.type == PluginType.flutter) {
        count++;
      }
    }
    return count;
  }

  Widget getPluginIcon({
    required BuildContext context,
    required PluginDetails details,
  }) {
    switch (details.type) {
      case PluginType.runtime:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.base:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.engine:
        return Icon(
          Icons.android,
          size: Theme.of(context).iconTheme.size,
          color: Colors.green,
        );
      case PluginType.kernel:
        return Icon(
          Icons.developer_board,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueGrey,
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

  /// 获取插件类型
  String getPluginType(PluginDetails details) {
    switch (details.type) {
      // 框架运行时
      case PluginType.runtime:
        return '框架运行时';
      // 绑定通信层
      case PluginType.base:
        return '绑定通信层';
      // 平台插件
      case PluginType.engine:
        return '引擎插件';
      // 内核模块
      case PluginType.kernel:
        return '内核模块';
      // 普通插件
      case PluginType.flutter:
        return '普通插件';
      // 未知插件类型
      case PluginType.unknown:
        return '未知插件类型';
      // 未知
      default:
        return 'Unknown';
    }
  }

  /// 获取插件的动作名
  String getPluginAction({required PluginDetails details}) {
    return isAllowPush(details: details, getPlugin: (details) {})
        ? details.channel != 'ecosed_runtime'
            ? '打开'
            : '关于'
        : '无界面';
  }
}

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ManagerViewModel>(
//       builder: (context, viewModel, child) {
        
//       },
//     );
//   }
// }
