import 'package:flutter_ecosed/src/engine/method_call.dart';
import 'package:flutter_ecosed/src/engine/plugin_engine.dart';
import 'package:flutter_ecosed/src/engine/result.dart';

final class ServiceDelegate extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'ecosed_delegate';

  @override
  String get description => '服务代理';

  @override
  String get title => 'ServiceDelegate';

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {}
}
