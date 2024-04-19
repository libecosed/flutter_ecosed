library flutter_ecosed_web;

import 'dart:html' as html show window;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/platform/flutter_ecosed_platform.dart';

final class FlutterEcosedWeb extends FlutterEcosedPlatform {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    FlutterEcosedPlatform.instance = FlutterEcosedWeb();
  }

  @override
  Future<List?> getPlatformPluginList() async => [];

  @override
  void openPlatformDialog() {
    html.window.alert('the function unsupported web');
  }

  @override
  void closePlatformDialog() {
    html.window.alert('the function unsupported web');
  }
}
