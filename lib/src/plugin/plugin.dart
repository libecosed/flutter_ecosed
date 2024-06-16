import 'package:flutter/widgets.dart';

/// {@tool snippet}
///
/// 实现插件的接口
///
/// ```dart
/// class ExamplePlugin implements EcosedPlugin {
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
/// 插件界面
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
abstract interface class EcosedPlugin {
  ///插件信息
  String pluginChannel();

  ///插件名称
  String pluginName();

  ///插件描述
  String pluginDescription();

  ///插件作者
  String pluginAuthor();

  ///插件界面
  Widget pluginWidget(BuildContext context);

  ///方法调用
  Future<dynamic> onMethodCall(String method, [dynamic arguments]);
}
