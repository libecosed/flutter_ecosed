import 'package:flutter/material.dart';

import '../app/app_type.dart';

/// 执行器构建器
class EcosedExecutor extends InheritedWidget {
  const EcosedExecutor({
    super.key,
    required this.exec,
    required this.manager,
    required super.child,
  });

  final EcosedExec exec;
  final Widget manager;

  @override
  bool updateShouldNotify(EcosedExecutor oldWidget) {
    return oldWidget.exec != exec && oldWidget.manager != manager;
  }
}
