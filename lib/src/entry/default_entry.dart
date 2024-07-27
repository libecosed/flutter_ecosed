import 'dart:io';

import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../plugin/plugin_runtime.dart';
import '../interface/ecosed_interface.dart';
import '../values/tag.dart';

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
    Log.w(entryTag, '不支持当前平台$_platform');
    runner(app);
  }

  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    Log.w(entryTag, '不支持当前平台$_platform');
    return await null;
  }

  @override
  Future<void> openDebugMenu() async {

  }

  // @override
  // Widget getManagerWidget() {
  //   return Center(
  //     child: Text('不支持当前平台$_platform'),
  //   );
  // }
}
