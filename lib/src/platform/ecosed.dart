import '../interface/ecosed_platform.dart';

final class FlutterEcosed implements EcosedPlatform {
  /// 平台实例
  final EcosedPlatform _platform = EcosedPlatform.instance;

  @override
  Future<bool?> closePlatformDialog() async {
    return await _platform.closePlatformDialog();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return await _platform.getPlatformPluginList();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _platform.openPlatformDialog();
  }
}
