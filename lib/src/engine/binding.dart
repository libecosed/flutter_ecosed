import '../framework/context.dart';
import 'engine_wrapper.dart';

final class PluginBinding {
  const PluginBinding({
    required this.context,
    required this.engine,
  });

  /// 上下文
  final Context context;

  /// 引擎
  final EngineWrapper engine;

  /// 获取上下文
  Context getContext() => context;

  /// 获取引擎
  EngineWrapper getEngine() => engine;
}
