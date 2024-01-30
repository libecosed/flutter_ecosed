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
      case pluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }

  @override
  State<FlutterEcosed> createState() => _FlutterEcosedState();

  @override
  Future<String?> getShizukuVersion() {
    // TODO: implement getShizukuVersion
    throw UnimplementedError();
  }

  @override
  void installMicroG() {
    // TODO: implement installMicroG
  }

  @override
  void installShizuku() {
    // TODO: implement installShizuku
  }

  @override
  Future<bool?> isMicroGInstalled() {
    // TODO: implement isMicroGInstalled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isShizukuGranted() {
    // TODO: implement isShizukuGranted
    throw UnimplementedError();
  }

  @override
  Future<bool?> isShizukuInstalled() {
    // TODO: implement isShizukuInstalled
    throw UnimplementedError();
  }

  @override
  void requestPermissions() {
    // TODO: implement requestPermissions
  }
}

class _FlutterEcosedState extends State<FlutterEcosed> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
