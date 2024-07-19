import 'package:flutter/widgets.dart';

import '../interface/ecosed_interface.dart';
import '../plugin/plugin_runtime.dart';

/// 绑定层包装器
abstract interface class BaseWrapper {
  /// 运行时入口
  EcosedInterface call();

  /// 绑定层插件
  EcosedRuntimePlugin get base;

  /// 管理器布局
  Widget build(BuildContext context);

  /// 获取管理器
  Widget buildManager(BuildContext context);

  /// 执行插件方法
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]);

  /// 使用运行器运行
  Future<void> runWithRunner({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Future<void> Function(Widget app) runner,
  });

  Future<dynamic> execFramework(
    String method, [
    dynamic arguments,
  ]);
}
