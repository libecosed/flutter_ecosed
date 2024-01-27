import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../layout/manager.dart';
import '../platform/flutter_ecosed.dart';
import '../plugin/plugin_person.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_type.dart';
import '../value/default.dart';
import 'app_type.dart';
import 'app_wrapper.dart';

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
  String pluginName() => 'Application';

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => appChannel;

  @override
  String pluginDescription() => appName;

  @override
  Object? onEcosedMethodCall(String name) {
    return null;
  }

  @override
  List<EcosedPlugin> initialPlugin() => [this, const FlutterEcosed()];
}

class _EcosedAppState extends State<EcosedApp> {
  static const String _unknownPlugin =
      '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown"}';

  final List<EcosedPlugin> _initialPluginList = [];
  final List<EcosedPlugin> _thirdPluginList = [];

  List<PluginPerson> _pluginPersonList = [
    PluginPerson.formJSON(jsonDecode(_unknownPlugin), PluginType.unknown, true)
  ];

  @override
  void initState() {
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
    if (Platform.isAndroid) {
      try {
        for (var element in (await (_initialExec(platformChannel, pluginMethod)
                as Future<List?>) ??
            [_unknownPlugin])) {
          pluginList.add(PluginPerson.formJSON(
              jsonDecode(element), PluginType.native, true));
        }
      } on PlatformException {
        pluginList.add(_pluginPersonList.first);
      }
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
      child: widget.app(
        Manager(pluginPersonList: _pluginPersonList),
        (channel, method) => _thirdExec(channel, method),
      ),
    );
  }
}
