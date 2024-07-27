import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';

typedef PluginGetter = EcosedRuntimePlugin? Function(
  PluginDetails details,
);
