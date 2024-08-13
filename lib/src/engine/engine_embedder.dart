import 'dart:async';

import '../embedder/platform_embedder.dart';
import '../framework/want.dart';
import 'binding.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

final class EngineEmbedder extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_embedder';

  @override
  String get description => '服务嵌入';

  @override
  String get title => 'EngineEmbedder';

  /// 服务实例
  late PlatformEmbedder _embedder;

  @override
  Future<void> onEcosedAdded(PluginBinding binding) async {
    return await super.onEcosedAdded(binding).then((added) {
      final Want want = Want(classes: PlatformEmbedder());
      final EmbedderConnection connect = EmbedderConnection(
        calback: (embedder) => _embedder = embedder,
      );
      startService(want);
      bindService(want, connect);
      return added;
    });
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    switch (call.method) {
      case 'getPlugins':
        result.success(_embedder.getPlatformPluginList());
      case 'openDialog':
        result.success(_embedder.openPlatformDialog());
      case 'closeDialog':
        result.success(_embedder.closePlatformDialog());
      default:
        result.notImplemented();
    }
  }
}
