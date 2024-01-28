import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../layout/manager.dart';
import '../platform/flutter_ecosed.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../value/default.dart';
import 'app_type.dart';
import 'app_wrapper.dart';

class EcosedApp extends EcosedPlugin implements EcosedAppWrapper {
  const EcosedApp(
      {super.key,
      required this.home,
      required this.bannerLocation,
      required this.title,
      required this.plugins});

  final EcosedHome home;
  final BannerLocation bannerLocation;
  final String title;
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
  String pluginDescription() => title;

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

  /// 插件信息列表
  List<PluginDetails> _pluginDetailsList = [
    PluginDetails.formJSON(jsonDecode(_unknownPlugin), PluginType.unknown, true)
  ];

  /// 加载状态
  @override
  void initState() {
    _initPluginsState();
    super.initState();
  }

  /// 加载插件
  Future<void> _initPluginsState() async {
    List<PluginDetails> pluginList = [];
    //加载dart层的内置插件
    if (widget.initialPlugin().isNotEmpty) {
      for (var element in widget.initialPlugin()) {
        _initialPluginList.add(element);
      }
    }
    // 添加dart层插件
    for (var element in _initialPluginList) {
      pluginList.add(
        PluginDetails(
            channel: element.pluginChannel(),
            title: element.pluginName(),
            description: element.pluginDescription(),
            author: element.pluginAuthor(),
            type: PluginType.flutter,
            initial: true),
      );
    }
    // 添加native层内置插件
    if (Platform.isAndroid) {
      try {
        for (var element in (await (_initialExec(platformChannel, pluginMethod)
                as Future<List?>) ??
            [_unknownPlugin])) {
          pluginList.add(
            PluginDetails.formJSON(
              jsonDecode(element),
              PluginType.native,
              true,
            ),
          );
        }
      } on PlatformException {
        pluginList.add(_pluginDetailsList.first);
      }
    }
    //加载dart层普通插件
    if (widget.plugins.isNotEmpty) {
      for (var element in widget.plugins) {
        _thirdPluginList.add(element);
      }
    }
    // 添加dart层插件
    for (var element in _thirdPluginList) {
      pluginList.add(
        PluginDetails(
            channel: element.pluginChannel(),
            title: element.pluginName(),
            description: element.pluginDescription(),
            author: element.pluginAuthor(),
            type: PluginType.flutter,
            initial: false),
      );
    }
    // 设置插件列表
    setState(() {
      _pluginDetailsList = pluginList;
    });
  }

  /// 执行普通插件代码
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

  /// 执行内置插件代码
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
      child: widget.home(
        Manager(pluginDetailsList: _pluginDetailsList),
        (channel, method) => _thirdExec(channel, method),
      ),
    );
  }
}
