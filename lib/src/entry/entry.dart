import 'package:flutter/widgets.dart';

import '../plugin/plugin.dart';
import '../runtime/runtime.dart';

/// {@tool snippet}
/// ```dart
/// runEcosedApp(
///     app: (context) => const ExampleApp(),
///     appName: 'flutter_ecosed 示例应用',
///     plugins: const <EcosedPlugin>[ExamplePlugin()],
///     runner: (app) async => runApp(app),
/// );
/// ```
/// {@end-tool}
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
