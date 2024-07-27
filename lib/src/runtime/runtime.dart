import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
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
    required Future<void> Function(Widget app) runner,
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
    await super.runWithRunner(
      app: app,
      runner: runner,
    );
  }

  @override
  Future<void> openDebugMenu() async {
    super.openDebugMenu();
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

  @override
  Widget build(BuildContext context) {
    return EcosedManager(
      appName: _appName,
      appVersion: _appVersion,
      pluginDetailsList: _pluginDetailsList,
      pluginList: _pluginCardList(context: context),
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
    return super.buildManager(context);
  }

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

  /// 插件卡片列表
  Widget _pluginCardList({
    required BuildContext context,
  }) {
    return ListBody(
      children: _pluginDetailsList
          .map(
            (element) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Builder(
                builder: (context) => _pluginCard(
                  context: context,
                  details: element,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// 插件卡片
  Widget _pluginCard({
    required BuildContext context,
    required PluginDetails details,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '通道: ${details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: ${details.author}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: _getPluginIcon(context: context, details: details),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              details.description,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _getPluginType(details),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: _openPlugin(getBuildContext(), details),
                  child: Text(_getPluginAction(details)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
  Widget _getPluginWidget({
    required BuildContext context,
    required PluginDetails details,
  }) {
    return _getPlugin(details)?.pluginWidget(context) ?? Container();
  }

  /// 打开插件
  void _launchPlugin(
    BuildContext context,
    PluginDetails details,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => Theme(
          data: ThemeData(
            brightness: MediaQuery.platformBrightnessOf(context),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                details.title,
              ),
            ),
            body: _getPluginWidget(
              context: context,
              details: details,
            ),
          ),
        ),
      ),
    );
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        _getPlugin(details) != null;
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

  /// 获取插件的图标
  Widget _getPluginIcon({
    required BuildContext context,
    required PluginDetails details,
  }) {
    switch (details.type) {
      case PluginType.runtime:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.base:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.engine:
        return Icon(
          Icons.android,
          size: Theme.of(context).iconTheme.size,
          color: Colors.green,
        );
      case PluginType.kernel:
        return Icon(
          Icons.developer_board,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueGrey,
        );
      case PluginType.flutter:
        return const FlutterLogo();
      case PluginType.unknown:
        return Icon(
          Icons.error_outline,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
      default:
        return Icon(
          Icons.error_outline,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }

  /// 获取插件类型
  String _getPluginType(PluginDetails details) {
    switch (details.type) {
      // 框架运行时
      case PluginType.runtime:
        return '框架运行时';
      // 绑定通信层
      case PluginType.base:
        return '绑定通信层';
      // 平台插件
      case PluginType.engine:
        return '引擎插件';
      // 内核模块
      case PluginType.kernel:
        return '内核模块';
      // 普通插件
      case PluginType.flutter:
        return '普通插件';
      // 未知插件类型
      case PluginType.unknown:
        return '未知插件类型';
      // 未知
      default:
        return 'Unknown';
    }
  }

  /// 打开卡片
  VoidCallback? _openPlugin(BuildContext context, PluginDetails details) {
    // 无法打开的返回空
    return _isAllowPush(details)
        ? () {
            if (!_isRuntime(details)) {
              // 非运行时打开插件页面
              _launchPlugin(
                context,
                details,
              );
            } else {
              // 运行时打开关于对话框
              showAboutDialog(
                context: context,
                applicationName: _appName,
                applicationVersion: _appVersion,
                applicationLegalese: 'Powered by FlutterEcosed',
                useRootNavigator: true,
              );
            }
          }
        : null;
  }

  /// 获取插件的动作名
  String _getPluginAction(PluginDetails details) {
    return _isAllowPush(details)
        ? details.channel != pluginChannel
            ? '打开'
            : '关于'
        : '无界面';
  }
}
