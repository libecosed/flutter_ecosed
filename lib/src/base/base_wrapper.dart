import 'package:flutter/material.dart';

import '../interface/ecosed_interface.dart';
import '../plugin/plugin_runtime.dart';

/// 绑定层包装器
abstract interface class BaseWrapper {
  /// 运行时入口
  EcosedInterface call();

  /// 绑定层插件
  EcosedRuntimePlugin get base;

  /// 执行引擎插件方法
  Future<dynamic> execEngine(
    String method, [
    dynamic arguments,
  ]);

  /// 使用运行器运行
  Future<void> runWithRunner({
    required Widget app,
    required Future<void> Function(Widget app) runner,
  });

  /// 获取导航主机上下文
  BuildContext get host;

  /// 打开管理器
  Future<dynamic> launchManager();

  /// 执行插件方法
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]);

  /// 获取管理器
  Widget buildManager(BuildContext context);
  

  ChangeNotifier buildViewModel(BuildContext context);

  //TODO launchDialog

  /// 管理器布局
  Widget build(BuildContext context);
}
