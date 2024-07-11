import '../framework/framework.dart';

abstract interface class PluginProxy {
  Future<void> onCreateEngine(Context context);
  Future<void> onDestroyEngine();

  Future<dynamic> onMethodCall(String methodProxy, [dynamic argumentsProxy]);
}
