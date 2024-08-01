import 'plugin_engine.dart';
import 'engine_embedded.dart';

base mixin PluginMixin {
  /// 插件列表
  List<EcosedEnginePlugin> get plugins => [EngineEmbedded()];
}
