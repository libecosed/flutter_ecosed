import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/value/default_info.dart';

import '../platform/flutter_ecosed.dart';
import '../plugin/plugin.dart';
import 'wrapper.dart';

class EcosedEngine extends EcosedPlugin implements EngineWrapper {
  const EcosedEngine({super.key, required this.plugins});

  final List<EcosedPlugin> plugins;

  @override
  String pluginName() => 'EcosedEngine';

  @override
  void attach() {

  }

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => 'flutter_ecosed_engine';

  @override
  String pluginDescription() => 'dart层引擎';

  @override
  Object onEcosedMethodCall(String name) {
    return '';
  }

  @override
  Object? execPluginCall(String name) {
    return null;
  }

  @override
  State<EcosedEngine> createState() {
    return _EcosedEngineState();
  }

  @override
  List<EcosedPlugin> initialPlugin() {
    return [this, const FlutterEcosed()];
  }
}

class _EcosedEngineState extends State<EcosedEngine> {
  //_EcosedEngineState(this.pluginList);

  List<EcosedPlugin> pluginList = [];

  @override
  void initState() {
    ///添加内置插件
    for (var element in widget.initialPlugin()) {
      pluginList.add(element);
    }
    /// 添加插件
    for (var element in widget.plugins) {
      pluginList.add(element);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
