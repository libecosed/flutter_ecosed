import 'dart:io';

import 'package:flutter/widgets.dart';

import '../plugin/plugin_runtime.dart';
import '../interface/ecosed_interface.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends EcosedInterface {
  /// 获取当前操作系统名称
  final String _platform = Platform.operatingSystem;

  /// 运行应用 - 抛出未知平台异常
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    // 抛出异常
    throw FlutterError('不支持当前平台$_platform');
  }

  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    // 抛出异常
    throw FlutterError('不支持当前平台$_platform');
  }

  @override
  Widget getManagerWidget() {
    // 抛出异常
    throw FlutterError('不支持当前平台$_platform');
  }
}
