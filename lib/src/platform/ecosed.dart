import '../interface/ecosed_platform.dart';

base mixin class FlutterEcosed implements EcosedPlatform {
  /// 平台实例
  final EcosedPlatform _instance = EcosedPlatform.instance;

  @override
  Future<bool?> closePlatformDialog() async {
    return await _instance.closePlatformDialog();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return await _instance.getPlatformPluginList();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _instance.openPlatformDialog();
  }
}
