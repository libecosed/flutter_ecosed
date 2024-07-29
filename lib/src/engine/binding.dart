import 'package:flutter/widgets.dart';

import '../framework/context.dart';
import 'engine_wrapper.dart';

final class PluginBinding {
  const PluginBinding({
    required this.context,
    required this.buildContext,
    required this.engine,
  });

  final Context context;
  final BuildContext buildContext;
  final EngineWrapper engine;

  Context getContext() => context;
  BuildContext getBuildContext() => buildContext;
  EngineWrapper getEngine() => engine;
}
