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
      required this.appName,
      required this.plugins});

  final EcosedHome home;
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
  Widget pluginWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcosedApp')),
      body: Center(
        child: Text('App'),
      ),
    );
  }

  @override
  Future<Object?> onEcosedMethodCall(String name) async {
    return null;
  }

  @override
  List<EcosedPlugin> initialPlugin() => [this, const FlutterEcosed()];
}

class _EcosedAppState extends State<EcosedApp> {
  /// 占位用空模块
  static const String _unknownPlugin =
      '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown"}';

  /// Dart层插件列表
  List<EcosedPlugin> _pluginList = [];

  bool _shizukuInstalled = false;
  bool _microGInstalled = false;
  bool _shizukuGranted = false;
  List<PluginDetails> _pluginDetailsList = [
    PluginDetails.formJSON(jsonDecode(_unknownPlugin), PluginType.unknown, true)
  ];

  /// 加载状态
  @override
  void initState() {
    _initState();
    super.initState();
  }

  /// 加载插件
  Future<void> _initState() async {
    // 内置插件列表
    List<EcosedPlugin> initialPluginList = [];
    // Shizuku是否已安装
    bool shizukuInstalled;
    // 谷歌基础服务是否已启用
    bool microGInstalled;
    // Shizuku是否已授权
    bool shizukuGranted;
    //

    // 插件详细信息列表
    List<PluginDetails> pluginDetailsList = [];

    //预加载Dart层关键内置插件
    if (widget.initialPlugin().isNotEmpty) {
      // 遍历内部插件
      for (var element in widget.initialPlugin()) {
        // 添加到内置插件列表
        initialPluginList.add(element);
        // 添加到插件详细信息列表
        pluginDetailsList.add(
          PluginDetails(
            channel: element.pluginChannel(),
            title: element.pluginName(),
            description: element.pluginDescription(),
            author: element.pluginAuthor(),
            type: PluginType.flutter,
            initial: true,
          ),
        );
      }
      // 设置插件列表
      _pluginList = initialPluginList;
    }

    // 获取Shizuku是否已安装
    try {
      shizukuInstalled = await _exec(
        platformChannel,
        isShizukuInstalledMethod,
      ) as bool;
    } on PlatformException {
      shizukuInstalled = false;
    }
    // 获取谷歌基础服务(microG)是否已安装
    try {
      microGInstalled = await _exec(
        platformChannel,
        isMicroGInstalledMethod,
      ) as bool;
    } on PlatformException {
      microGInstalled = false;
    }
    // 获取Shizuku权限是否已授权
    try {
      shizukuGranted = await _exec(
        platformChannel,
        isShizukuGrantedMethod,
      ) as bool;
    } on PlatformException {
      shizukuGranted = false;
    }
    // 加载详细信息

    // 添加native层内置插件
    if (Platform.isAndroid) {
      try {
        // 遍历原生插件
        for (var element in (await _exec(
              platformChannel,
              getPluginMethod,
            ) as List? ??
            [_unknownPlugin])) {
          // 添加到插件详细信息列表
          pluginDetailsList.add(
            PluginDetails.formJSON(
              jsonDecode(element),
              PluginType.native,
              true,
            ),
          );
        }
      } on PlatformException {
        pluginDetailsList.add(_pluginDetailsList.first);
      }
    }
    //加载dart层普通插件
    if (widget.plugins.isNotEmpty) {
      // 遍历普通插件
      for (var element in widget.plugins) {
        // 添加到插件列表
        _pluginList.add(element);
        // 添加到插件详细信息列表
        pluginDetailsList.add(
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
    // 设置状态，更新界面
    if (mounted) {
      setState(() {
        _shizukuInstalled = shizukuInstalled;
        _microGInstalled = microGInstalled;
        _shizukuGranted = shizukuGranted;

        _pluginDetailsList = pluginDetailsList;
      });
    } else {
      return;
    }
  }

  /// 执行插件代码
  Future<Object?> _exec(String channel, String method) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == channel) {
          return await element.onEcosedMethodCall(method);
        }
      }
    }
    return null;
  }

  /// 管理器页面
  Widget buildManager(
    List<PluginDetails> pluginDetailsList,
    String appName,
    List<EcosedPlugin> pluginList,
  ) {
    return Manager(
      pluginDetailsList: pluginDetailsList,
      appName: appName,
      pluginList: pluginList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'EcosedApp',
      location: widget.bannerLocation,
      color: Colors.pinkAccent,
      child: widget.home(
        buildManager(_pluginDetailsList, widget.appName, _pluginList),
        (channel, method) => _exec(channel, method),
      ),
    );
  }
}
