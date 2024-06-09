import 'package:flutter/widgets.dart';

import '../platform/platform_interface.dart';
import '../plugin/plugin.dart';

/// {@tool snippet}
///
/// 启动应用
///
/// ```dart
/// await runEcosedApp(
///   app: (context) => const MyApp(),
///   plugins: const [ExamplePlugin()],
///   runner: (app) async => runApp(app),
/// );
/// ```
/// {@end-tool}
Future<void> runEcosedApp({
  required WidgetBuilder app,
  required List<EcosedPlugin> plugins,
  required Future<void> Function(Widget app) runner,
}) async {
  return await EcosedPlatformInterface.instance.runEcosedApp(
    app: app,
    plugins: plugins,
    runner: runner,
  );
}
