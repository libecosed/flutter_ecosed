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
///

library flutter_ecosed;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef EcosedExec = Object? Function(String channel, String method);
typedef MaterialEcosedHome = Widget Function(Widget body, EcosedExec exec);
typedef MaterialEcosedApp = MaterialApp Function(
    Widget home, TransitionBuilder build, String title);

enum _PluginType { native, flutter, unknown }

const String _defaultAuthor = 'wyq0918dev';
const String _appChannel = 'ecosed_app';

const String _engineChannel = 'ecosed_engine';
const String _serviceChannel = 'ecosed_service';

const String _getPluginMethod = 'get_plugins';

abstract class _EcosedAppWrapper {
  List<_EcosedPlugin> initialPlugin();
}

abstract class _EcosedPlatform extends PlatformInterface {
  _EcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static final _EcosedPlatform _instance = _MethodChannelFlutterEcosed();

  static _EcosedPlatform get instance => _instance;

  Future<bool?> isShizukuInstalled() {
    throw UnimplementedError('isShizukuInstalled()方法未实现');
  }

  void installShizuku() {
    throw UnimplementedError('installShizuku()方法未实现');
  }

  Future<bool?> isMicroGInstalled() {
    throw UnimplementedError('isMicroGInstalled()方法未实现');
  }

  void installMicroG() {
    throw UnimplementedError('installMicroG()方法未实现');
  }

  Future<bool?> isShizukuGranted() {
    throw UnimplementedError('isShizukuGranted()方法未实现');
  }

  void requestPermissions() {
    throw UnimplementedError('requestPermissions()方法未实现');
  }

  Future<String?> getPoem() {
    throw UnimplementedError('getPoem()方法未实现');
  }

  Future<String?> getShizukuVersion() {
    throw UnimplementedError('getShizukuVersion()方法未实现');
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList()方法未实现');
  }
}

abstract class _EcosedPlugin extends StatefulWidget {
  const _EcosedPlugin({super.key});

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

class _PluginDetails {
  const _PluginDetails(
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
  final _PluginType type;
  final bool initial;

  factory _PluginDetails.formJSON(
      Map<String, dynamic> json, _PluginType type, bool initial) {
    return _PluginDetails(
      channel: json['channel'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      type: type,
      initial: initial,
    );
  }
}

class EcosedManager extends _EcosedPlugin
    implements _EcosedAppWrapper, _EcosedPlatform {
  const EcosedManager({super.key});

  @override
  String pluginName() => 'Manager';

  @override
  String pluginAuthor() => _defaultAuthor;

  @override
  String pluginChannel() => _appChannel;

  @override
  String pluginDescription() => 'Manager';

  @override
  Widget pluginWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcosedApp')),
      body: const Center(
        child: Text('App'),
      ),
    );
  }

  @override
  Future<Object?> onEcosedMethodCall(String name) async {
    switch (name) {
      case _getPluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  State<EcosedManager> createState() => _EcosedAppState();

  @override
  List<_EcosedPlugin> initialPlugin() => [this];

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
      {'channel': _serviceChannel},
    );
  }

  @override
  void installShizuku() {
    methodChannel.invokeMethod<void>(
      'installShizuku',
      {'channel': _serviceChannel},
    );
  }

  @override
  Future<bool?> isMicroGInstalled() async {
    return await methodChannel.invokeMethod<bool>(
      'isMicroGInstalled',
      {'channel': _serviceChannel},
    );
  }

  @override
  void installMicroG() {
    methodChannel.invokeMethod<void>(
      'installMicroG',
      {'channel': _serviceChannel},
    );
  }

  @override
  Future<bool?> isShizukuGranted() async {
    return await methodChannel.invokeMethod<bool>(
      'isShizukuGranted',
      {'channel': _serviceChannel},
    );
  }

  @override
  void requestPermissions() {
    methodChannel.invokeMethod<void>(
      'requestPermissions',
      {'channel': _serviceChannel},
    );
  }

  @override
  Future<String?> getPoem() async {
    return await methodChannel.invokeMethod<String>(
      'getPoem',
      {'channel': _serviceChannel},
    );
  }

  @override
  Future<String?> getShizukuVersion() async {
    return await methodChannel.invokeMethod<String>(
      'getShizukuVersion',
      {'channel': _serviceChannel},
    );
  }

  /// 通过引擎实现
  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeMethod<List>(
      'getPlugins',
      {'channel': _engineChannel},
    );
  }
}

class _EcosedAppState extends State<EcosedManager> {
  /// 占位用空模块
  static const String _unknownPlugin =
      '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown"}';

  /// Dart层插件列表
  List<_EcosedPlugin> _pluginList = [];

  List<_PluginDetails> _pluginDetailsList = [
    _PluginDetails.formJSON(
        jsonDecode(_unknownPlugin), _PluginType.unknown, true)
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
    List<_EcosedPlugin> initialPluginList = [];

    // 插件详细信息列表
    List<_PluginDetails> pluginDetailsList = [];

    //预加载Dart层关键内置插件
    if (widget.initialPlugin().isNotEmpty) {
      // 遍历内部插件
      for (var element in widget.initialPlugin()) {
        // 添加到内置插件列表
        initialPluginList.add(element);
        // 添加到插件详细信息列表
        pluginDetailsList.add(
          _PluginDetails(
            channel: element.pluginChannel(),
            title: element.pluginName(),
            description: element.pluginDescription(),
            author: element.pluginAuthor(),
            type: _PluginType.flutter,
            initial: true,
          ),
        );
      }
      // 设置插件列表
      _pluginList = initialPluginList;
    }
    // 加载详细信息

    // 添加native层内置插件
    if (Platform.isAndroid) {
      try {
        // 遍历原生插件
        for (var element in (await _exec(
              widget.pluginChannel(),
              _getPluginMethod,
            ) as List? ??
            [_unknownPlugin])) {
          // 添加到插件详细信息列表
          pluginDetailsList.add(
            _PluginDetails.formJSON(
              jsonDecode(element),
              _PluginType.native,
              true,
            ),
          );
        }
      } on PlatformException {
        pluginDetailsList.add(_pluginDetailsList.first);
      }
    }
    // 设置状态，更新界面
    if (mounted) {
      setState(() {
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

  _EcosedPlugin? _plugin(_PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  String _getType(_PluginDetails details) {
    switch (details.type) {
      case _PluginType.native:
        return '内置插件 - Platform';
      case _PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件';
      default:
        return 'Unknown';
    }
  }

  bool _isAllowPush(_PluginDetails details) {
    return details.type == _PluginType.flutter && _plugin(details) != null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Scrollbar(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const FlutterLogo(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flutter Ecosed',
                                textAlign: TextAlign.left,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Powered by Flutter Ecosed',
                                textAlign: TextAlign.left,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '应用版本',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyLarge,
                            ),
                            Text(
                              '1.0',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '内核版本',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyLarge,
                            ),
                            Text(
                              '1.0',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '设备架构',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyLarge,
                            ),
                            Text(
                              '1.0',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Shizuku版本',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyLarge,
                            ),
                            Text(
                              '1.0',
                              textAlign: TextAlign.start,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Column(
              children: _pluginDetailsList
                  .map(
                    (element) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        element.title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.titleMedium?.fontSize,
                                          fontFamily:
                                              textTheme.titleMedium?.fontFamily,
                                          height: textTheme.bodySmall?.height,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '通道: ${element.channel}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.bodySmall?.fontSize,
                                          fontFamily:
                                              textTheme.bodySmall?.fontFamily,
                                          height: textTheme.bodySmall?.height,
                                        ),
                                      ),
                                      Text(
                                        '作者: ${element.author}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.bodySmall?.fontSize,
                                          fontFamily:
                                              textTheme.bodySmall?.fontFamily,
                                          height: textTheme.bodySmall?.height,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      element.type == _PluginType.native
                                          ? Icon(
                                              Icons.android,
                                              size: IconTheme.of(context).size,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                          : const FlutterLogo(),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                element.description,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: textTheme.bodySmall?.fontSize,
                                  fontFamily: textTheme.bodySmall?.fontFamily,
                                  height: textTheme.bodySmall?.height,
                                  fontWeight: textTheme.bodySmall?.fontWeight,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 4,
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              Row(
                                children: [
                                  Text(
                                    _getType(element),
                                    textAlign: TextAlign.start,
                                    style: textTheme.bodySmall,
                                  ),
                                  const Spacer(flex: 1),
                                  IgnorePointer(
                                    ignoring: !_isAllowPush(element),
                                    child: TextButton(
                                      onPressed: () {
                                        if (_isAllowPush(element)) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  _plugin(element)!
                                                      .pluginWidget(context),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        _isAllowPush(element) ? '打开' : '无界面',
                                        style: TextStyle(
                                          fontFamily:
                                              textTheme.labelMedium?.fontFamily,
                                          fontStyle:
                                              textTheme.labelMedium?.fontStyle,
                                          color: _isAllowPush(element)
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
