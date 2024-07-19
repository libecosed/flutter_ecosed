import 'package:flutter/widgets.dart';

import '../platform/ecosed_interface.dart';
import '../plugin/runtime/plugin_runtime.dart';
import 'base.dart';

base mixin BaseEntry on EcosedInterface {
  /// 初始化运行时
  final EcosedInterface _runtime = EcosedBase()();

  /// 运行应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    try {
      return await _runtime.runEcosedApp(
        app: app,
        plugins: plugins,
        runner: runner,
      );
    } on Exception {
      return await super.runEcosedApp(
        app: app,
        plugins: plugins,
        runner: runner,
      );
    }
  }

  /// 执行插件方法
  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    try {
      return await _runtime.execPluginMethod(
        channel,
        method,
        arguments,
      );
    } on Exception {
      return await super.execPluginMethod(
        channel,
        method,
        arguments,
      );
    }
  }

  /// 管理器
  @override
  Widget getManagerWidget() {
    try {
      return _runtime.getManagerWidget();
    } on Exception {
      return super.getManagerWidget();
    }
  }
}
