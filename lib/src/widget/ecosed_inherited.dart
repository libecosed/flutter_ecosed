import 'package:flutter/widgets.dart';

/// 遗传接口
final class EcosedInherited extends InheritedWidget {
  const EcosedInherited({
    super.key,
    required this.executor,
    required this.manager,
    required super.child,
  });

  /// 执行插件方法
  final Future<dynamic> Function(
    String channel,
    String method, [
    dynamic arguments,
  ]) executor;

  /// 管理器界面
  final Widget manager;

  @override
  bool updateShouldNotify(EcosedInherited oldWidget) {
    return oldWidget.executor != executor || oldWidget.manager != manager;
  }
}
