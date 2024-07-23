import 'proxy.dart';

abstract interface class EngineWrapper implements EngineProxy {
  Future<dynamic> execMethodCall(
    String channel,
    String method, [
    dynamic arguments,
  ]);
}
