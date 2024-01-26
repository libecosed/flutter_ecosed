import 'package:flutter_ecosed/flutter_ecosed.dart';

abstract class EngineWrapper {
  List<EcosedPlugin> initialPlugin();
  /// 调用插件方法
  Object? execPluginCall(String name);
}
