import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosedMacOS extends FlutterEcosedPlatform {
  FlutterEcosedMacOS();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedMacOS();
  }

  @override
  Future<List?> getPluginList() async {
    return [];
  }

  @override
  void openDialog() {}

  @override
  void openPubDev() {}
}
