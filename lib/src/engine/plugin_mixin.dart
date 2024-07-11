import 'method_call.dart';
import 'plugin.dart';
import 'result.dart';

base mixin PluginMixin {
  /// 插件列表
  List<EcosedFrameworkPlugin> plugins = [Example()];
}

final class Example extends EcosedFrameworkPlugin {
  @override
  String get author => 'exeample';

  @override
  String get channel => 'example';

  @override
  String get description => 'example';

  @override
  String get title => 'example';

  @override
  Future<void> onEcosedMethodCall(
      EcosedMethodCall call, EcosedResult result) async {}
}
