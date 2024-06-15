import 'package:flutter/widgets.dart';

import '../widget/ecosed_inherited.dart';

/// 调用框架功能的接口
extension EcosedInvoke on BuildContext {
  /// {@tool snippet}
  ///
  /// 调用插件方法
  ///
  /// ```dart
  /// context.execPluginMethod('example_plugin', 'hello');
  /// ```
  /// {@end-tool}
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return await inherited.executor(channel, method, arguments);
    } else {
      throw FlutterError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }

  /// {@tool snippet}
  ///
  /// 获取管理器控件
  ///
  /// ```dart
  /// context.getManagerWidget();
  /// ```
  /// {@end-tool}
  Widget getManagerWidget() {
    EcosedInherited? inherited =
        dependOnInheritedWidgetOfExactType<EcosedInherited>();
    if (inherited != null) {
      return inherited.manager;
    } else {
      throw FlutterError('请检查是否使用runEcosedApp方法启动应用!');
    }
  }
}
