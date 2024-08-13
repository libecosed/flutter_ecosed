import '../embedder/platform_embedder.dart';
import 'plugin_engine.dart';
import 'engine_embedder.dart';

base mixin PluginMixin {
  /// 插件列表
  List<EcosedEnginePlugin> get plugins => [
        EngineEmbedder(),
        ServiceInvoke(),
        ServiceDelegate(),
      ];
}
