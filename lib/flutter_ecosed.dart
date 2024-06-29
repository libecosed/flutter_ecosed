/// 平台插件注册及外部访问接口
library flutter_ecosed;

import 'package:flutter/widgets.dart';

import 'src/platform/platform_entry.dart';
import 'src/platform/platform_interface.dart';
import 'src/plugin/plugin_base.dart';

/// 平台插件注册
/// 插件注册由Flutter接管,无需手动注册.
final class EcosedPlatformRegister {
  const EcosedPlatformRegister();

  /// 注册插件
  /// 插件注册由Flutter接管,无需手动注册.
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}

/// 启动应用
///
/// {@tool snippet}
/// ```dart
/// await runEcosedApp(
///   app: const MyApp(),
///   plugins: const [ExamplePlugin()],
///   runner: (app) async => runApp(app),
/// );
/// ```
/// {@end-tool}
Future<void> runEcosedApp({
  required Widget app,
  required List<EcosedPlugin> plugins,
  required Future<void> Function(Widget app) runner,
}) async {
  return await EcosedPlatformInterface.instance.runEcosedApp(
    app: app,
    plugins: plugins,
    runner: runner,
  );
}

/// 实现插件的接口
///
/// {@tool snippet}
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
/// {@end-tool}
abstract interface class EcosedPlugin extends BaseEcosedPlugin {}

/// 调用插件方法
///
/// {@tool snippet}
/// ```dart
/// execPluginMethod('example_plugin', 'hello', {'name': 'value'});
/// ```
/// {@end-tool}
Future<dynamic> execPluginMethod(
  String channel,
  String method, [
  dynamic arguments,
]) async {
  return await EcosedPlatformInterface.instance.execPluginMethod(
    channel,
    method,
    arguments,
  );
}

/// 获取管理器控件
///
/// {@tool snippet}
/// ```dart
/// getManagerWidget();
/// ```
/// {@end-tool}
Widget getManagerWidget() {
  return EcosedPlatformInterface.instance.getManagerWidget();
}
