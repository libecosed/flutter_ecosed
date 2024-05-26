import 'package:flutter/widgets.dart';

import '../plugin/plugin.dart';
import '../runtime/runtime.dart';

Future<void> runEcosedApp({
  required WidgetBuilder app,
  required String appName,
  required List<EcosedPlugin> plugins,
  required Future<void> Function(Widget app) runner,
}) async {
  return await EcosedRuntime(
    app: app,
    appName: appName,
    plugins: plugins,
    runner: runner,
  )();
}
