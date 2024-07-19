import '../framework/context.dart';

/// 插件代理
abstract interface class EngineProxy {
  /// 创建引擎
  Future<void> onCreateEngine(Context context);

  /// 销毁引擎
  Future<void> onDestroyEngine();

  /// 执行方法
  Future<dynamic> onMethodCall(String methodProxy, [dynamic argumentsProxy]);
}
