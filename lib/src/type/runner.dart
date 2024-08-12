import 'package:flutter/widgets.dart';

import '../plugin/plugin_runtime.dart';

typedef AppRunner = Future<void> Function(Widget app);
typedef DebugMenuLauncher = Future<void> Function();
typedef PluginMetthodExecer = Future<dynamic> Function(
  String channel,
  String method, [
  dynamic arguments,
]);
typedef AppBuilder = Widget Function(
  BuildContext context,
  DebugMenuLauncher openDebugMenu,
  PluginMetthodExecer execPluginMethod,
);
typedef PluginList = List<EcosedRuntimePlugin> Function();
