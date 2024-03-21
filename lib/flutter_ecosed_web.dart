import 'dart:html' as html show window;

import 'package:flutter_ecosed/src/platform/flutter_ecosed_method_channel.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterEcosedWeb extends FlutterEcosedPlatform {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    FlutterEcosedPlatform.instance = FlutterEcosedWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
