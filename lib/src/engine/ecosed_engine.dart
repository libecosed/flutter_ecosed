library flutter_ecosed;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app.dart';
import '../app/app_wrapper.dart';
import '../platform/flutter_ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/methods.dart';
import '../values/urls.dart';

mixin EcosedEngine on State<EcosedApp>
    implements EcosedPlugin, AppWrapper, FlutterEcosedPlatform {
  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_app';

  @override
  String pluginDescription() => widget.title;

  @override
  Future<Object?> onMethodCall(String name) async {
    switch (name) {
      case getPluginMethod:
        return await getAndroidPluginList();
      case openDialogMethod:
        openAndroidDialog();
        return null;
      default:
        return null;
    }
  }

  @override
  List<EcosedPlugin> initialPlugin() => [this];

  @override
  Future<List?> getAndroidPluginList() {
    return FlutterEcosedPlatform.instance.getAndroidPluginList();
  }

  @override
  void openAndroidDialog() {
    FlutterEcosedPlatform.instance.openAndroidDialog();
  }

  @override
  Widget pluginWidget(BuildContext context) {
    return widget;
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

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
  List<PluginDetails> pluginDetailsList = [];

  /// 加载插件
  Future<void> _initPlatformState() async {
    // 内置插件列表
    List<EcosedPlugin> initialPluginList = [];
    // 插件详细信息列表
    List<PluginDetails> allPluginDetailsList = [];
    //预加载Dart层关键内置插件
    if (initialPlugin().isNotEmpty) {
      // 遍历内部插件
      for (var element in initialPlugin()) {
        // 添加到内置插件列表
        initialPluginList.add(element);
        // 添加到插件详细信息列表
        allPluginDetailsList.add(
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
          in (await exec(pluginChannel(), getPluginMethod) as List? ??
              [_unknownPlugin])) {
        // 添加到插件详细信息列表
        allPluginDetailsList.add(
          PluginDetails.formJSON(
            json: jsonDecode(element),
            type: PluginType.native,
            initial: true,
          ),
        );
      }
    } on PlatformException {
      allPluginDetailsList.add(
        PluginDetails.formJSON(
          json: jsonDecode(_unknownPlugin),
          type: PluginType.unknown,
          initial: true,
        ),
      );
    }
    // 加载普通插件
    if (widget.plugins.isNotEmpty) {
      for (var element in widget.plugins) {
        _pluginList.add(element);
        allPluginDetailsList.add(
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
        pluginDetailsList = allPluginDetailsList;
      });
    } else {
      return;
    }
  }

  /// 执行插件代码
  Future<Object?> exec(String channel, String method) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == channel) {
          return await element.onMethodCall(method);
        }
      }
    }
    return null;
  }

  /// 获取插件
  EcosedPlugin? getPlugin(String channel) {
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
  String getType(PluginDetails details) {
    switch (details.type) {
      case PluginType.native:
        return '内置插件 - Platform';
      case PluginType.flutter:
        return details.initial ? '内置插件 - Flutter' : '普通插件 - Flutter';
      case PluginType.unknown:
        return '未知插件类型';
      default:
        return 'Unknown';
    }
  }

  /// 判断插件是否可以打开
  bool isAllowPush(PluginDetails details) {
    return details.type == PluginType.flutter &&
        getPlugin(details.channel) != null;
  }

  /// 统计普通插件数量
  String pluginCount() {
    var count = 0;
    for (var element in _pluginList) {
      if (element.pluginChannel() != pluginChannel()) {
        count++;
      }
    }
    return count.toString();
  }

  /// 打开对话框
  void openDialog(BuildContext context) {
    exec(pluginChannel(), openDialogMethod);
  }

  /// 打开pub.dev
  void openPubDev(BuildContext context) {
    launchUrl(Uri.parse(pubDev));
  }

  /// 打开插件页面
  void launchPlugin(BuildContext context, PluginDetails details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => getPlugin(details.channel)!.pluginWidget(context),
      ),
    );
  }
}
