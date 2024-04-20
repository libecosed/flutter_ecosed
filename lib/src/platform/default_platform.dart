import 'flutter_ecosed_platform.dart';

final class DefaultPlatform extends FlutterEcosedPlatform {
  @override
  Future<List?> getPlatformPluginList() async => [];

  @override
  Future<void> openPlatformDialog() async {}

  @override
  Future<void> closePlatformDialog() async {}
}
