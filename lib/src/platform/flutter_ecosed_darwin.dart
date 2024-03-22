import 'flutter_ecosed_platform.dart';

class FlutterEcosedDarwin extends FlutterEcosedPlatform {
  FlutterEcosedDarwin();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedDarwin();
  }

  @override
  Future<List?> getPluginList() async {
    return ['{'
      '"channel":"unknown",'
      '"title":"darwin",'
      '"description":"unknown",'
      '"author":"unknown"'
      '}'];
  }

  @override
  void openDialog() {}

  @override
  void openPubDev() {}
}
