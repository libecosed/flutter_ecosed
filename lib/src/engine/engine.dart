import 'dart:async';
import 'dart:convert';

import '../framework/framework.dart';
import '../values/banner.dart';
import 'binding.dart';
import 'channel.dart';
import 'engine_mixin.dart';
import 'engine_wrapper.dart';
import 'method_call.dart';
import 'proxy.dart';
import 'result.dart';
import 'tag.dart';

abstract base class EcosedFrameworkPlugin extends ContextWrapper {
  late PluginChannel _pluginChannel;
  late EngineWrapper _engine;

  /// 插件添加时执行
  Future<void> onEcosedAdded(PluginBinding binding) async {
    // 初始化插件通道
    _pluginChannel = PluginChannel(binding: binding, channel: channel);
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
  Future<void> onEcosedMethodCall(EcosedMethodCall call, EcosedResult result);

  /// 执行插件方法
  Future<dynamic> execPluginMethod(String channel, String method,
      [dynamic arguments]) async {
    return await _engine.execMethodCall(channel, method, arguments);
  }
}

final class EngineBridge extends EcosedFrameworkPlugin
    with EngineMixin
    implements PluginProxy {
  EngineBridge call() => this;

  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_bridge';

  @override
  String get description => 'engine bridge';

  @override
  String get title => 'EngineBridge';

  @override
  Future<void> onEcosedMethodCall(call, result) async => await null;
}

final class EcosedEngine extends EcosedFrameworkPlugin
    with PluginMixin
    implements EngineWrapper {
  EcosedEngine();

  /// 引擎入口函数
  EcosedEngine call() => this;

  /// 引擎初始化状态
  bool initialized = false;

  /// 差劲列表
  final List<EcosedFrameworkPlugin> _pluginList = [];

  /// 插件信息列表
  final List<Map<String, dynamic>> _infoList = [];

  /// 插件绑定
  late PluginBinding _binding;

  /// 插件作者
  @override
  String get author => 'wyq0918dev';

  /// 插件通道
  @override
  String get channel => 'ecosed_engine';

  /// 插件描述
  @override
  String get description => 'EcosedEngine';

  /// 插件名称
  @override
  String get title => 'EcosedEngine';

  /// 调用插件方法
  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    switch (call.method) {
      case 'get_plugins':
        result.success(_infoList);
        break;
      default:
        result.notImplemented();
    }
  }

  @override
  Future<void> onCreateEngine(Context context) async {
    if (initialized == false) {
      // 打印横幅
      Log.d(tag, '\n${utf8.decode(base64Decode(banner))}');
      // 初始化绑定
      _binding = PluginBinding(context: context, engine: this);
      // 遍历插件列表
      for (var element in [this, ...plugins]) {
        // 加载插件
        try {
          await element.onEcosedAdded(_binding);
          Log.d(tag, '插件${element.channel}已加载');
        } catch (e) {
          Log.d(tag, '插件${element.channel}添加失败!\n$e');
        }
        // 将插件添加进列表
        _pluginList.add(element);
        _infoList.add(
          {
            'channel': element.channel,
            'title': element.title,
            'description': element.description,
            'author': element.author
          },
        );
        // 打印提示
        Log.d(tag, '插件${element.channel}已添加到插件列表');
      }
      // 将引擎状态设为已加载
      initialized = true;
    } else {
      // 打印提示
      Log.d(tag, '请勿重复执行onCreateEngine!');
    }
  }

  @override
  Future<void> onDestroyEngine() async {
    if (initialized == true) {
      _pluginList.clear();
      _infoList.clear();
    } else {
      Log.d(tag, '请勿重复执行onDestroyEngine!');
    }
  }

  @override
  Future<dynamic> onMethodCall(
    String methodProxy, [
    dynamic argumentsProxy,
  ]) async {
    return await execMethodCall(
      argumentsProxy['channel'],
      methodProxy,
      argumentsProxy,
    );
  }

  @override
  Future<dynamic> execMethodCall(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    dynamic result;
    try {
      for (var element in _pluginList) {
        if (element.getPluginChannel.getChannel() == channel) {
          result = await element.getPluginChannel.execMethodCall(
            channel,
            method,
            arguments,
          );
          Log.d(
            tag,
            '插件代码调用成功!\n'
            '通道名称:$channel.\n'
            '方法名称:$method.\n'
            '返回结果:$result.',
          );
        }
      }
    } catch (exception) {
      Log.d(tag, '插件代码调用失败!\n$exception');
    }
    return await result;
  }
}

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
