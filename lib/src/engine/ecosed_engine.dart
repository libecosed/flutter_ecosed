import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app.dart';
import '../platform/flutter_ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../values/methods.dart';
import 'engine_state.dart';
import 'engine_wrapper.dart';

base mixin EcosedEngine<T extends EcosedApp> on State<T>
    implements EcosedPlugin, EngineWrapper, FlutterEcosedPlatform {
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

  /// 引擎状态
  EngineState _engineState = EngineState.uninitialized;

  @override
  void initState() {
    _initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_app';

  @override
  String pluginDescription() => widget.title;

  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case getPluginMethod:
        return await getPlatformPluginList();
      case openDialogMethod:
        openPlatformDialog();
        return null;
      case closeDialogMethod:
        closePlatformDialog();
        return null;
      default:
        return null;
    }
  }

  @override
  Widget pluginWidget(BuildContext context) {
    return widget;
  }

  /// 执行插件代码
  @override
  Future<dynamic> exec(String channel, String method) async {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel() == channel) {
          return await element.onMethodCall(method);
        }
      }
    }
    return null;
  }

  /// 获取引擎状态
  @override
  EngineState getEngineState() => _engineState;

  /// 打开对话框
  @override
  void openDialog(BuildContext context) {
    exec(pluginChannel(), openDialogMethod);
  }

  @override
  void closeDialog() {
    exec(pluginChannel(), closeDialogMethod);
  }

  /// 统计普通插件数量
  @override
  int pluginCount() {
    var count = 0;
    for (var element in _pluginList) {
      if (element.pluginChannel() != pluginChannel()) {
        count++;
      }
    }
    return count;
  }

  ///获取插件信息列表
  @override
  List<PluginDetails> getPluginDetailsList() => _pluginDetailsList;

  /// 获取插件类型
  @override
  String getPluginType(PluginDetails details) {
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
  @override
  bool isAllowPush(PluginDetails details) {
    return details.type == PluginType.flutter &&
        _getPlugin(details.channel) != null;
  }

  /// 打开插件页面
  @override
  void launchPlugin(BuildContext context, PluginDetails details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _getPlugin(details.channel)!.pluginWidget(context),
      ),
    );
  }

  @override
  Future<List?> getPlatformPluginList() {
    return FlutterEcosedPlatform.instance.getPlatformPluginList();
  }

  @override
  void openPlatformDialog() {
    FlutterEcosedPlatform.instance.openPlatformDialog();
  }

  @override
  void closePlatformDialog() {
    FlutterEcosedPlatform.instance.closePlatformDialog();
  }

  /// 加载插件
  Future<void> _initPlatformState() async {
    // 内置插件列表
    List<EcosedPlugin> initialPluginList = [];
    // 插件详细信息列表
    List<PluginDetails> pluginDetailsList = [];
    //预加载Dart层关键内置插件
    // 遍历内部插件
    for (var element in [this]) {
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
    // 添加native层内置插件
    try {
      // 遍历原生插件
      for (var element
          in (await exec(pluginChannel(), getPluginMethod) as List? ??
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
      pluginDetailsList.add(
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
        _engineState = EngineState.running;
      });
    } else {
      return;
    }
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
}
