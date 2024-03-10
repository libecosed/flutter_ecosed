import 'package:flutter/material.dart';

import '../platform/flutter_ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../values/method.dart';
import 'app_state.dart';
import 'app_type.dart';
import 'app_wrapper.dart';

class EcosedApp extends EcosedPlugin
    implements AppWrapper, FlutterEcosedPlatform {
  const EcosedApp({
    super.key,
    required this.title,
    required this.home,
    required this.scaffold,
    required this.location,
    required this.plugins,
  });

  final String title;
  final EcosedApps home;
  final EcosedScaffold scaffold;
  final BannerLocation location;
  final List<EcosedPlugin> plugins;

  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_app';

  @override
  String pluginDescription() => title;

  @override
  Future<Object?> onPlatformCall(String name) async {
    switch (name) {
      case getPluginMethod:
        return getPluginList();
      case openDialogMethod:
        openDialog();
        return null;
      case openPubDevMethod:
        openPubDev();
        return null;
      default:
        return null;
    }
  }

  @override
  State<EcosedApp> createState() => EcosedAppState();

  @override
  List<EcosedPlugin> initialPlugin() => [this];

  @override
  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }

  @override
  void openDialog() {
    FlutterEcosedPlatform.instance.openDialog();
  }

  @override
  void openPubDev() {
    FlutterEcosedPlatform.instance.openPubDev();
  }
}
