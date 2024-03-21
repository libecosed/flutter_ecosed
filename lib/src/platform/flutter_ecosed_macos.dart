

import 'flutter_ecosed_method_channel.dart';

class FlutterEcosedMacOS extends FlutterEcosedPlatform {
  FlutterEcosedMacOS();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedMacOS();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return 'macos';
  }
}
