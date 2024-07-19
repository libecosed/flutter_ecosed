import 'method_call.dart';
import 'result.dart';
import 'engine_mixin.dart';
import 'proxy.dart';
import 'plugin_engine.dart';

final class EngineBridge extends EcosedEnginePlugin
    with EngineMixin
    implements EngineProxy {
  /// 插件入口
  EngineBridge call() => this;

  /// 插件作者
  @override
  String get author => 'wyq0918dev';

  /// 插件通道
  @override
  String get channel => 'engine_bridge';

  /// 插件描述
  @override
  String get description => '引擎桥接';

  /// 插件名称
  @override
  String get title => 'EngineBridge';

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    return await null;
  }
}
