import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../widget/manager.dart';

/// 运行时
final class EcosedRuntime extends EcosedBase {
  /// 应用程序
  late WidgetBuilder _app;

  /// 插件列表
  late List<EcosedPlugin> _plugins;

  /// 执行器
  late Future<void> Function(Widget app) _runner;

  /// 应用名称
  late String _appName;

  /// 应用版本
  late String _appVersion;

  /// 插件列表
  final List<EcosedPlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 方法通道平台代码调用Android平台独占
  final MethodChannel _methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final Map<String, String> _arguments = const {'channel': 'ecosed_engine'};

  /// 默认空模块JSON用于占位
  static const String _unknownPlugin = '{'
      '"channel":"unknown",'
      '"title":"unknown",'
      '"description":"unknown",'
      '"author":"unknown"'
      '}';

  /// 获取插件方法名
  static const String _getPluginMethod = 'get_plugins';

  /// 打开对话框方法名
  static const String _openDialogMethod = 'open_dialog';

  /// 关闭对话框方法名
  static const String _closeDialogMethod = 'close_dialog';

  /// 启动应用
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    // 赋值
    _app = app;
    _plugins = plugins;
    _runner = runner;
    // 初始化
    await _init();
    // 启动应用
    await _startup();
  }

  @override
  Widget build(BuildContext context) {
    return EcosedManager(
      appName: _appName,
      appVersion: _appVersion,
      openDialog: () => _exec(pluginChannel(), _openDialogMethod, true),
      closeDialog: () => _exec(pluginChannel(), _closeDialogMethod, true),
      pluginCount: _pluginCount(),
      pluginDetailsList: _pluginDetailsList,
      isAllowPush: (PluginDetails details) {
        return _isAllowPush(details);
      },
      isRuntime: (PluginDetails details) {
        return _isRuntime(details);
      },
      pluginWidget: (BuildContext context, PluginDetails details) {
        return _getPluginWidget(context: context, details: details);
      },
    );
  }

  @override
  Widget buildManager(BuildContext context) {
    for (var element in _pluginDetailsList) {
      if (_isRuntime(element)) {
        return _getPluginWidget(
          context: context,
          details: element,
        );
      }
    }
    return Container();
  }

  @override
  Future<dynamic> exec(String channel, String method, [arguments]) async {
    return await _exec(channel, method, false, arguments);
  }

  /// 插件通道
  @override
  String pluginChannel() => 'ecosed_runtime';

  /// 插件描述
  @override
  String pluginDescription() => 'FlutterEcosed框架运行时';

  /// 插件名称
  @override
  String pluginName() => 'EcosedRuntime';

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(String method, [dynamic _]) async {
    switch (method) {
      // 获取平台插件列表
      case _getPluginMethod:
        return await _getPlatformPluginList();
      // 打开平台对话框
      case _openDialogMethod:
        return await _openPlatformDialog();
      // 关闭平台对话框
      case _closeDialogMethod:
        return await _closePlatformDialog();
      // 其他值返回空
      default:
        return await null;
    }
  }

  /// 初始化运行时
  Future<void> _init() async {
    // 初始化Flutter相关
    await _initFlutter();
    // 初始化包信息
    await _initPackage();
    // 初始化运行时
    await _initRuntime();
    // 初始化平台层插件
    await _initPlatform();
    // 初始化普通插件
    await _initPlugins();
  }

  /// 启动应用
  Future<void> _startup() async {
    // 通过构建器运行应用
    return await super.runWithRunner(
      runner: _runner,
      child: super.builder(_app),
    );
  }

  /// 从引擎获取原生插件JSON
  Future<List?> _getPlatformPluginList() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await _methodChannel.invokeListMethod<String?>(
          'getPlugins',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => List.empty(),
      iOS: () async => List.empty(),
      linux: () async => List.empty(),
      macOS: () async => List.empty(),
      windows: () async => List.empty(),
    );
  }

  /// 从客户端启动对话框
  Future<bool?> _openPlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await _methodChannel.invokeMethod<bool?>(
          'openDialog',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async => await null,
    );
  }

  /// 关闭平台对话框
  Future<bool?> _closePlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await _methodChannel.invokeMethod<bool?>(
          'closeDialog',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async => await null,
    );
  }

  /// 根据平台执行
  Future<dynamic> _withPlatform({
    required Future<dynamic> Function() android,
    required Future<dynamic> Function() fuchsia,
    required Future<dynamic> Function() iOS,
    required Future<dynamic> Function() linux,
    required Future<dynamic> Function() macOS,
    required Future<dynamic> Function() windows,
  }) async {
    if (Platform.isAndroid) {
      return await android.call();
    } else if (Platform.isFuchsia) {
      return await fuchsia.call();
    } else if (Platform.isIOS) {
      return await iOS.call();
    } else if (Platform.isLinux) {
      return await linux.call();
    } else if (Platform.isMacOS) {
      return await macOS.call();
    } else if (Platform.isWindows) {
      return await windows.call();
    } else {
      return await null;
    }
  }

  /// 平台调用处理机制
  Future<dynamic> _invokeAndroid({
    required Future<dynamic> Function() invoke,
    required Future<dynamic> Function() error,
  }) async {
    if (Platform.isAndroid) {
      try {
        return await invoke.call();
      } on PlatformException {
        return await error.call();
      }
    }
    return await error.call();
  }

  /// 初始化Flutter相关组件
  Future<void> _initFlutter() async {
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// 初始化包信息
  Future<void> _initPackage() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用名称
    _appName = info.appName.isNotEmpty ? info.appName : "";
    // 获取应用版本
    String name = info.version.isNotEmpty ? info.version : "";
    String code = info.buildNumber.isNotEmpty ? "(${info.buildNumber})" : "";
    _appVersion = "$name\t$code";
  }

  /// 初始化运行时
  Future<void> _initRuntime() async {
    // 初始化运行时
    for (var element in [this]) {
      // 添加到内置插件列表
      _pluginList.add(element);
      // 添加到插件详细信息列表
      _pluginDetailsList.add(
        PluginDetails(
          channel: element.pluginChannel(),
          title: element.pluginName(),
          description: element.pluginDescription(),
          author: element.pluginAuthor(),
          type: PluginType.runtime,
        ),
      );
    }
  }

  /// 初始化平台层插件
  Future<void> _initPlatform() async {
    // 初始化平台插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel(), _getPluginMethod, true) as List? ??
              [_unknownPlugin])) {
        // 添加到插件详细信息列表
        _pluginDetailsList.add(
          PluginDetails.formJSON(
            json: jsonDecode(element),
            type: PluginType.platform,
          ),
        );
      }
    } on PlatformException {
      // 平台错误添加未知插件占位
      _pluginDetailsList.add(
        PluginDetails.formJSON(
          json: jsonDecode(_unknownPlugin),
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化普通插件
  Future<void> _initPlugins() async {
    if (_plugins.isNotEmpty) {
      for (var element in _plugins) {
        _pluginList.add(element);
        _pluginDetailsList.add(
          PluginDetails(
            channel: element.pluginChannel(),
            title: element.pluginName(),
            description: element.pluginDescription(),
            author: element.pluginAuthor(),
            type: PluginType.flutter,
          ),
        );
      }
    }
  }

  /// 执行插件方法
  Future<dynamic> _exec(
    String channel,
    String method,
    bool runtimeful, [
    dynamic arguments,
  ]) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (pluginChannel() == channel && !runtimeful) {
          continue;
        }
        if (element.pluginChannel() == channel) {
          return await element.onMethodCall(method, arguments);
        }
      }
    }
    return await null;
  }

  /// 判断插件是否为运行时
  bool _isRuntime(PluginDetails details) {
    return details.channel == pluginChannel();
  }

  /// 获取插件界面
  Widget _getPluginWidget({
    required BuildContext context,
    required PluginDetails details,
  }) {
    return _getPlugin(details)?.pluginWidget(context) ?? Container();
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        _getPlugin(details) != null;
  }

  /// 获取插件
  EcosedPlugin? _getPlugin(PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  /// 统计普通插件数量
  int _pluginCount() {
    var count = 0;
    for (var element in _pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        count++;
      }
    }
    return count;
  }
}
