import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosed {
  Future<String?> getPlatformVersion() {
    return FlutterEcosedPlatform.instance.getPlatformVersion();
  }

  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }
}
