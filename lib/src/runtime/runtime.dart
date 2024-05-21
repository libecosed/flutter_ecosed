import 'package:flutter/widgets.dart';

import '../platform/ecosed_platform_interface.dart';
import '../plugin/plugin.dart';
import '../values/methods.dart';
import '../widget/ecosed_banner.dart';

final class EcosedRuntime implements EcosedPlugin, EcosedPlatformInterface {
  EcosedRuntime({
    required this.app,
    required this.plugins,
    required this.runner,
  });

  final WidgetBuilder app;
  final List<EcosedPlugin> plugins;
  final Future<void> Function(Widget app) runner;

  final EcosedPlatformInterface _platform = EcosedPlatformInterface.instance;

  late List<EcosedPlugin> _pluginList;

  /// 运行时执行入口
  Future<void> call() async {
    await _init();

    await runner(
      EcosedBanner(
        child: Builder(
          builder: (context) => app(context),
        ),
      ),
    );
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case getPluginMethod:
        return await getPlatformPluginList();
      case openDialogMethod:
        return await openPlatformDialog();
      case closeDialogMethod:
        return await closePlatformDialog();
      default:
        return await null;
    }
  }

  /// 插件名称
  @override
  String pluginAuthor() => 'wyq0918dev';

  /// 插件通道
  @override
  String pluginChannel() => 'runtime';

  /// 插件描述
  @override
  String pluginDescription() => 'Ecosed Runtime';

  /// 插件名称
  @override
  String pluginName() => 'EcosedRuntime';

  /// 插件用户界面
  @override
  Widget pluginWidget(BuildContext context) {
    return Container();
  }

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await _platform.getPlatformPluginList();
  }

  /// 打开平台对话框
  @override
  Future<bool?> openPlatformDialog() async {
    return await _platform.openPlatformDialog();
  }

  /// 关闭平台对话框
  @override
  Future<bool?> closePlatformDialog() async {
    return await _platform.closePlatformDialog();
  }

  /// 初始化运行时
  Future<void> _init() async {
    _pluginList = <EcosedPlugin>[];
    _pluginList.add(this);
    _pluginList.addAll(plugins);
  }
}
