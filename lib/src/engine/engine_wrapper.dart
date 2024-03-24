library flutter_ecosed;

import 'package:flutter/material.dart';

import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';

abstract class EngineWrapper {
  /// 内置插件列表
  List<EcosedPlugin> initialPlugin();
  Future<Object?> exec(String channel, String method);
  void openDialog(BuildContext context);
  String pluginCount();
  List<PluginDetails> getPluginDetailsList();
  String getPluginType(PluginDetails details);
  bool isAllowPush(PluginDetails details);
  void launchPlugin(BuildContext context, PluginDetails details);
}
