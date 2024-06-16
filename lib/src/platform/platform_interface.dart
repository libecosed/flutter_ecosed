import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../plugin/plugin.dart';

/// 实现平台接口的抽象类
base class EcosedPlatformInterface extends PlatformInterface {
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
}

/// 无法正确加载平台时的实现
final class DefaultPlatform extends EcosedPlatformInterface {
  /// 运行应用 - 抛出未知平台异常
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    // 获取当前操作系统名称
    String platform = Platform.operatingSystem;
    // 抛出异常
    throw FlutterError('不支持当前平台$platform');
  }
}
