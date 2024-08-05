import 'package:flutter/widgets.dart';

import '../entry/ecosed_entry.dart';
import '../interface/ecosed_interface.dart';
import '../plugin/plugin_runtime.dart';
import '../type/runner.dart';

/// 注册 flutter_ecosed 插件
///
/// 此方法用于通过注册器向Flutter框架注册此插件.
/// 插件注册由Flutter框架接管, 请勿手动注册.
void registerEcosed() => EcosedInterface.instance = EcosedEntry();

/// 实现插件的接口
///
/// ```dart
/// class ExamplePlugin implements EcosedPlugin {
///   const ExamplePlugin();
///
///   // 插件的通道名
///   //
///   // 此值为插件的唯一标识符, 不可重复.
///   // 插件的通道名称会在管理器的插件列表中显示.
///   @override
///   String get pluginChannel => 'example_channel';
///
///   // 插件的名称
///   //
///   // 插件的名称会在管理器的插件列表中显示.
///   @override
///   String get pluginName => '示例插件';
///
///   // 对插件的描述
///   //
///   // 插件的描述会在管理器的插件列表中显示.
///   @override
///   String get pluginDescription => '演示如何使用Ecosed插件';
///
///   // 插件的作者
///   //
///   // 插件的作者会在管理器的插件列表中显示.
///   @override
///   String get pluginAuthor => 'wyq0918dev';
///
///   // 插件的界面
///   //
///   // 单击管理器插件列表中相应的插件卡片中右下角的“打开”按钮会打开新的页面并显示此布局.
///   // 新的页面中已带有AppBar, 不建议重复使用, AppBar的标题为插件的名称.
///   @override
///   Widget pluginWidget(BuildContext context) {
///     return const Center(
///       child: Text('Hello Example Plugin!'), // Text
///     ); // Center
///   }
///
///   // 调用插件方法时执行的函数
///   //
///   // [method] 为要调用的方法的名称, 一般通过此值使用switch语法判断要执行的代码.
///   // [arguments] 为调用方法时传递的参数, 一般直接使用Map的arguments['参数名']语法即可.
///   @override
///   Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
///     switch (method) {
///       case 'method_name':
///         return arguments['argument_name'];
///       default:
///         return await null;
///     }
///   }
/// }
/// ```
abstract interface class EcosedPlugin extends EcosedRuntimePlugin {}

/// 启动应用
///
/// 需要将入口函数main的void类型改为Future<void>并添加async标签转为异步函数.
///
/// [app] 传入的是
///
/// ```dart
/// Future<void> main() async {
///   // ... 省略不相关代码
///   await runEcosedApp(
///     app: const MyApp(),
///     plugins: const <EcosedPlugin>[ExamplePlugin()],
///     runner: (app) async => runApp(app),
///   );
///   // ... 省略不相关代码
/// }
/// ```
Future<void> runEcosedApp({
  required Widget app,
  required List<EcosedPlugin> plugins,
  required Runner runner,
}) async =>
    await EcosedInterface.instance.runEcosedApp(
      app,
      plugins,
      runner,
    );

/// 调用插件方法
///
/// ```dart
/// execPluginMethod('example_plugin', 'hello', {'name': 'value'});
/// ```
Future<dynamic> execPluginMethod(
  String channel,
  String method, [
  dynamic arguments,
]) async =>
    await EcosedInterface.instance.execPluginMethod(
      channel,
      method,
      arguments,
    );

/// 打开调试菜单
///˝
/// ```dart
/// await openDebugMenu();
/// ```
Future<void> openDebugMenu() async => EcosedInterface.instance.openDebugMenu();

// /// 获取管理器控件
// ///
// /// ```dart
// /// getManagerWidget();
// /// ```
// Widget getManagerWidget() {
//   return EcosedInterface.instance.getManagerWidget();
// }
