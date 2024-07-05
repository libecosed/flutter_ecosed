import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../framework/framework.dart';

abstract interface class FlutterPluginProxy {
  void onCreateEngine(Context context);
  void onDestroyEngine();

  void onMethodCall(
    MethodCallProxy call,
    ResultProxy result,
  );
}

abstract interface class MethodCallProxy {
  String get methodProxy;
  dynamic get argumentsProxy;
}

abstract interface class ResultProxy {
  void success(dynamic result);
  void error(String errorCode, String? errorMessage, dynamic errorDetails);
  void notImplemented();
}

abstract interface class EcosedMethodCall {
  String? get method;
  dynamic get arguments;
}

abstract interface class EcosedResult {
  void success(dynamic result);
  void error(String errorCode, String? errorMessage, dynamic errorDetails);
  void notImplemented();
}

abstract base class EcosedFrameworkPlugin extends ContextWrapper {
  late PluginChannel _pluginChannel;
  late EngineWrapper _engine;

  void onEcosedAdded(PluginBinding binding) {
    _pluginChannel = PluginChannel(binding: binding, channel: channel);
    attachBaseContext(_pluginChannel.getContext());
    _engine = _pluginChannel.getEngine();
    _pluginChannel.setMethodCallHandler(this);
  }

  PluginChannel get getPluginChannel => _pluginChannel;
  String get title;
  String get channel;
  String get author;
  String get description;

  Future<void> onEcosedMethodCall(EcosedMethodCall call, EcosedResult result);

  Future<dynamic> execPluginMethod(String channel, String method,
      [dynamic arguments]) async {
    return await _engine.execMethodCall(channel, method, arguments);
  }
}

abstract interface class EngineWrapper implements FlutterPluginProxy {
  Future<dynamic> execMethodCall(String channel, String method,
      [dynamic arguments]);
}

final class PluginBinding {
  const PluginBinding({
    required this.context,
    required this.engine,
  });

  final Context context;
  final EngineWrapper engine;

  Context getContext() => context;
  EngineWrapper getEngine() => engine;
}

final class PluginChannel {
  PluginChannel({
    required this.binding,
    required this.channel,
  });

  final PluginBinding binding;
  final String channel;

  EcosedFrameworkPlugin? _plugin;
  String? _method;
  dynamic _arguments;

  dynamic _result;

  void setMethodCallHandler(EcosedFrameworkPlugin handler) {
    _plugin = handler;
  }

  Context getContext() => binding.getContext();
  String getChannel() => channel;
  EngineWrapper getEngine() => binding.getEngine();

  Future<dynamic> execMethodCall(
    String name,
    String method, [
    dynamic arguments,
  ]) async {
    _method = method;
    _arguments = arguments;
    if (name == channel) {
      await _plugin?.onEcosedMethodCall(
        Call(
          callMethod: _method,
          callArguments: _arguments,
        ),
        Result(
          successCallBack: (result) {
            _result = result;
          },
        ),
      );
    }
    return await _result;
  }
}

final class Call implements EcosedMethodCall {
  const Call({
    required this.callMethod,
    required this.callArguments,
  });

  final String? callMethod;
  final String callArguments;

  @override
  String? get method => callMethod;

  @override
  dynamic get arguments => callArguments;
}

final class Result implements EcosedResult {
  const Result({
    required this.successCallBack,
  });

  final Function(dynamic result) successCallBack;

  @override
  void success(dynamic result) => successCallBack(result);

  @override
  void error(
    String errorCode,
    String? errorMessage,
    dynamic errorDetails,
  ) {
    throw FlutterError(
      '错误代码:$errorCode\n'
      '错误消息:$errorMessage\n'
      '详细信息:$errorDetails',
    );
  }

  @override
  void notImplemented() {
    throw UnimplementedError();
  }
}

mixin BridgeMixin {
  EngineBridge bridgeScope = EngineBridge()();
}

final class EngineBridge extends EcosedFrameworkPlugin
    with EngineMixin
    implements FlutterPluginProxy {
  EngineBridge call() => this;
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_bridge';

  @override
  String get description => 'engine bridge';

  @override
  String get title => 'EngineBridge';
}

base mixin EngineMixin on EcosedFrameworkPlugin implements FlutterPluginProxy {
  final EcosedEngine engineScope = EcosedEngine()();

  @override
  void onCreateEngine(Context context) {
    return engineScope.onCreateEngine(context);
  }

  @override
  void onDestroyEngine() {
    return engineScope.onDestroyEngine();
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    return await engineScope.onEcosedMethodCall(call, result);
  }

  @override
  void onMethodCall(MethodCallProxy call, ResultProxy result) {
    return engineScope.onMethodCall(call, result);
  }
}

final class EcosedEngine extends EcosedFrameworkPlugin
    with PluginMixin
    implements EngineWrapper {
  EcosedEngine();

  /// 引擎入口函数
  EcosedEngine call() => this;

  /// 引擎初始化状态
  bool initialized = false;
  late List<EcosedFrameworkPlugin> _pluginList;
  late List<Map<String, String>> _infoList;
  late PluginBinding _binding;

  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'ecosed_engine';

  @override
  String get description => 'EcosedEngine';

  @override
  String get title => 'EcosedEngine';

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
  void onCreateEngine(Context context) {
    if (initialized == false) {
      // 打印横幅
      debugPrint('');
      // 初始化列表
      _pluginList = [];
      _infoList = [];
      // 遍历插件列表
      for (var element in plugins) {
        // 加载插件
        try {
          element.onEcosedAdded(_binding);
          debugPrint('插件${element.channel}已加载');
        } catch (e) {
          debugPrint('插件${element.channel}添加失败!\n$e');
          
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
        debugPrint('插件${element.channel}已添加到插件列表');
      }
      // 将引擎状态设为已加载
      initialized = true;
    } else {
      // 打印提示
      debugPrint('请勿重复执行onCreateEngine!');
    }
  }

  @override
  void onDestroyEngine() {
    if (initialized == true) {
      _pluginList = [];
      _infoList = [];
    } else {
      debugPrint('请勿重复执行onDestroyEngine!');
    }
  }

  @override
  void onMethodCall(
    MethodCallProxy call,
    ResultProxy result,
  ) {
    try {
      result.success(execMethodCall(call.argumentsProxy['channel'],
          call.methodProxy, call.argumentsProxy));
    } catch (e) {
      result.error('flutter_ecosed', 'engine: onMethodCall', e);
    }
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
          debugPrint(
            '插件代码调用成功!\n'
            '通道名称:$channel.\n'
            '方法名称:$method.\n'
            '返回结果:$result.',
          );
        }
      }
    } catch (e) {
      debugPrint('插件代码调用失败!\n$e');
    }
    return await result;
  }
}

mixin PluginMixin {
  List<EcosedFrameworkPlugin> plugins = [
    EngineBridge(),
    EcosedEngine(),
  ];
}
