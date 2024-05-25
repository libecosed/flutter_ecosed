import 'package:flutter/material.dart';

import '../widget/ecosed_inherited.dart';

extension EcosedContext on BuildContext {
  /// 调用插件方法
  Future<dynamic> execPluginMethod(String channel, String method) async {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return await inherited.executor(channel, method);
    } else {
      throw StateError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }

  /// 获取管理器控件
  Widget getManagerWidget() {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return inherited.manager;
    } else {
      throw StateError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }
}
