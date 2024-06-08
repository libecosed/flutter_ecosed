import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../platform/ecosed_platform_interface.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../widget/ecosed_banner.dart';
import '../widget/ecosed_inherited.dart';

final class EcosedRuntime extends EcosedPlatformInterface
    implements EcosedPlugin {
  /// 应用程序
  late WidgetBuilder app;

  /// 应用名称
  late String appName;

  /// 插件列表
  late List<EcosedPlugin> plugins;

  /// 执行器
  late Future<void> Function(Widget app) runner;

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

  /// PubDev Url
  static const String _pubDev = 'https://pub.dev/packages/flutter_ecosed';

  /// 插件列表
  final List<EcosedPlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 滚动控制器
  final ScrollController _controller = ScrollController();

  /// 方法通道平台代码调用Android平台独占
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final _arguments = const {'channel': 'ecosed_engine'};

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      // 获取平台插件列表
      case _getPluginMethod:
        return await getPlatformPluginList();
      // 打开平台对话框
      case _openDialogMethod:
        return await openPlatformDialog();
      // 关闭平台对话框
      case _closeDialogMethod:
        return await closePlatformDialog();
      // 其他值返回空
      default:
        return await null;
    }
  }

  /// 插件名称
  @override
  String pluginAuthor() => 'wyq0918dev';

  /// 插件通道
  @override
  String pluginChannel() => 'ecosed_runtime';

  /// 插件描述
  @override
  String pluginDescription() => 'flutter_ecosed 框架运行时';

  /// 插件名称
  @override
  String pluginName() => 'Ecosed Runtime';

  /// 插件用户界面
  @override
  Widget pluginWidget(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: MediaQuery.platformBrightnessOf(context),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: const Locale('zh', 'CN'),
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          child: Navigator(
            onGenerateInitialRoutes: (navigator, name) => [
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: _managerBody(context: context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPlatformPluginList() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeListMethod<String?>(
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
  @override
  Future<bool?> openPlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeMethod<bool?>(
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
  @override
  Future<bool?> closePlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeMethod<bool?>(
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

  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required String appName,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    this.app = app;
  //  this.appName = appName;
    this.plugins = plugins;
    this.runner = runner;
    // 初始化
    await _init();
    // 启动应用
    await _startup();
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

  /// 初始化运行时
  Future<void> _init() async {
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    
    // 初始化运行时
    await _initRuntime();
    // 初始化平台层插件
    await _initPlatform();
    // 初始化普通插件
    await _initPlugins();
  }

  /// 启动应用
  Future<void> _startup() async {
    return await runner(_builder());
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
    if (plugins.isNotEmpty) {
      for (var element in plugins) {
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

  /// 应用构建器
  Widget _builder() {
    return EcosedInherited(
      executor: (channel, method) async {
        return await _exec(channel, method, false);
      },
      manager: _manager(),
      child: EcosedBanner(
        child: Builder(
          builder: (context) => app(context),
        ),
      ),
    );
  }

  /// 获取管理器
  Widget _manager() {
    return Builder(
      builder: (context) {
        for (var element in _pluginDetailsList) {
          if (_isRuntime(element)) {
            return _getPluginWidget(
              context: context,
              details: element,
            );
          }
        }
        return Container();
      },
    );
  }

  /// 管理器体部
  Widget _managerBody({
    required BuildContext context,
  }) {
    return Scrollbar(
      controller: _controller,
      child: ListView(
        controller: _controller,
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
                      appName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'sub_title',
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
                    subtitle: appName,
                  ),
                  const SizedBox(height: 16),
                  _infoItem(
                    context: context,
                    title: '引擎状态',
                    subtitle: 'null',
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
    bool runtimeful,
  ) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (pluginChannel() == channel && !runtimeful) {
          continue;
        }
        if (element.pluginChannel() == channel) {
          return await element.onMethodCall(method);
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
    // todo: Flutter内部菜单
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('title'),
          actions: <Widget>[
            TextButton(
              onPressed: () => _exec(pluginChannel(), _openDialogMethod, true),
              child: const Text('open'),
            ),
            TextButton(
              onPressed: () => _exec(pluginChannel(), _closeDialogMethod, true),
              child: const Text('close'),
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
                applicationName: appName,
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
