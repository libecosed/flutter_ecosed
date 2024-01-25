import 'package:flutter/material.dart';

import 'binding.dart';

abstract class EcosedPlugin extends StatefulWidget {
  const EcosedPlugin({super.key});

  ///插件信息
  String pluginChannel();
  String pluginName();
  String pluginDescription();
  String pluginAuthor();

  ///插件界面
  Widget pluginWidget() => this;

  ///初始化插件
  void onEcosedAdded(PluginBinding binding){

  }

  ///方法调用
  void onEcosedMethodCall(){}

}
