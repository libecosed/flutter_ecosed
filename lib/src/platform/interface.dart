import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../plugin/plugin.dart';
import 'default.dart';

/// 实现平台接口的抽象类
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

  /// 运行应用
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    throw UnimplementedError('未实现runEcosedApp()方法');
  }

  /// 执行方法
  Future<dynamic> execPluginMethod(
    BuildContext context,
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    throw UnimplementedError('未实现execPluginMethod()方法');
  }

  /// 获取管理器
  Widget getManagerWidget(BuildContext context) {
    throw UnimplementedError('未实现getManagerWidget()方法');
  }
}
