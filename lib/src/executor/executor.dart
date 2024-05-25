import 'package:flutter/material.dart';

import '../widget/ecosed_executor.dart';

/// 通过上下文调用插件方法
extension PluginExecutor on BuildContext {
  /// 调用插件方法
  Future<dynamic> execPluginMethod(String channel, String method) async {
    EcosedExecutor? executor =
        dependOnInheritedWidgetOfExactType<EcosedExecutor>();
    if (executor != null) {
      return await executor.exec(channel, method);
    } else {
      throw StateError('未找到执行器!请检查是否使用runEcosedApp方法启动应用');
    }
  }

  Widget getManagerWidget() {
    EcosedExecutor? executor =
        dependOnInheritedWidgetOfExactType<EcosedExecutor>();
    if (executor != null) {
      return executor.manager;
    } else {
      throw StateError('未找到执行器!请检查是否使用runEcosedApp方法启动应用');
    }
  }
}
