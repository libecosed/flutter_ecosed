import 'package:flutter/material.dart';

abstract class EcosedPlugin extends StatefulWidget {
  const EcosedPlugin({super.key});

  ///插件信息
  String pluginChannel();

  ///插件名称
  String pluginName();

  ///插件描述
  String pluginDescription();

  ///插件作者
  String pluginAuthor();

  ///插件界面
  Widget pluginWidget() => this;

  ///初始化插件
  void onEcosedAdded() {}

  ///方法调用
  Object? onEcosedMethodCall(String name);
}
