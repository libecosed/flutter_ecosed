import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../type/runner.dart';
import '../values/placeholder.dart';
import '../widget/manager.dart';

/// 运行时
final class EcosedRuntime extends EcosedBase {
  /// 应用名称
  late String _appName;

  /// 应用版本
  late String _appVersion;

  /// 插件列表
  final List<EcosedRuntimePlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 启动应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Runner runner,
  }) async {
    // 执行父类代码
    await super.runEcosedApp(
      app: app,
      plugins: plugins,
      runner: runner,
    );
    // 初始化
    await _init(
      plugins: plugins,
    );
    // 启动应用
    return await super.runWithRunner(
      app: app,
      runner: runner,
    );
  }

  /// 打开调试菜单
  @override
  Future<void> openDebugMenu() async {
    showDialog(
      context: super.host,
      useRootNavigator: false,
      builder: (context) => SimpleDialog(
        title: const Text('调试菜单'),
        children: <SimpleDialogOption>[
          SimpleDialogOption(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: const Text('关闭'),
              leading: const FlutterLogo(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              enabled: true,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: const Text('管理器'),
              leading: const FlutterLogo(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              enabled: true,
              onTap: () async {
                await super.launchManager();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 插件通道
  @override
  String get pluginChannel => 'ecosed_runtime';

  /// 插件描述
  @override
  String get pluginDescription => 'FlutterEcosed框架运行时';

  /// 插件名称
  @override
  String get pluginName => 'EcosedRuntime';

  /// 管理器布局
  @override
  Widget build(BuildContext context) {
    return EcosedManager(
      appName: _appName,
      appVersion: _appVersion,
      pluginDetailsList: _pluginDetailsList,
      getPlugin: _getPlugin,
      getPluginWidget: _getPluginWidget,
      host: super.host,
      isRuntime: _isRuntime,
      openDebugMenu: openDebugMenu,
    );
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    for (var element in _pluginDetailsList) {
      if (_isRuntime(element)) {
        return _getPluginWidget(context, element);
      }
    }
    return super.buildManager(context);
  }

  /// 执行插件方法
  @override
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await _exec(
      channel,
      method,
      false,
      arguments,
    );
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
    switch (method) {
      case 'get_plugins':
        return await super.execEngine(
          'get_plugins',
          {'channel': 'ecosed_engine'},
        );
      default:
        return await null;
    }
  }

  /// 初始化运行时
  Future<void> _init({
    required List<EcosedRuntimePlugin> plugins,
  }) async {
    // 初始化包信息
    await _initPackage();
    // 初始化运行时
    await _initRuntime();

    await _initFramework();

    // 初始化普通插件
    await _initPlugins(plugins: plugins);

    await super.execEngine(
      'test',
      {'channel': 'engine_embedded'},
    );
  }

  /// 初始化包信息
  Future<void> _initPackage() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用名称
    _appName = info.appName.isNotEmpty ? info.appName : "未知";
    // 获取应用版本
    String name = info.version.isNotEmpty ? info.version : "未知";
    String code = info.buildNumber.isNotEmpty ? info.buildNumber : "未知";
    _appVersion = "版本\t$name\t(版本号\t$code)";
  }

  /// 初始化运行时
  Future<void> _initRuntime() async {
    // 初始化运行时
    for (var element in [super.base, this]) {
      // 添加到内置插件列表
      _pluginList.add(element);
      // 添加到插件详细信息列表
      _pluginDetailsList.add(
        PluginDetails(
          channel: element.pluginChannel,
          title: element.pluginName,
          description: element.pluginDescription,
          author: element.pluginAuthor,
          type: element == this ? PluginType.runtime : PluginType.base,
        ),
      );
    }
  }

  /// 初始化平台层插件
  Future<void> _initFramework() async {
    // 初始化平台插件
    try {
      dynamic plugins = await _exec(pluginChannel, 'get_plugins', true);
      List list = plugins as List? ?? [unknownPlugin];
      // 判断列表是否为空
      if (list.isNotEmpty) {
        // 遍历原生插件
        for (var element in list) {
          // 添加到插件详细信息列表
          _pluginDetailsList.add(
            PluginDetails.formMap(
              map: element,
              type: PluginType.engine,
            ),
          );
        }
      }
    } catch (exception) {
      // 平台错误添加未知插件占位
      _pluginDetailsList.add(
        PluginDetails.formMap(
          map: unknownPlugin,
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化普通插件
  Future<void> _initPlugins({
    required List<EcosedRuntimePlugin> plugins,
  }) async {
    if (plugins.isNotEmpty) {
      for (var element in plugins) {
        _pluginList.add(element);
        _pluginDetailsList.add(
          PluginDetails(
            channel: element.pluginChannel,
            title: element.pluginName,
            description: element.pluginDescription,
            author: element.pluginAuthor,
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
    bool internal, [
    dynamic arguments,
  ]) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        for (var internalPlugin in [this, super.base]) {
          if (internalPlugin.pluginChannel == channel && !internal) {
            return await null;
          }
        }
        if (element.pluginChannel == channel) {
          return await element.onMethodCall(method, arguments);
        }
      }
    } else {
      return await null;
    }
  }

  /// 判断插件是否为运行时
  bool _isRuntime(PluginDetails details) {
    return details.channel == pluginChannel;
  }

  /// 获取插件界面
  Widget _getPluginWidget(
    BuildContext context,
    PluginDetails details,
  ) {
    return _getPlugin(details)?.pluginWidget(context) ?? const Placeholder();
  }

  /// 获取插件
  EcosedRuntimePlugin? _getPlugin(PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel == details.channel) {
          return element;
        }
      }
    }
    return null;
  }
}
