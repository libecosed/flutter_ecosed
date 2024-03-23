library flutter_ecosed;

import 'package:flutter/material.dart';

abstract class EcosedPlugin {

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
  Future<Object?> onMethodCall(String name);
}
