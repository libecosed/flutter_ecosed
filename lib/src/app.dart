///
/// Copyright flutter_ecosed
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///   http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'layout/manager.dart';

typedef EcosedExec = Object? Function(String channel, String method);
typedef EcosedHome = Widget Function(Widget body, EcosedExec exec);

enum PluginType { native, flutter, unknown }

const String defaultAuthor = 'wyq0918dev';
const String appChannel = 'ecosed_app';

const String engineChannel = 'ecosed_engine';
const String serviceChannel = 'ecosed_service';

const String isShizukuInstalledMethod = 'is_shizuku_installed';
const String installShizukuMethod = 'install_shizuku';
const String isMicroGInstalledMethod = 'is_microg_installed';
const String installMicroGMethod = 'install_microg';
const String isShizukuGrantedMethod = 'is_shizuku_granted';
const String requestPermissionsMethod = 'request_permissions';

const String getPluginMethod = 'get_plugins';

abstract class _EcosedAppWrapper {
  List<EcosedPlugin> initialPlugin();
}

abstract class _EcosedPlatform extends PlatformInterface {
  _EcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static final _EcosedPlatform _instance = _MethodChannelFlutterEcosed();

  static _EcosedPlatform get instance => _instance;

  Future<bool?> isShizukuInstalled() {
    throw UnimplementedError('isShizukuInstalled() has not been implemented.');
  }

  void installShizuku() {
    throw UnimplementedError('installShizuku() has not been implemented.');
  }

  Future<bool?> isMicroGInstalled() {
    throw UnimplementedError('isMicroGInstalled() has not been implemented.');
  }

  void installMicroG() {
    throw UnimplementedError('installMicroG() has not been implemented.');
  }

  Future<bool?> isShizukuGranted() {
    throw UnimplementedError('isShizukuGranted() has not been implemented.');
  }

  void requestPermissions() {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  Future<String?> getPoem() {
    throw UnimplementedError('getPoem() has not been implemented.');
  }

  Future<String?> getShizukuVersion() {
    throw UnimplementedError('getShizukuVersion() has not been implemented.');
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList() has not been implemented.');
  }
}

abstract class EcosedPlugin extends StatefulWidget {
  const EcosedPlugin({super.key});

  ///插件信息
  String pluginChannel();

  ///插件名称
  String pluginName();

  ///插件描述
  String pluginDescription();

  ///插件作者
  String pluginAuthor();

  ///插件界面
  Widget pluginWidget(BuildContext context) => this;

  ///方法调用
  Future<Object?> onEcosedMethodCall(String name);
}

class PluginDetails {
  const PluginDetails(
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

  factory PluginDetails.formJSON(
      Map<String, dynamic> json, PluginType type, bool initial) {
    return PluginDetails(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        type: type,
        initial: initial);
  }
}

class EcosedApp extends EcosedPlugin
    implements _EcosedAppWrapper, _EcosedPlatform {
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
    switch (name) {
      case isShizukuInstalledMethod:
        return isShizukuInstalled();
      case installShizukuMethod:
        installShizuku();
        return null;
      case isMicroGInstalledMethod:
        return isMicroGInstalled();
      case installMicroGMethod:
        installMicroG();
        return null;
      case isShizukuGrantedMethod:
        return isShizukuGranted();
      case requestPermissionsMethod:
        requestPermissions();
        return null;
      case getPluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  State<EcosedApp> createState() => _EcosedAppState();

  @override
  List<EcosedPlugin> initialPlugin() => [this];

  @override
  Future<bool?> isShizukuInstalled() {
    return _EcosedPlatform.instance.isShizukuInstalled();
  }

  @override
  void installShizuku() {
    _EcosedPlatform.instance.installShizuku();
  }

  @override
  Future<bool?> isMicroGInstalled() {
    return _EcosedPlatform.instance.isMicroGInstalled();
  }

  @override
  void installMicroG() {
    _EcosedPlatform.instance.installMicroG();
  }

  @override
  Future<bool?> isShizukuGranted() {
    return _EcosedPlatform.instance.isShizukuGranted();
  }

  @override
  void requestPermissions() {
    _EcosedPlatform.instance.requestPermissions();
  }

  @override
  Future<String?> getPoem() {
    return _EcosedPlatform.instance.getPoem();
  }

  @override
  Future<String?> getShizukuVersion() {
    return _EcosedPlatform.instance.getShizukuVersion();
  }

  @override
  Future<List?> getPluginList() {
    return _EcosedPlatform.instance.getPluginList();
  }
}

class _MethodChannelFlutterEcosed extends _EcosedPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  @override
  Future<bool?> isShizukuInstalled() async {
    return await methodChannel.invokeMethod<bool>(
      'isShizukuInstalled',
      {'channel': serviceChannel},
    );
  }

  @override
  void installShizuku() {
    methodChannel.invokeMethod<void>(
      'installShizuku',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<bool?> isMicroGInstalled() async {
    return await methodChannel.invokeMethod<bool>(
      'isMicroGInstalled',
      {'channel': serviceChannel},
    );
  }

  @override
  void installMicroG() {
    methodChannel.invokeMethod<void>(
      'installMicroG',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<bool?> isShizukuGranted() async {
    return await methodChannel.invokeMethod<bool>(
      'isShizukuGranted',
      {'channel': serviceChannel},
    );
  }

  @override
  void requestPermissions() {
    methodChannel.invokeMethod<void>(
      'requestPermissions',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<String?> getPoem() async {
    return await methodChannel.invokeMethod<String>(
      'getPoem',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<String?> getShizukuVersion() async {
    return await methodChannel.invokeMethod<String>(
      'getShizukuVersion',
      {'channel': serviceChannel},
    );
  }

  /// 通过引擎实现
  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeMethod<List>(
      'getPlugins',
      {'channel': engineChannel},
    );
  }
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
        widget.pluginChannel(),
        isShizukuInstalledMethod,
      ) as bool;
    } on PlatformException {
      shizukuInstalled = false;
    }
    // 获取谷歌基础服务(microG)是否已安装
    try {
      microGInstalled = await _exec(
        widget.pluginChannel(),
        isMicroGInstalledMethod,
      ) as bool;
    } on PlatformException {
      microGInstalled = false;
    }
    // 获取Shizuku权限是否已授权
    try {
      shizukuGranted = await _exec(
        widget.pluginChannel(),
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
          widget.pluginChannel(),
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
