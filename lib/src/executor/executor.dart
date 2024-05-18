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
      throw StateError('executor builder is null');
    }
  }
}
