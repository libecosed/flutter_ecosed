import 'proxy.dart';

abstract interface class EngineWrapper implements PluginProxy {
  Future<dynamic> execMethodCall(String channel, String method,
      [dynamic arguments]);
}
