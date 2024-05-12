import 'bridge_wrapper.dart';
import 'platform_interface.dart';

class NativeBridge implements BridgeWrapper {
  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await AndroidPlatform.instance.getPlatformPluginList();
  }

  /// 打开对话框
  @override
  Future<void> openPlatformDialog() async {
    return await AndroidPlatform.instance.openPlatformDialog();
  }

  /// 关闭对话框
  @override
  Future<void> closePlatformDialog() async {
    return await AndroidPlatform.instance.closePlatformDialog();
  }
}
