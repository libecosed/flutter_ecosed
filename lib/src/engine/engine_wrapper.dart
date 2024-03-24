/// Copyright flutter_ecosed
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///   http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
library flutter_ecosed;

import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/engine/engine_state.dart';

import '../plugin/plugin_details.dart';

abstract class EngineWrapper {
  /// 获取引擎状态
  EngineState getEngineState();

  /// 执行插件方法
  Future<Object?> exec(String channel, String method);

  /// 打开对话框
  void openDialog(BuildContext context);

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
