import 'flutter_ecosed_platform_interface.dart';

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
