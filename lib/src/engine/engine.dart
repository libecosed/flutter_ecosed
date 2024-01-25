import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/value/default_info.dart';

import '../plugin/plugin.dart';
import 'wrapper.dart';

class EcosedEngine extends EcosedPlugin implements EngineWrapper {
  const EcosedEngine({super.key});

  @override
  State<EcosedEngine> createState() => _EcosedEngineState();

  @override
  String pluginName() => 'EcosedEngine';

  @override
  void attach() {}

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => 'flutter_ecosed_engine';

  @override
  String pluginDescription() => 'dart层引擎';
}

class _EcosedEngineState extends State<EcosedEngine> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
