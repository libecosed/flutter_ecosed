import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/engine/engine_state.dart';

import '../plugin/plugin_details.dart';

abstract class EngineWrapper {
  /// 获取引擎状态
  EngineState getEngineState();

  /// 执行插件方法
  Future<dynamic> exec(String channel, String method);

  /// 打开对话框
  void openDialog(BuildContext context);

  /// 关闭对话框
  void closeDialog();

  /// 插件数量统计
  int pluginCount();

  /// 获取插件信息列表
  List<PluginDetails> getPluginDetailsList();

  /// 获取插件类型
  String getPluginType(PluginDetails details);

  /// 判断插件是否可以打开
  bool isAllowPush(PluginDetails details);

  /// 打开插件
  void launchPlugin(BuildContext context, PluginDetails details);
}
