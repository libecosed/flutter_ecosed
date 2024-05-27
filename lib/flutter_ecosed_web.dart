library flutter_ecosed_web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'src/platform/ecosed_platform_interface.dart';

final class FlutterEcosedWeb extends EcosedPlatformInterface {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    EcosedPlatformInterface.instance = FlutterEcosedWeb();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return List.empty();
  }

  @override
  Future<List?> getKernelModuleList() async {
    return List.empty();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    web.window.alert('the function unsupported web');
    return false;
  }

  @override
  Future<bool?> closePlatformDialog() async {
    web.window.alert('the function unsupported web');
    return false;
  }
}
