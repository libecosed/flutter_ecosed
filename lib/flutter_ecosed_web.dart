import 'dart:html' as html show window;

import 'package:flutter_ecosed/src/platform/flutter_ecosed_method_channel.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterEcosedWeb extends FlutterEcosedPlatform {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    FlutterEcosedPlatform.instance = FlutterEcosedWeb();
  }

  @override
  Future<List?> getPluginList() async {
    return null;
  }

  @override
  void openDialog() {}

  @override
  void openPubDev() {
    html.window.location.href = 'https://pub.dev/packages/flutter_ecosed';
  }
}
