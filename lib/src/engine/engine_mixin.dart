import 'package:flutter/widgets.dart';

import '../framework/context.dart';
import 'engine.dart';
import 'plugin_engine.dart';
import 'proxy.dart';

base mixin EngineMixin on EcosedEnginePlugin implements EngineProxy {
  final EcosedEngine engineScope = EcosedEngine()();

  @override
  Future<void> onCreateEngine(Context context, BuildContext buildContext) async {
    return await engineScope.onCreateEngine(context, buildContext);
  }

  @override
  Future<void> onDestroyEngine() async {
    return await engineScope.onDestroyEngine();
  }

  @override
  Future<dynamic> onMethodCall(
    String methodProxy, [
    dynamic argumentsProxy,
  ]) async {
    return await engineScope.onMethodCall(methodProxy, argumentsProxy);
  }
}
