import 'engine_bridge.dart';
import 'plugin_engine.dart';
import 'service_delegate.dart';
import 'service_invoke.dart';

base mixin PluginMixin {
  /// 插件列表
  List<EcosedEnginePlugin> get plugins => [
        EngineBridge(),
        ServiceInvoke(),
        ServiceDelegate(),
      ];
}
