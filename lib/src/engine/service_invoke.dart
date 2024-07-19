import 'package:flutter_ecosed/src/plugin/engine/method_call.dart';
import 'package:flutter_ecosed/src/plugin/engine/plugin_engine.dart';
import 'package:flutter_ecosed/src/plugin/engine/result.dart';

final class ServiceInvoke extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'service_invoke';

  @override
  String get description => '服务调用';

  @override
  String get title => 'ServiceInvoke';

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {}
}
