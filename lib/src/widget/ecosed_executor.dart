import 'package:flutter/material.dart';

import '../app/app_type.dart';

/// 执行器构建器
class EcosedExecutor extends InheritedWidget {
  const EcosedExecutor({
    super.key,
    required this.exec,
    required super.child,
  });

  final EcosedExec exec;

  @override
  bool updateShouldNotify(EcosedExecutor oldWidget) {
    return oldWidget.exec != exec;
  }
}
