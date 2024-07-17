import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../engine/tag.dart';
import '../framework/log.dart';
import '../plugin/plugin_base.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/banner.dart';

/// 运行时
final class EcosedRuntime extends EcosedBase {
  /// 应用名称
  late String _appName;

  /// 应用版本
  late String _appVersion;

  /// 插件列表
  final List<BaseEcosedPlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// PubDev 统一资源定位符
  static const String _pubDevUrl = 'https://pub.dev/packages/flutter_ecosed';

  /// 占位符
  static const Map<String, dynamic> _unknownPlugin = {
    'channel': '',
    'title': '',
    'description': '',
    'author': ''
  };

  /// 启动应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    // 初始化
    await _init(plugins: plugins);
    // 启动应用
    await super.runWithRunner(
      app: app,
      plugins: plugins,
      runner: runner,
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

  @override
  Widget build(BuildContext context) {
    return _managerBody(context: context);
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
        return await execFramework(
          'get_plugins',
          {'channel': 'ecosed_engine'},
        );
      default:
        return await null;
    }
  }

  Future<dynamic> execFramework(
    String method, [
    dynamic arguments,
  ]) async {
    return await engineBridgerScope.onMethodCall(
      method,
      arguments,
    );
  }

  /// 初始化运行时
  Future<void> _init({required List<BaseEcosedPlugin> plugins}) async {
    // 初始化Flutter相关
    await _initFlutter();
    // 初始化包信息
    await _initPackage();
    // 初始化运行时
    await _initRuntime();
    // 初始化引擎
    await _initEngine();

    await _initFramework();

    // 初始化普通插件
    await _initPlugins(plugins: plugins);
  }

  /// 初始化Flutter相关组件
  Future<void> _initFlutter() async {
    // 打印横幅
    Log.d(tag, '\n${utf8.decode(base64Decode(banner))}');
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// 初始化包信息
  Future<void> _initPackage() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用名称
    _appName = info.appName.isNotEmpty ? info.appName : "unknown";
    // 获取应用版本
    String name = info.version.isNotEmpty ? info.version : "unknown";
    String code = info.buildNumber.isNotEmpty ? info.buildNumber : "unknown";
    _appVersion = "版本\t$name\t(版本号\t$code)";
  }

  /// 初始化运行时
  Future<void> _initRuntime() async {
    // 初始化运行时
    for (var element in [super.get, this]) {
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

  Future<void> _initEngine() async {
    initEngineBridge();
    await engineBridgerScope.onCreateEngine(this);
  }

  /// 初始化平台层插件
  Future<void> _initFramework() async {
    // 初始化平台插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel, 'get_plugins', true) as List? ??
              [_unknownPlugin])) {
        // 添加到插件详细信息列表
        _pluginDetailsList.add(
          PluginDetails.formMap(
            map: element,
            type: PluginType.platform,
          ),
        );
      }
    } catch (exception) {
      // 平台错误添加未知插件占位
      _pluginDetailsList.add(
        PluginDetails.formMap(
          map: _unknownPlugin,
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化普通插件
  Future<void> _initPlugins({required List<BaseEcosedPlugin> plugins}) async {
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

  /// 管理器体部
  Widget _managerBody({
    required BuildContext context,
  }) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: _stateCard(context: context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: _infoCard(context: context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: _moreCard(context: context),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: _pluginCardList(context: context),
            ),
          ],
        ),
      ),
    );
  }

  /// 状态卡片
  Widget _stateCard({
    required BuildContext context,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_command_key,
              size: Theme.of(context).iconTheme.size,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _appName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _appVersion,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () => _openDialog(context),
              icon: Icon(
                Icons.developer_mode,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 信息卡片
  Widget _infoCard({
    required BuildContext context,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoItem(
                    context: context,
                    title: '应用名称',
                    subtitle: _appName,
                  ),
                  const SizedBox(height: 16),
                  _infoItem(
                    context: context,
                    title: '应用版本',
                    subtitle: _appVersion,
                  ),
                  const SizedBox(height: 16),
                  _infoItem(
                    context: context,
                    title: '当前平台',
                    subtitle: Theme.of(context).platform.name,
                  ),
                  const SizedBox(height: 16),
                  _infoItem(
                    context: context,
                    title: '插件数量',
                    subtitle: _pluginCount().toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 信息项
  Widget _infoItem({
    required BuildContext context,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// 了解更多卡片
  Widget _moreCard({
    required BuildContext context,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '了解 flutter_ecosed',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '了解如何使用 flutter_ecosed 进行开发。',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => launchUrl(
                Uri.parse(_pubDevUrl),
              ),
              icon: Icon(
                Icons.open_in_browser,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )
          ],
        ),
      ),
    );
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
                  onPressed: _openPlugin(context, details),
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
        for (var internalPlugin in [this, super.get]) {
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
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
    );
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        _getPlugin(details) != null;
  }

  /// 获取插件
  BaseEcosedPlugin? _getPlugin(PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  /// 打开对话和
  void _openDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('调试菜单 (Flutter)'),
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
            )
          ],
        );
      },
      useRootNavigator: false,
    );
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
      case PluginType.platform:
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
      // 运行时内核绑定
      case PluginType.base:
        return '运行时内核绑定';
      // 平台插件
      case PluginType.platform:
        return '平台插件';
      // 内核模块
      case PluginType.kernel:
        return '内核模块';
      // 普通插件
      case PluginType.flutter:
        return '普通插件';
      // 未知
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
                useRootNavigator: false,
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
