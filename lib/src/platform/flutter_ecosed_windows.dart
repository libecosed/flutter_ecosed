import 'flutter_ecosed_platform.dart';

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
