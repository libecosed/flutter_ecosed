import '../../framework/context.dart';
import '../../engine/engine_wrapper.dart';

final class PluginBinding {
  const PluginBinding({
    required this.context,
    required this.engine,
  });

  final Context context;
  final EngineWrapper engine;

  Context getContext() => context;
  EngineWrapper getEngine() => engine;
}
