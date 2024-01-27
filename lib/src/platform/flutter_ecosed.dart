import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import '../value/default.dart';
import 'flutter_ecosed_platform_interface.dart';
import 'flutter_ecosed_wrapper.dart';

class FlutterEcosed extends EcosedPlugin implements EcosedWrapper {
  const FlutterEcosed({super.key});

  @override
  String pluginName() => 'Platform';

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => platformChannel;

  @override
  String pluginDescription() => 'Ecosed Platform';

  @override
  Object? onEcosedMethodCall(String name) {
    switch (name) {
      case 'platform':
        return getPlatformVersion();
      case pluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

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
}

class _FlutterEcosedState extends State<FlutterEcosed> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
