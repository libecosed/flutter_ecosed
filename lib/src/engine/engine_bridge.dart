import 'engine_mixin.dart';
import 'proxy.dart';
import 'plugin.dart';

final class EngineBridge extends EcosedFrameworkPlugin
    with EngineMixin
    implements PluginProxy {
  EngineBridge call() => this;

  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_bridge';

  @override
  String get description => 'engine bridge';

  @override
  String get title => 'EngineBridge';

  @override
  Future<void> onEcosedMethodCall(call, result) async => await null;
}
