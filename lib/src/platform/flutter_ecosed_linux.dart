import 'flutter_ecosed_platform.dart';

class FlutterEcosedLinux extends FlutterEcosedPlatform {
  FlutterEcosedLinux();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedLinux();
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
