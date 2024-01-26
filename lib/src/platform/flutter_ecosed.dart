import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import '../value/default_info.dart';
import 'flutter_ecosed_platform_interface.dart';
import 'flutter_ecosed_wrapper.dart';

class FlutterEcosed extends EcosedPlugin implements EcosedWrapper {
  const FlutterEcosed({super.key});

  @override
  Future<String?> getPlatformVersion() {
    return FlutterEcosedPlatform.instance.getPlatformVersion();
  }

  @override
  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }

  @override
  State<FlutterEcosed> createState() => _FlutterEcosedState();

  @override
  String pluginName() {
    return 'FlutterEcosed';
  }

  @override
  String pluginAuthor() {
    return defaultAuthor;
  }

  @override
  String pluginChannel() {
    return 'flutter_ecosed';
  }

  @override
  String pluginDescription() {
    return '平台方法调用';
  }

  @override
  Object? onEcosedMethodCall(String name) {
    switch (name) {
      case 'platform':
        return getPlatformVersion();
      case 'plugins':
        return getPluginList();
      default:
        return null;
    }
  }
}

class _FlutterEcosedState extends State<FlutterEcosed> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
