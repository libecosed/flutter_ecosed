import '../plugin/plugin.dart';

abstract class EcosedAppWrapper {
  List<EcosedPlugin> initialPlugin();

  /// 调用插件方法
  Object? execPluginCall(String name);
}
