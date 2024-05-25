import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../platform/ecosed_platform_interface.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../widget/ecosed_banner.dart';
import '../widget/ecosed_inherited.dart';
import '../widget/info_card.dart';
import '../widget/more_card.dart';
import '../widget/plugin_card.dart';
import '../widget/state_card.dart';

final class EcosedRuntime extends StatelessWidget
    implements EcosedPlugin, EcosedPlatformInterface {
  EcosedRuntime({
    super.key,
    required this.app,
    required this.plugins,
    required this.runner,
  });

  final WidgetBuilder app;
  final List<EcosedPlugin> plugins;
  final Future<void> Function(Widget app) runner;

  static const String _unknownPlugin = '{'
      '"channel":"unknown",'
      '"title":"unknown",'
      '"description":"unknown",'
      '"author":"unknown"'
      '}';

  static const String getPluginMethod = 'get_plugins';
  static const String openDialogMethod = 'open_dialog';
  static const String closeDialogMethod = 'close_dialog';

  static const String pubDev = 'https://pub.dev/packages/flutter_ecosed';

  final EcosedPlatformInterface _platform = EcosedPlatformInterface.instance;
  final List<EcosedPlugin> _pluginList = [];
  final List<PluginDetails> _pluginDetailsList = [];
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
      case getPluginMethod:
        return await getPlatformPluginList();
      case openDialogMethod:
        return await openPlatformDialog();
      case closeDialogMethod:
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
  String pluginChannel() => 'runtime';

  /// 插件描述
  @override
  String pluginDescription() => 'Ecosed Runtime';

  /// 插件名称
  @override
  String pluginName() => 'EcosedRuntime';

  /// 插件用户界面
  @override
  Widget pluginWidget(BuildContext context) => this;

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Localizations(
        locale: const Locale('zh', 'CN'),
        delegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        child: Scrollbar(
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
                child: StateCard(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  leading: Icons.check_circle_outline,
                  title: 'widget.title',
                  subtitle: '引擎状态:\t${'getEngineState().name'}',
                  action: () => _openDialog(context),
                  trailing: Icons.developer_mode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: InfoCard(
                  appName: 'flutter_ecosed',
                  state: 'getEngineState().name',
                  platform: Theme.of(context).platform.name,
                  count: _pluginCount().toString(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: MoreCard(
                  launchUrl: () => launchUrl(
                    Uri.parse(pubDev),
                  ),
                ),
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
                            builder: (context) => PluginCard(
                              title: element.title,
                              channel: element.channel,
                              author: element.author,
                              icon: element.type == PluginType.native
                                  ? Icon(
                                      Icons.android,
                                      size: Theme.of(context).iconTheme.size,
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                      if (element.channel != pluginChannel()) {
                                        _launchPlugin(
                                          context,
                                          element,
                                        );
                                      } else {
                                        showAboutDialog(
                                          context: context,
                                          applicationName: 'flutter_ecosed',
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
    );
  }

  /// 初始化运行时
  Future<void> _init() async {
    // 添加到内置插件列表
    _pluginList.add(this);
    // 添加到插件详细信息列表
    _pluginDetailsList.add(
      PluginDetails(
        channel: pluginChannel(),
        title: pluginName(),
        description: pluginDescription(),
        author: pluginAuthor(),
        type: PluginType.runtime,
        initial: true,
      ),
    );

    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel(), getPluginMethod) as List? ??
              [_unknownPlugin])) {
        // 添加到插件详细信息列表
        _pluginDetailsList.add(
          PluginDetails.formJSON(
            json: jsonDecode(element),
            type: PluginType.native,
            initial: true,
          ),
        );
      }
    } on PlatformException {
      _pluginDetailsList.add(
        PluginDetails.formJSON(
          json: jsonDecode(_unknownPlugin),
          type: PluginType.unknown,
          initial: true,
        ),
      );
    }

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
            initial: false,
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
      executor: (channel, method) => _exec(channel, method),
      manager: _manager(),
      child: EcosedBanner(
        child: Builder(
          builder: (context) => app(context),
        ),
      ),
    );
  }

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

  int _pluginCount() {
    var count = 0;
    for (var element in _pluginList) {
      if (element.pluginChannel() != pluginChannel()) {
        count++;
      }
    }
    return count;
  }

  String _getPluginType(PluginDetails details) {
    switch (details.type) {
      case PluginType.native:
        return '内置插件 - Platform';
      case PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件 - Flutter';
      case PluginType.runtime:
        return '框架运行时';
      case PluginType.unknown:
        return '未知插件类型';
      default:
        return 'Unknown';
    }
  }

  bool _isAllowPush(PluginDetails details) {
    return details.type == PluginType.runtime ||
        details.type == PluginType.flutter &&
            _getPlugin(details.channel) != null;
  }

  void _launchPlugin(BuildContext context, PluginDetails details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _getPlugin(details.channel)!.pluginWidget(context),
      ),
    );
  }

  EcosedPlugin? _getPlugin(String channel) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == channel) {
          return element;
        }
      }
    }
    return null;
  }

  Widget _manager() {
    return Builder(
      builder: (context) {
        for (var element in _pluginDetailsList) {
          if (element.channel == pluginChannel()) {
            return _getPlugin(element.channel)!.pluginWidget(context);
          }
        }
        return Container();
      },
    );
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
                openDialogMethod,
              ),
              child: const Text('open'),
            ),
            TextButton(
              onPressed: () => _exec(
                pluginChannel(),
                closeDialogMethod,
              ),
              child: const Text('close'),
            )
          ],
        );
      },
    );
  }
}
