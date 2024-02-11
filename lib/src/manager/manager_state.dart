import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../flutter_ecosed.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/default.dart';

class EcosedManagerState extends State<EcosedManager> {
  /// 占位用空模块
  static const String _unknownPlugin =
      '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown"}';

  /// Dart层插件列表
  List<EcosedPlugin> _pluginList = [];

  List<PluginDetails> _pluginDetailsList = [
    PluginDetails.formJSON(jsonDecode(_unknownPlugin), PluginType.unknown, true)
  ];

  /// 加载状态
  @override
  void initState() {
    if (Platform.isAndroid) {
      _initPlatformState();
    }
    super.initState();
  }

  /// 加载插件
  Future<void> _initPlatformState() async {
    // 内置插件列表
    List<EcosedPlugin> initialPluginList = [];

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

  EcosedPlugin? _plugin(PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  String _getType(PluginDetails details) {
    switch (details.type) {
      case PluginType.native:
        return '内置插件 - Platform';
      case PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件';
      default:
        return 'Unknown';
    }
  }

  bool _isAllowPush(PluginDetails details) {
    return details.type == PluginType.flutter && _plugin(details) != null;
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
              children: _pluginDetailsList.map(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    element.title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: textTheme.titleMedium?.fontSize,
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
                                      fontSize: textTheme.bodySmall?.fontSize,
                                      fontFamily:
                                          textTheme.bodySmall?.fontFamily,
                                      height: textTheme.bodySmall?.height,
                                    ),
                                  ),
                                  Text(
                                    '作者: ${element.author}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: textTheme.bodySmall?.fontSize,
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
                                  element.type == PluginType.native
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
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
