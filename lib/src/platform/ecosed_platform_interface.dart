import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../plugin/plugin.dart';

abstract class EcosedPlatformInterface extends PlatformInterface {
  EcosedPlatformInterface() : super(token: _token);

  /// 令牌
  static final Object _token = Object();

  /// 实例
  static EcosedPlatformInterface _instance = DefaultPlatform();

  /// 获取实例
  static EcosedPlatformInterface get instance => _instance;

  /// 设置实例
  static set instance(EcosedPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 获取插件列表
  Future<List?> getPlatformPluginList() async {
    throw UnimplementedError('getPlatformPluginList()方法未实现');
  }

  /// 打开对话框
  Future<bool?> openPlatformDialog() async {
    throw UnimplementedError('openPlatformDialog()方法未实现');
  }

  /// 关闭对话框
  Future<bool?> closePlatformDialog() async {
    throw UnimplementedError('closePlatformDialog()方法未实现');
  }

  /// 运行应用
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required String appName,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    throw UnimplementedError('runEcosedApp()方法未实现');
  }
}

final class DefaultPlatform extends EcosedPlatformInterface {
  /// 运行应用
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required String appName,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    //throw FlutterError(message);
    throw UnimplementedError('');
  }
}
