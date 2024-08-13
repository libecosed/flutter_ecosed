import '../base/base_wrapper.dart';
import '../plugin/plugin_runtime.dart';
import 'platform_embedder.dart';

base mixin EmbedderMixin implements BaseWrapper {
  @override
  EcosedRuntimePlugin get embedder => PlatformEmbedder();
}
