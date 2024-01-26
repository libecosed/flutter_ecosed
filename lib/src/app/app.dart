import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../platform/flutter_ecosed.dart';
import '../plugin/plugin.dart';
import '../value/default_info.dart';

abstract class EcosedAppWrapper {
  List<EcosedPlugin> initialPlugin();

  /// 调用插件方法
  Object? execPluginCall(String name);
}

class PluginPerson {
  const PluginPerson(
      {required this.channel,
      required this.title,
      required this.description,
      required this.author,
      required this.type,
      required this.initial});

  final String channel;
  final String title;
  final String description;
  final String author;
  final PluginType type;
  final bool initial;

  factory PluginPerson.formJSON(
      Map<String, dynamic> json, PluginType type, bool initial) {
    return PluginPerson(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        type: type,
        initial: initial);
  }
}

enum PluginType { native, flutter, unknown }

typedef EcosedExec = Object? Function(String channel, String method);
typedef EcosedApps = Widget Function(Widget view, EcosedExec exec);

class EcosedApp extends EcosedPlugin implements EcosedAppWrapper {
  const EcosedApp(
      {super.key,
      required this.app,
      required this.bannerLocation,
      required this.appName,
      required this.plugins});

  final EcosedApps app;
  final BannerLocation bannerLocation;
  final String appName;
  final List<EcosedPlugin> plugins;

  @override
  State<EcosedApp> createState() => _EcosedAppState();

  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => 'flutter_ecosed_app';

  @override
  String pluginDescription() => appName;

  @override
  Object? onEcosedMethodCall(String name) {
    return null;
  }

  @override
  Object? execPluginCall(String name) {
    return '';
  }

  @override
  List<EcosedPlugin> initialPlugin() {
    return [this, const FlutterEcosed()];
  }
}

class _EcosedAppState extends State<EcosedApp> {
  static const String _unknownPlugin = '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown"}';

  final List<EcosedPlugin> _initialPluginList = [];
  final List<EcosedPlugin> _thirdPluginList = [];

  List<PluginPerson> _pluginPersonList = [
    PluginPerson.formJSON(jsonDecode(_unknownPlugin), PluginType.unknown, true)
  ];


  @override
  void initState() {
    // final parent = context.findAncestorWidgetOfExactType<Widget>(); // ParentWidget为目标父 widget 类型
    // if (parent != null) {
    //   if (parent !is MaterialApp) {
    //
    //   }
    // } else {
    //   // 没有找到指定类型的父 widget
    // }

    _initPluginsState();
    super.initState();
  }

  Future<void> _initPluginsState() async {
    List<PluginPerson> pluginList = [];
    //加载dart层的内置模块
    if (widget.initialPlugin().isNotEmpty) {
      for (var element in widget.initialPlugin()) {
        _initialPluginList.add(element);
      }
    }
    // 添加dart层模块
    for (var element in _initialPluginList) {
      pluginList.add(PluginPerson(
          channel: element.pluginChannel(),
          title: element.pluginName(),
          description: element.pluginDescription(),
          author: element.pluginAuthor(),
          type: PluginType.flutter,
          initial: true));
    }
    // 添加native层内置模块
    try {
      for (var element in (await (_initialExec('flutter_ecosed', 'plugins')
              as Future<List?>) ??
          [_unknownPlugin])) {
        pluginList.add(PluginPerson.formJSON(
            jsonDecode(element), PluginType.native, true));
      }
    } on PlatformException {
      pluginList = _pluginPersonList;
    }
    //加载dart层普通模块
    if (widget.plugins.isNotEmpty) {
      for (var element in widget.plugins) {
        _thirdPluginList.add(element);
      }
    }
    // 添加dart层模块
    for (var element in _thirdPluginList) {
      pluginList.add(PluginPerson(
          channel: element.pluginChannel(),
          title: element.pluginName(),
          description: element.pluginDescription(),
          author: element.pluginAuthor(),
          type: PluginType.flutter,
          initial: false));
    }
    // 设置模块列表
    setState(() {
      _pluginPersonList = pluginList;
    });
  }

  Widget _statCard(IconData icon, String title, String subtitle) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _overview(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: _statCard(Icons.keyboard_command_key, 'title', 'subtitle'))
      ],
    );
  }

  String _getType(PluginPerson person) {
    switch (person.type) {
      case PluginType.native:
        return '内置模块 - Native';
      case PluginType.flutter:
        return person.initial ? '内置模块 - Flutter' : '普通模块';
      default:
        return 'Unknown';
    }
  }

  Widget _pluginItem(PluginPerson person) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.title, textAlign: TextAlign.start),
                        Text('标识:${person.channel}',
                            textAlign: TextAlign.start),
                        Text('作者:${person.author}', textAlign: TextAlign.start),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.settings))
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(person.description, textAlign: TextAlign.start),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    Text(_getType(person)),
                    const Spacer(flex: 1),
                    TextButton(onPressed: () {}, child: const Text('设置')),
                    TextButton(onPressed: () {}, child: const Text('卸载'))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget _plugin(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
            children: _pluginPersonList
                .map((element) => _pluginItem(element))
                .toList()));
  }

  Widget _manager(BuildContext context) {
    return ListView(
      children: [_overview(context), const Divider(), _plugin(context)],
    );
  }

  Object? _thirdExec(String channel, String method) {
    if (_thirdPluginList.isNotEmpty) {
      for (var element in _thirdPluginList) {
        if (element.pluginChannel() == channel) {
          return element.onEcosedMethodCall(method);
        }
      }
    }
    return null;
  }

  Object? _initialExec(String channel, String method) {
    if (_initialPluginList.isNotEmpty) {
      for (var element in _initialPluginList) {
        if (element.pluginChannel() == channel) {
          return element.onEcosedMethodCall(method);
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Banner(
        message: 'EcosedApp',
        location: widget.bannerLocation,
        color: Colors.pinkAccent,
        child: widget.app(_manager(context),
            (channel, method) => _thirdExec(channel, method)));
  }
}
