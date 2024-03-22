import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosedIOS extends FlutterEcosedPlatform {
  FlutterEcosedIOS();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedIOS();
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
