import 'package:flutter/material.dart';

import 'plugin.dart';

class EcosedEngine extends EcosedPlugin {
  const EcosedEngine({super.key});

  @override
  State<EcosedEngine> createState() => _EcosedEngineState();

  @override
  String pluginName() => 'EcosedEngine';
}

class _EcosedEngineState extends State<EcosedEngine> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
