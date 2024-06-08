/// flutter_ecosed.
library flutter_ecosed;

import 'package:flutter/widgets.dart';

import 'src/platform/ecosed_platform_interface.dart';
import 'src/plugin/plugin.dart';
import 'src/runtime/runtime.dart';
import 'src/widget/ecosed_inherited.dart';

export 'src/plugin/plugin.dart';

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
  return await EcosedPlatformInterface.instance.runEcosedApp(
    app: app,
    appName: appName,
    plugins: plugins,
    runner: runner,
  );
}

final class FlutterEcosedPlatform {
  const FlutterEcosedPlatform();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedRuntime();
  }
}

extension EcosedContext on BuildContext {
  /// 调用插件方法
  Future<dynamic> execPluginMethod(String channel, String method) async {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return await inherited.executor(channel, method);
    } else {
      throw FlutterError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }

  /// 获取管理器控件
  Widget getManagerWidget() {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return inherited.manager;
    } else {
      throw FlutterError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }
}
