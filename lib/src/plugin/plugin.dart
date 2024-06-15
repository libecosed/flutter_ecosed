import 'package:flutter/widgets.dart';

/// 实现插件的接口
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
