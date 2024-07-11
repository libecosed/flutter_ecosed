import '../framework/framework.dart';
import 'engine.dart';
import 'proxy.dart';

base mixin EngineMixin on EcosedFrameworkPlugin implements PluginProxy {
  final EcosedEngine engineScope = EcosedEngine()();

  @override
  Future<void> onCreateEngine(Context context) async {
    return await engineScope.onCreateEngine(context);
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
