import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';

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

  /// 滚动控制器
  late ScrollController _scrollController;

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

  /// PubDev 统一资源定位符
  static const String _pubDev = 'https://pub.dev/packages/flutter_ecosed';

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
  Future<dynamic> exec(String channel, String method, [arguments]) async {
    return await _exec(channel, method, false, arguments);
  }

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
      app: _app,
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
      web: () async => List.empty(),
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
      web: () async => await null,
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
      web: () async => await null,
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
    required Future<dynamic> Function() web,
  }) async {
    if (kIsWeb) return await web.call();
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
    // 初始化滚动控制器
    _scrollController = ScrollController();
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
                      '版本:\t$_appVersion',
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
                Uri.parse(_pubDev),
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
                title: const Text('打开平台调试菜单'),
                leading: Icon(
                  Icons.android,
                  size: Theme.of(context).iconTheme.size,
                  color: Colors.green,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                enabled: Theme.of(context).platform == TargetPlatform.android,
                onTap: () => _exec(pluginChannel(), _openDialogMethod, true),
              ),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(0),
              child: ListTile(
                title: const Text('关闭平台调试菜单'),
                leading: Icon(
                  Icons.android,
                  size: Theme.of(context).iconTheme.size,
                  color: Colors.green,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                enabled: Theme.of(context).platform == TargetPlatform.android,
                onTap: () => _exec(pluginChannel(), _closeDialogMethod, true),
              ),
            ),
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
      case PluginType.platform:
        return Icon(
          Icons.android,
          size: Theme.of(context).iconTheme.size,
          color: Colors.green,
        );
      case PluginType.runtime:
        return Icon(
          Icons.keyboard_command_key,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
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
      // 平台插件
      case PluginType.platform:
        return '平台插件';
      // 框架运行时
      case PluginType.runtime:
        return '框架运行时';
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
        ? details.channel != pluginChannel()
            ? '打开'
            : '关于'
        : '无界面';
  }
}
