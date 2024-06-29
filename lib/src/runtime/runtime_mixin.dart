import 'package:flutter/widgets.dart';

import '../platform/interface.dart';
import '../plugin/plugin.dart';
import 'runtime.dart';

base mixin RuntimeMixin on EcosedPlatformInterface {
  final EcosedRuntime _runtime = EcosedRuntime();

  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
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
    BuildContext context,
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await _runtime.execPluginMethod(
      context,
      channel,
      method,
      arguments,
    );
  }

  @override
  Widget getManagerWidget(BuildContext context) {
    return _runtime.getManagerWidget(context);
  }
}
