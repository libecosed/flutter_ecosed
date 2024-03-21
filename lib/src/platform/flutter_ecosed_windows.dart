

import 'flutter_ecosed_method_channel.dart';


class FlutterEcosedWindows extends FlutterEcosedPlatform {
  FlutterEcosedWindows();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedWindows();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return 'macos';
  }
}
