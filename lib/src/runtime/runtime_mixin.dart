import 'package:flutter/widgets.dart';
import 'package:flutter_ecosed/src/runtime/runtime_wrapper.dart';

import '../platform/platform_interface.dart';
import '../plugin/plugin_base.dart';
import 'runtime.dart';

base mixin RuntimeMixin on EcosedPlatformInterface {
  final RuntimeWrapper _wrapper = EcosedRuntime()();

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

  @override
  Widget getManagerWidget() {
    try {
      return _wrapper.getManagerWidget();
    } on Exception {
      return super.getManagerWidget();
    }
  }
}
