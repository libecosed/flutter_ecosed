import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_ecosed/src/plugin/binding.dart';

class PluginChannel {
  PluginChannel(this.binding, this.channel);

  final PluginBinding binding;
  final String channel;

  late EcosedPlugin _plugin;
  late String _method;


  void setMethodCallHandler(EcosedPlugin handler) {
    _plugin = handler;
  }

  void execMethodCall(String name, String method) {
    _method = method;
    if (name == channel) {
      _plugin.onEcosedMethodCall();
    }
  }
}