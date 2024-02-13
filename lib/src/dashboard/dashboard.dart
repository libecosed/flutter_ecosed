import 'package:flutter/material.dart';

import '../platform/flutter_ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../values/default.dart';
import 'dashboard_state.dart';
import 'dashboard_wrapper.dart';

class EcosedDashboardView extends EcosedPlugin
    implements EcosedManagerWrapper, FlutterEcosedPlatform {
  const EcosedDashboardView({super.key, required this.plugins});

  final List<EcosedPlugin> plugins;

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
  Future<Object?> onPlatformCall(String name) async {
    switch (name) {
      case getPluginMethod:
        return getPluginList();
      default:
        return null;
    }
  }

  @override
  State<EcosedDashboardView> createState() => EcosedDashboardViewState();

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
}
