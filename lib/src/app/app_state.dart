import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/method.dart';
import 'app.dart';

class EcosedAppState extends State<EcosedApp> {
  /// 占位用空模块
  static const String _unknownPlugin = '{'
      '"channel":"unknown",'
      '"title":"unknown",'
      '"description":"unknown",'
      '"author":"unknown"'
      '}';

  /// Dart层插件列表
  List<EcosedPlugin> _pluginList = [];

  /// 插件详细信息列表
  List<PluginDetails> _pluginDetailsList = [];

  /// 滚动控制器
  late ScrollController _controller;

  /// 加载状态
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    _initPlatformState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    // 添加native层内置插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(widget.pluginChannel(), getPluginMethod) as List? ??
              [_unknownPlugin])) {
        // 添加到插件详细信息列表
        pluginDetailsList.add(
          PluginDetails.formJSON(
            json: jsonDecode(element),
            type: PluginType.native,
            initial: true,
          ),
        );
      }
    } on PlatformException {
      pluginDetailsList.add(_pluginDetailsList.first);
    }
    // 加载普通插件
    if (widget.plugins.isNotEmpty) {
      for (var element in widget.plugins) {
        _pluginList.add(element);
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
          return await element.onPlatformCall(method);
        }
      }
    }
    return null;
  }

  /// 获取插件
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

  /// 获取插件类型
  String _getType(PluginDetails details) {
    switch (details.type) {
      case PluginType.native:
        return '内置插件 - Platform';
      case PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件 - Flutter';
      default:
        return 'Unknown';
    }
  }

  /// 判断插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return details.type == PluginType.flutter &&
        _getPlugin(details.channel) != null;
  }

  /// 统计普通插件数量
  int _pluginNumber() {
    var number = 0;
    for (var element in _pluginList) {
      if (element.pluginChannel() != widget.pluginChannel()) {
        number++;
      }
    }
    return number;
  }

  /// 打开对话框
  void _openDialog(BuildContext context) {
    //if (!kIsWeb && Platform.isAndroid) {
    _exec(widget.pluginChannel(), openDialogMethod);
    // } else {
    //   _showTopic(context);
    // }
  }

  /// 打开pub.dev
  void _openPubDev(BuildContext context) {
    launchUrl(Uri.parse('https://pub.dev/packages/flutter_ecosed'));
    //   if (!kIsWeb && Platform.isAndroid) {
//    _exec(widget.pluginChannel(), openPubDevMethod);
    // } else {
    //   _showTopic(context);
    // }
  }

  /// 打开插件页面
  void _launchPlugin(BuildContext context, PluginDetails details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _getPlugin(details.channel)!.pluginWidget(context),
      ),
    );
  }

  /// 显示提示
  // void _showTopic(BuildContext context) {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       behavior: SnackBarBehavior.floating,
  //       content: Text('不支持的操作系统'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorScheme = Theme.of(context).colorScheme;
    final platform = Theme.of(context).platform;
    final iconTheme = Theme.of(context).iconTheme;
    return Banner(
      message: 'EcosedApp',
      location: widget.location,
      color: Colors.pinkAccent,
      child: Container(
        child: widget.scaffold(
          Container(
            child: widget.home(
              (channel, method) {
                return _exec(channel, method);
              },
              Scrollbar(
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                          child: Card(
                            color: platform == TargetPlatform.android
                                ? colorScheme.primaryContainer
                                : colorScheme.errorContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Icon(
                                    platform == TargetPlatform.android
                                        ? Icons.check_circle_outline
                                        : Icons.error_outline,
                                    size: iconTheme.size,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            textAlign: TextAlign.left,
                                            style: textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            platform == TargetPlatform.android
                                                ? '一切正常'
                                                : '不支持的操作系统',
                                            textAlign: TextAlign.left,
                                            style: textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _openDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.developer_mode,
                                      size: iconTheme.size,
                                      color: colorScheme.onPrimaryContainer,
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '应用名称',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          widget.title,
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '当前状态',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          platform == TargetPlatform.android
                                              ? '一切正常'
                                              : '不支持的操作系统',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '当前平台',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          platform.name,
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '插件数量',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          _pluginNumber().toString(),
                                          textAlign: TextAlign.start,
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '了解 flutter_ecosed',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          '了解如何使用 flutter_ecosed 进行开发。',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _openPubDev(context);
                                    },
                                    icon: const Icon(Icons.open_in_browser),
                                  )
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
                                  color: colorScheme.surface,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 16, 24, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    element.title,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .titleMedium
                                                          ?.fontSize,
                                                      fontFamily: textTheme
                                                          .titleMedium
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    '通道: ${element.channel}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .bodySmall?.fontSize,
                                                      fontFamily: textTheme
                                                          .bodySmall
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                    ),
                                                  ),
                                                  Text(
                                                    '作者: ${element.author}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .bodySmall?.fontSize,
                                                      fontFamily: textTheme
                                                          .bodySmall
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                element.type ==
                                                        PluginType.native
                                                    ? Icon(
                                                        Icons.android,
                                                        size: iconTheme.size,
                                                        color:
                                                            colorScheme.primary,
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
                                          style: textTheme.bodySmall?.apply(
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
                                                _getType(element),
                                                textAlign: TextAlign.start,
                                                style: textTheme.bodySmall,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: _isAllowPush(element)
                                                  ? () {
                                                      if (element.channel !=
                                                          widget
                                                              .pluginChannel()) {
                                                        _launchPlugin(
                                                          context,
                                                          element,
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  '关于'),
                                                              content: const Text(
                                                                  'flutter_about'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '确认'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              child: Text(
                                                _isAllowPush(element)
                                                    ? element.channel !=
                                                            widget
                                                                .pluginChannel()
                                                        ? '打开'
                                                        : '关于'
                                                    : '无界面',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
