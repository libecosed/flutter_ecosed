import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/platform/flutter_ecosed_platform.dart';

class FlutterEcosedWeb extends FlutterEcosedPlatform {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    FlutterEcosedPlatform.instance = FlutterEcosedWeb();
  }

  @override
  Future<List?> getPluginList() async {
    return [];
  }

  @override
  void openDialog() {
    html.window.alert('此功能不支持Web');
  }

  @override
  void openPubDev() {
    html.window.location.href = 'https://pub.dev/packages/flutter_ecosed';
  }
}
