import '../framework/context.dart';
import 'binding.dart';
import 'call_impl.dart';
import 'engine_wrapper.dart';
import 'plugin_engine.dart';
import 'result_impl.dart';

final class PluginChannel {
  PluginChannel({
    required this.binding,
    required this.channel,
  });

  final PluginBinding binding;
  final String channel;

  EcosedEnginePlugin? _plugin;
  String? _method;
  dynamic _arguments;
  dynamic _result;

  void setMethodCallHandler(EcosedEnginePlugin handler) {
    _plugin = handler;
  }

  Context getContext() => binding.getContext();
  String getChannel() => channel;
  EngineWrapper getEngine() => binding.getEngine();

  Future<dynamic> execMethodCall(
    String name,
    String method, [
    dynamic arguments,
  ]) async {
    _method = method;
    _arguments = arguments;
    if (name == channel) {
      await _plugin?.onEcosedMethodCall(
        CallImport(
          callMethod: _method,
          callArguments: _arguments,
        ),
        ResultImport(
          callback: (result) async {
            _result = result;
          },
        ),
      );
    }
    return await _result;
  }
}
