library flutter_ecosed;

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
  Widget pluginWidget(BuildContext context) => this;

  ///方法调用
  Future<Object?> onMethodCall(String name);
}
