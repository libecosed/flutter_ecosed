import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/placeholder.dart';
import '../viewmodel/manager_view_model.dart';
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

  /// 插件通道
  @override
  String get pluginChannel => 'ecosed_runtime';

  /// 插件描述
  @override
  String get pluginDescription => 'FlutterEcosed框架运行时';

  /// 插件名称
  @override
  String get pluginName => 'EcosedRuntime';

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    switch (method) {
      case 'get_engine_plugins':
        return await super.execEngine(
          'get_engine_plugins',
        );
      case 'get_platform_plugins':
        return await super.execEngine(
          'get_platform_plugins',
        );
      default:
        return await null;
    }
  }

  @override
  Future<void> init(List<EcosedRuntimePlugin> plugins) async {
    // 初始化包信息
    await _initPackage();
    // 初始化运行时
    await _initRuntime();
    // 初始化引擎插件
    await _initEnginePlugin();
    // 初始化平台插件
    await _initPlatformPlugin();
    // 初始化普通插件
    await _initPlugins(plugins: plugins);

    // await super.execEngine(
    //   'openDialog',
    //   {'channel': 'engine_embedder'},
    // );
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    for (var element in _pluginDetailsList) {
      if (_isRuntime(element)) {
        return _getPluginWidget(
          context,
          element,
        );
      }
    }
    return super.buildManager(context);
  }

  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return ManagerViewModel(
      context: context,
      pluginDetailsList: _pluginDetailsList,
      getPlugin: _getPlugin,
      getPluginWidget: _getPluginWidget,
      isRuntime: _isRuntime,
      launchDialog: super.launchDialog,
      appName: _appName,
      appVersion: _appVersion,
    );
  }

  /// 管理器布局
  @override
  Widget buildLayout(BuildContext context) {
    return const EcosedManager();
  }

  /// 构建调试菜单
  @override
  Future<SimpleDialog?> buildDialog(
    BuildContext context,
    bool isManager,
  ) async {
    return await showDialog<SimpleDialog>(
      context: context,
      useRootNavigator: false,
      builder: (context) => SimpleDialog(
        title: const Text('调试菜单'),
        children: <SimpleDialogOption>[
          if (!isManager)
            SimpleDialogOption(
              padding: const EdgeInsets.all(0),
              child: Tooltip(
                message: '打开管理器',
                child: ListTile(
                  title: const Text('打开管理器'),
                  leading: const Icon(Icons.open_in_new),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  enabled: true,
                  onTap: () async => await super.launchManager(),
                ),
              ),
            ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(0),
            child: Tooltip(
              message: '关闭对话框',
              child: ListTile(
                title: const Text('关闭对话框'),
                leading: const Icon(Icons.close),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                enabled: true,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
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
    for (var element in [super.base, this, super.embedder]) {
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
  Future<void> _initEnginePlugin() async {
    // 初始化平台插件
    try {
      dynamic plugins = await _exec(pluginChannel, 'get_engine_plugins', true);
      List list = plugins as List? ?? [unknownPluginWithMap];
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
          map: unknownPluginWithMap,
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化平台层插件
  Future<void> _initPlatformPlugin() async {
    // 初始化平台插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel, 'get_platform_plugins', true)
                  as List? ??
              [unknownPluginWithJSON])) {
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
          json: jsonDecode(unknownPluginWithJSON),
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
    // 判断插件列表是否非空
    if (_pluginList.isNotEmpty) {
      // 遍历插件列表
      for (var element in _pluginList) {
        // 遍历内部插件列表
        for (var internalPlugin in [super.base, this, super.embedder]) {
          // 判断是否为内部插件, 且是否不允许访问内部插件
          if (internalPlugin.pluginChannel == channel && !internal) {
            // 返回空结束函数
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
