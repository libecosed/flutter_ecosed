abstract interface class BridgeWrapper {
  /// 获取插件列表
  Future<List?> getPlatformPluginList();

  /// 打开对话框
  Future<void> openPlatformDialog();

  /// 关闭对话框
  Future<void> closePlatformDialog();
}
