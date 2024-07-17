import 'package:flutter/widgets.dart';

import '../platform/platform_interface.dart';
import '../plugin/plugin_base.dart';
import 'runtime.dart';
import 'runtime_wrapper.dart';

base mixin RuntimeMixin on EcosedInterface {
  final RuntimeWrapper _wrapper = EcosedRuntime()();

  /// 运行应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    try {
      return await _wrapper.runEcosedApp(
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
      return await _wrapper.execPluginMethod(
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
      return _wrapper.getManagerWidget();
    } on Exception {
      return super.getManagerWidget();
    }
  }
}
