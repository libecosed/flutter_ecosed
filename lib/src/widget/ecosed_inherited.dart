import 'package:flutter/widgets.dart';

/// 遗传接口
final class EcosedInherited extends InheritedWidget {
  const EcosedInherited({
    super.key,
    required this.executor,
    required this.manager,
    required super.child,
  });

  final Future<dynamic> Function(String channel, String method) executor;
  final Widget manager;

  @override
  bool updateShouldNotify(EcosedInherited oldWidget) {
    return oldWidget.executor != executor || oldWidget.manager != manager;
  }
}
