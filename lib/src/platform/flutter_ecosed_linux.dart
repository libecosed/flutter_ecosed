



import 'flutter_ecosed_method_channel.dart';

class FlutterEcosedLinux extends FlutterEcosedPlatform {
  FlutterEcosedLinux();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedLinux();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return 'macos';
  }
}
