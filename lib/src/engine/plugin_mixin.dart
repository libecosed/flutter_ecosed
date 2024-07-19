import 'package:flutter_ecosed/src/engine/service_invoke.dart';

import 'engine_bridge.dart';
import '../plugin/engine/plugin_engine.dart';

base mixin PluginMixin {
  /// 插件列表
  List<EcosedEnginePlugin> get plugins => [EngineBridge(), ServiceInvoke()];
}
