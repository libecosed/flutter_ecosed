import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosedWindows extends FlutterEcosedPlatform {
  FlutterEcosedWindows();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedWindows();
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
