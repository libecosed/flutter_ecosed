import 'package:flutter/widgets.dart';

import '../platform/platform_interface.dart';
import '../plugin/plugin_base.dart';

/// 启动应用
///
/// ```dart
/// await runEcosedApp(
///   app: const MyApp(),
///   plugins: const [ExamplePlugin()],
///   runner: (app) async => runApp(app),
/// );
/// ```
Future<void> runEcosedApp({
  required Widget app,
  required List<EcosedPlugin> plugins,
  required Future<void> Function(Widget app) runner,
}) async {
  return await EcosedInterface.instance.runEcosedApp(
    app: app,
    plugins: plugins,
    runner: runner,
  );
}

/// 实现插件的接口
///
/// ```dart
/// class ExamplePlugin implements EcosedBasePlugin {
///   const ExamplePlugin();
///
///   @override
///   String pluginAuthor() => 'ExampleAuthor';
///
///   @override
///   String pluginChannel() => 'example_channel';
///
///   @override
///   String pluginDescription() => 'Example description';
///
///   @override
///   String pluginName() => 'Example Plugin';
///
///   @override
///   Widget pluginWidget(BuildContext context) => const ExamplePluginPage();
///
///   @override
///   Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
///    switch (method) {
///       case 'method_name':
///         return arguments['argument_name'];
///       default:
///         return await null;
///     }
///   }
/// }
/// ```
/// ```dart
/// class ExamplePluginPage extends StatelessWidget {
///   const ExamplePluginPage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return const Center(
///       child: Text('Hello, World!'),
///     );
///   }
/// }
/// ```
abstract interface class EcosedPlugin extends BaseEcosedPlugin {}

/// 调用插件方法
///
/// ```dart
/// execPluginMethod('example_plugin', 'hello', {'name': 'value'});
/// ```
Future<dynamic> execPluginMethod(
  String channel,
  String method, [
  dynamic arguments,
]) async {
  return await EcosedInterface.instance.execPluginMethod(
    channel,
    method,
    arguments,
  );
}

/// 获取管理器控件
///
/// ```dart
/// getManagerWidget();
/// ```
Widget getManagerWidget() {
  return EcosedInterface.instance.getManagerWidget();
}
