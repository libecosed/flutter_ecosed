abstract class BridgeWrapper {
  /// 获取插件列表
  Future<List?> getAndroidPluginList();

  /// 打开对话框
  void openAndroidDialog();

    /// 关闭对话框
  void closeAndroidDialog();
}
