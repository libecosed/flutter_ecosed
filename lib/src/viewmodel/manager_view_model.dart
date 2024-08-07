import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../type/dialog_launcher.dart';
import '../type/plugin_getter.dart';
import '../type/plugin_widget_gatter.dart';
import '../type/runtiem_checker.dart';
import '../values/url.dart';
import 'view_model_wrapper.dart';

final class ManagerViewModel with ChangeNotifier implements ViewModelWrapper {
  ManagerViewModel({
    required this.context,
    required this.pluginDetailsList,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
    required this.launchDialog,
    required this.appName,
    required this.appVersion,
  });

  /// 上下文
  final BuildContext context;

  /// 插件列表
  final List<PluginDetails> pluginDetailsList;

  /// 获取插件
  final PluginGetter getPlugin;

  /// 获取插件界面
  final PluginWidgetGetter getPluginWidget;

  /// 判断是否运行时
  final RuntimeChecker isRuntime;

  /// 打开对话框
  final DialogLauncher launchDialog;

  final String appName;
  final String appVersion;

  /// 打开对话框
  @override
  Future<void> openDebugMenu() async => await launchDialog();

  /// 统计普通插件数量
  @override
  int pluginCount() {
    var count = 0;
    for (var element in pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        count++;
      }
    }
    return count;
  }

  /// 打开PubDev
  @override
  Future<bool> launchPubDev() async {
    return await launchUrl(
      Uri.parse(pubDevUrl),
    );
  }

  /// 获取插件列表
  @override
  List<PluginDetails> get getPluginDetailsList {
    return pluginDetailsList;
  }

  /// 获取插件图标
  @override
  Widget getPluginIcon(PluginDetails details) {
    switch (details.type) {
      case PluginType.base:
        return Icon(
          Icons.compare_arrows,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.runtime:
        return Icon(
          Icons.bubble_chart,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.engine:
        return Icon(
          Icons.miscellaneous_services,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueAccent,
        );
      case PluginType.platform:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            return Icon(
              Icons.android,
              size: Theme.of(context).iconTheme.size,
              color: Colors.green,
            );
          case TargetPlatform.fuchsia:
            return Icon(
              Icons.all_inclusive,
              size: Theme.of(context).iconTheme.size,
              color: Colors.pinkAccent,
            );
          case TargetPlatform.iOS:
            return Icon(
              Icons.apple,
              size: Theme.of(context).iconTheme.size,
              color: Colors.grey,
            );
          case TargetPlatform.linux:
            return Icon(
              Icons.desktop_windows,
              size: Theme.of(context).iconTheme.size,
              color: Colors.black,
            );
          case TargetPlatform.macOS:
            return Icon(
              Icons.apple,
              size: Theme.of(context).iconTheme.size,
              color: Colors.grey,
            );
          case TargetPlatform.windows:
            return Icon(
              Icons.window,
              size: Theme.of(context).iconTheme.size,
              color: Colors.blue,
            );
          default:
            return Icon(
              Icons.question_mark,
              size: Theme.of(context).iconTheme.size,
              color: Colors.red,
            );
        }
      case PluginType.kernel:
        return Icon(
          Icons.memory,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueGrey,
        );
      case PluginType.flutter:
        return const FlutterLogo();
      case PluginType.unknown:
        return Icon(
          Icons.error,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
      default:
        return Icon(
          Icons.error,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }

  /// 获取插件类型
  @override
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
      // 平台插件
      case PluginType.platform:
        return '平台插件';
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
  @override
  String getPluginAction(PluginDetails details) {
    return _isAllowPush(details)
        ? details.channel != 'ecosed_runtime'
            ? '打开'
            : '关于'
        : '无界面';
  }

  /// 获取插件的提示
  @override
  String getPluginTooltip(PluginDetails details) {
    return _isAllowPush(details)
        ? details.channel != 'ecosed_runtime'
            ? '打开插件的界面'
            : '关于本框架'
        : '此插件没有界面';
  }

  /// 打开卡片
  @override
  VoidCallback? openPlugin(PluginDetails details) {
    // 无法打开的返回空
    return _isAllowPush(details)
        ? () {
            if (!isRuntime(details)) {
              // 非运行时打开插件页面
              _launchPlugin(context, details);
            } else {
              // 运行时打开关于对话框
              showAboutDialog(
                context: context,
                applicationName: appName,
                applicationVersion: appVersion,
                applicationLegalese: 'Powered by FlutterEcosed',
                useRootNavigator: true,
              );
            }
          }
        : null;
  }

  @override
  String get getAppName {
    return appName;
  }

  @override
  String get getAppVersion {
    return appVersion;
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        getPlugin(details) != null;
  }

  /// 打开插件
  Future<MaterialPageRoute?> _launchPlugin(
    BuildContext host,
    PluginDetails details,
  ) async {
    return await Navigator.of(host, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(details.title),
          ),
          body: getPluginWidget(context, details),
        ),
      ),
    );
  }
}
