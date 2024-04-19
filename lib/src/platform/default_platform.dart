import 'flutter_ecosed_platform.dart';

final class DefaultPlatform extends FlutterEcosedPlatform {
  @override
  Future<List?> getPlatformPluginList() async => [];

  @override
  void openPlatformDialog() {}

  @override
  void closePlatformDialog() {}
}
