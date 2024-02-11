import 'package:flutter/material.dart';

import '../platform/ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../values/default.dart';
import 'manager_state.dart';
import 'manager_wrapper.dart';

class EcosedManager extends EcosedPlugin implements EcosedManagerWrapper, EcosedPlatform {
  const EcosedManager({super.key});

  @override
  String pluginName() => 'Manager';

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => managerChannel;

  @override
  String pluginDescription() => 'Manager';

  @override
  Widget pluginWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcosedApp')),
      body: const Center(
        child: Text('App'),
      ),
    );
  }

  @override
  Future<Object?> onEcosedMethodCall(String name) async {
    switch (name) {
      case getPluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  State<EcosedManager> createState() => EcosedManagerState();

  @override
  List<EcosedPlugin> initialPlugin() => [this];

  @override
  Future<bool?> isShizukuInstalled() {
    return EcosedPlatform.instance.isShizukuInstalled();
  }

  @override
  void installShizuku() {
    EcosedPlatform.instance.installShizuku();
  }

  @override
  Future<bool?> isMicroGInstalled() {
    return EcosedPlatform.instance.isMicroGInstalled();
  }

  @override
  void installMicroG() {
    EcosedPlatform.instance.installMicroG();
  }

  @override
  Future<bool?> isShizukuGranted() {
    return EcosedPlatform.instance.isShizukuGranted();
  }

  @override
  void requestPermissions() {
    EcosedPlatform.instance.requestPermissions();
  }

  @override
  Future<String?> getPoem() {
    return EcosedPlatform.instance.getPoem();
  }

  @override
  Future<String?> getShizukuVersion() {
    return EcosedPlatform.instance.getShizukuVersion();
  }

  @override
  Future<List?> getPluginList() {
    return EcosedPlatform.instance.getPluginList();
  }
}