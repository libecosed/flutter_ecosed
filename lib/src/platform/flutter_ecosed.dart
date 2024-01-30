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
  Future<Object?> onEcosedMethodCall(String name) async {
    switch (name) {
      case isShizukuInstalledMethod:
        return isShizukuInstalled();
      case installShizukuMethod:
        installShizuku();
        return null;
      case isMicroGInstalledMethod:
        return isMicroGInstalled();
      case installMicroGMethod:
        installMicroG();
        return null;
      case isShizukuGrantedMethod:
        return isShizukuGranted();
      case requestPermissionsMethod:
        requestPermissions();
        return null;
      case getPluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  Future<bool?> isShizukuInstalled() {
    return FlutterEcosedPlatform.instance.isShizukuInstalled();
  }

  @override
  void installShizuku() {
    FlutterEcosedPlatform.instance.installShizuku();
  }

  @override
  Future<bool?> isMicroGInstalled() {
    return FlutterEcosedPlatform.instance.isMicroGInstalled();
  }

  @override
  void installMicroG() {
    FlutterEcosedPlatform.instance.installMicroG();
  }

  @override
  Future<bool?> isShizukuGranted() {
    return FlutterEcosedPlatform.instance.isShizukuGranted();
  }

  @override
  void requestPermissions() {
    FlutterEcosedPlatform.instance.requestPermissions();
  }

  @override
  Future<String?> getPoem() {
    return FlutterEcosedPlatform.instance.getPoem();
  }

  @override
  Future<String?> getShizukuVersion() {
    return FlutterEcosedPlatform.instance.getShizukuVersion();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ecosed Platform')),
      body: Center(
        child: Text('Platform'),
      ),
    );
  }
}
