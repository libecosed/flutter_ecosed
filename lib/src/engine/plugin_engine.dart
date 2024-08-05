import '../framework/context_wrapper.dart';
import 'binding.dart';
import 'channel.dart';
import 'engine_wrapper.dart';
import 'method_call.dart';
import 'result.dart';

abstract base class EcosedEnginePlugin extends ContextWrapper {
  EcosedEnginePlugin() : super(attach: false);
  late PluginChannel _pluginChannel;
  late EngineWrapper _engine;

  /// 插件添加时执行
  Future<void> onEcosedAdded(
    PluginBinding binding,
  ) async {
    // 初始化插件通道
    _pluginChannel = PluginChannel(
      binding: binding,
      channel: channel,
    );
    // 附加基础上下文
    attachBaseContext(_pluginChannel.getContext());
    // 获取引擎
    _engine = _pluginChannel.getEngine();
    // 设置方法回调
    _pluginChannel.setMethodCallHandler(this);
  }

  /// 获取插件通道
  PluginChannel get getPluginChannel => _pluginChannel;

  /// 插件标题
  String get title;

  /// 插件通道
  String get channel;

  /// 插件作者
  String get author;

  /// 插件描述
  String get description;

  /// 执行插件方法
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  );

  /// 执行插件方法
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await _engine.execMethodCall(
      channel,
      method,
      arguments,
    );
  }
}
