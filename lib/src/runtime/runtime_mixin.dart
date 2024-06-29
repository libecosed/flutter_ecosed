import 'package:flutter/widgets.dart';

import '../platform/interface.dart';
import '../plugin/plugin_base.dart';
import 'runtime.dart';

base mixin RuntimeMixin on EcosedPlatformInterface {
  final EcosedRuntime _runtime = EcosedRuntime();

  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    return await _runtime.runEcosedApp(
      app: app,
      plugins: plugins,
      runner: runner,
    );
  }

  @override
  Future<void> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await _runtime.execPluginMethod(
      channel,
      method,
      arguments,
    );
  }

  @override
  Widget getManagerWidget() {
    return _runtime.getManagerWidget();
  }
}
