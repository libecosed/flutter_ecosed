import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';

abstract interface class ViewModelWrapper {
  /// 打开对话框
  Future<void> openDebugMenu();

  /// 统计普通插件数量
  int pluginCount();

  /// 打开PubDev
  Future<bool> launchPubDev();

  /// 获取插件列表
  List<PluginDetails> get getPluginDetailsList;

  /// 获取插件图标
  Widget getPluginIcon(PluginDetails details);

  /// 获取插件类型
  String getPluginType(PluginDetails details);

  /// 获取插件的动作名
  String getPluginAction(PluginDetails details);

  /// 获取插件的提示
  String getPluginTooltip(PluginDetails details);

  /// 打开卡片
  VoidCallback? openPlugin(PluginDetails details);

  String get getAppName;
  String get getAppVersion;
}
