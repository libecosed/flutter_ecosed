import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../kernel/kernel.dart';
import '../platform/ecosed_platform_interface.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../widget/ecosed_inherited.dart';

final class EcosedRuntime extends StatelessWidget
    implements EcosedPlugin, EcosedPlatformInterface {
  EcosedRuntime({
    super.key,
    required this.app,
    required this.appName,
    required this.plugins,
    required this.runner,
  });

  final WidgetBuilder app;
  final String appName;
  final List<EcosedPlugin> plugins;
  final Future<void> Function(Widget app) runner;

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

  /// 平台接口实例
  final EcosedPlatformInterface _platform = EcosedPlatformInterface.instance;

  /// 插件列表
  final List<EcosedPlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 滚动控制器
  final ScrollController _controller = ScrollController();

  /// 运行时执行入口
  Future<void> call() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();
    await _startup();
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case _getPluginMethod:
        return await getPlatformPluginList();
      case _openDialogMethod:
        return await openPlatformDialog();
      case _closeDialogMethod:
        return await closePlatformDialog();
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
  Widget pluginWidget(BuildContext context) => this;

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await _platform.getPlatformPluginList();
  }

  @override
  Future<List?> getKernelModuleList() async {
    return await _platform.getPlatformPluginList();
  }

  /// 打开平台对话框
  @override
  Future<bool?> openPlatformDialog() async {
    return await _platform.openPlatformDialog();
  }

  /// 关闭平台对话框
  @override
  Future<bool?> closePlatformDialog() async {
    return await _platform.closePlatformDialog();
  }

  /// 管理器界面
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: true),
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
                  body: Scrollbar(
                    controller: _controller,
                    child: ListView(
                      controller: _controller,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        //   child: StateCard(
                        //     color: getEngineState() == EngineState.running
                        //         ? Theme.of(context).colorScheme.primaryContainer
                        //         : Theme.of(context).colorScheme.errorContainer,
                        //     leading: getEngineState() == EngineState.running
                        //         ? Icons.check_circle_outline
                        //         : Icons.error_outline,
                        //     title: widget.title,
                        //     subtitle: '引擎状态:\t${getEngineState().name}',
                        //     action: () => openDialog(context),
                        //     trailing: Icons.developer_mode,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                          child: _stateCard(
                            context: context,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            leading: Icons.check_circle_outline,
                            title: appName,
                            subtitle: sum(1, 1).toString(),
                            action: () => _openDialog(context),
                            trailing: Icons.developer_mode,
                          ),
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
                          child: ListBody(
                            children: _pluginDetailsList
                                .map(
                                  (element) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Builder(
                                      builder: (context) => _pluginCard(
                                        context: context,
                                        title: element.title,
                                        channel: element.channel,
                                        author: element.author,
                                        icon:
                                            element.type == PluginType.platform
                                                ? Icon(
                                                    Icons.android,
                                                    size: Theme.of(context)
                                                        .iconTheme
                                                        .size,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  )
                                                : const FlutterLogo(),
                                        description: element.description,
                                        type: _getPluginType(element),
                                        action: _isAllowPush(element)
                                            ? element.channel != pluginChannel()
                                                ? '打开'
                                                : '关于'
                                            : '无界面',
                                        open: _isAllowPush(element)
                                            ? () {
                                                if (element.channel !=
                                                    pluginChannel()) {
                                                  _launchPlugin(
                                                    context,
                                                    element,
                                                  );
                                                } else {
                                                  showAboutDialog(
                                                    context: context,
                                                    applicationName: appName,
                                                    applicationLegalese:
                                                        'Powered by FlutterEcosed',
                                                  );
                                                }
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner({
    required bool enabled,
    required Widget child,
  }) {
    if (!enabled) return child;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: 'EcosedApp',
        textDirection: TextDirection.ltr,
        location: kDebugMode ? BannerLocation.topStart : BannerLocation.topEnd,
        child: child,
      ),
    );
  }

  /// 初始化运行时
  Future<void> _init() async {
    await _initRuntime();
    await _initPlatform();
    await _initPlugins();
  }

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

  Future<void> _initPlatform() async {
    // 初始化平台插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel(), _getPluginMethod) as List? ??
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

  Future<void> _startup() async {
    return await runner(_builder());
  }

  Widget _builder() {
    return EcosedInherited(
      executor: (channel, method) {
        return _exec(channel, method);
      },
      manager: _manager(),
      child: _banner(
        enabled: true,
        child: Builder(
          builder: (context) => app(context),
        ),
      ),
    );
  }

  Widget _stateCard({
    required BuildContext context,
    required Color color,
    required IconData leading,
    required String title,
    required String subtitle,
    required VoidCallback action,
    required IconData trailing,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(
              leading,
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
                      title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: action,
              icon: Icon(
                trailing,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pluginCard({
    required BuildContext context,
    required String title,
    required String channel,
    required String author,
    required Widget icon,
    required String description,
    required String type,
    required String action,
    required VoidCallback? open,
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
                        title,
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
                        '通道: $channel',
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
                        '作者: $author',
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
                  child: icon,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
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
                    type,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: open,
                  child: Text(action),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
              icon: const Icon(Icons.open_in_browser),
            )
          ],
        ),
      ),
    );
  }

  /// 执行插件方法
  Future<dynamic> _exec(String channel, String method) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == channel) {
          return await element.onMethodCall(method);
        }
      }
    }
    return await null;
  }

  /// 统计普通插件数量
  int _pluginCount() {
    var count = 0;
    for (var element in _pluginDetailsList) {
      if (element.channel != pluginChannel()) {
        count++;
      }
    }
    return count;
  }

  /// 获取插件类型
  String _getPluginType(PluginDetails details) {
    switch (details.type) {
      case PluginType.kernel:
        return '内核模块';
      case PluginType.platform:
        return '平台插件';
      case PluginType.runtime:
        return '框架运行时';
      case PluginType.flutter:
        return '普通插件';
      case PluginType.unknown:
        return '未知插件类型';
      default:
        return 'Unknown';
    }
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return details.type == PluginType.runtime ||
        details.type == PluginType.flutter && _getPlugin(details) != null;
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
            context,
            details,
          ),
        ),
      ),
    );
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

  /// 获取管理器
  Widget _manager() {
    return Builder(
      builder: (context) {
        for (var element in _pluginDetailsList) {
          if (_isRuntime(element)) {
            return _getPluginWidget(context, element);
          }
        }
        return Container();
      },
    );
  }

  /// 获取插件界面
  Widget _getPluginWidget(BuildContext context, PluginDetails details) {
    for (var element in _pluginList) {
      if (element.pluginChannel() == details.channel) {
        return element.pluginWidget(context);
      }
    }
    return Container();
  }

  /// 判断插件是否为运行时
  bool _isRuntime(PluginDetails details) {
    return details.channel == pluginChannel();
  }

  void _openDialog(BuildContext context) async {
    // todo: Flutter内部菜单
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('title'),
          actions: <Widget>[
            TextButton(
              onPressed: () => _exec(
                pluginChannel(),
                _openDialogMethod,
              ),
              child: const Text('open'),
            ),
            TextButton(
              onPressed: () => _exec(
                pluginChannel(),
                _closeDialogMethod,
              ),
              child: const Text('close'),
            )
          ],
        );
      },
    );
  }
}
