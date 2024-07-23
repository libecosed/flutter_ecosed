import 'package:flutter/widgets.dart';

abstract class EcosedRuntimePlugin {
  ///插件通道
  String get pluginChannel;

  ///插件名称
  String get pluginName;

  ///插件描述
  String get pluginDescription;

  ///插件作者
  String get pluginAuthor;

  ///插件界面
  Widget pluginWidget(BuildContext context);

  ///方法调用
  Future<dynamic> onMethodCall(String method, [dynamic arguments]);
}
