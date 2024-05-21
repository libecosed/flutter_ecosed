import 'package:flutter/widgets.dart';

import '../../flutter_ecosed.dart';
import '../plugin/plugin.dart';
import '../runtime/runtime.dart';

Future<void> runEcosedApp({
  required Widget Function(Widget manager) app,
  required List<EcosedPlugin> plugins,
  required Future<void> Function(Widget app) runApplication,
}) async {
  return await EcosedRuntime(
    app: app,
    plugins: plugins,
    runApplication: runApplication,
  )();
}
