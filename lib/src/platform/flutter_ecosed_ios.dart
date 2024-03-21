

import 'flutter_ecosed_method_channel.dart';

class FlutterEcosedIOS extends FlutterEcosedPlatform {
  FlutterEcosedIOS();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedIOS();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return 'macos';
  }
}
