import 'package:flutter/widgets.dart';

import '../interface/ecosed_interface.dart';
import '../plugin/plugin_runtime.dart';
import '../type/runner.dart';
import 'base.dart';

base mixin BaseEntry on EcosedInterface {
  /// 初始化运行时
  final EcosedInterface _interface = EcosedBase()();

  /// 运行应用
  @override
  Future<void> runEcosedApp(
    Widget app,
    List<EcosedRuntimePlugin> plugins,
    Runner runner,
  ) async {
    try {
      return await _interface.runEcosedApp(
        app,
        plugins,
        runner,
      );
    } on Exception {
      return await super.runEcosedApp(
        app,
        plugins,
        runner,
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
      return await _interface.execPluginMethod(
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

  /// 打开调试菜单
  @override
  Future<void> openDebugMenu() async {
    try {
      return await _interface.openDebugMenu();
    } on Exception {
      return await super.openDebugMenu();
    }
  }
}
