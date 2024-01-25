import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosed extends EcosedPlugin {
  const FlutterEcosed({super.key});

  Future<String?> getPlatformVersion() {
    return FlutterEcosedPlatform.instance.getPlatformVersion();
  }

  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }

  @override
  State<FlutterEcosed> createState() => _FlutterEcosedState();

  @override
  String pluginName() {
    return 'FlutterEcosed';
  }
}

class _FlutterEcosedState extends State<FlutterEcosed> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
