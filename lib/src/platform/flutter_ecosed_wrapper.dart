abstract class EcosedWrapper {

  Future<bool?> isShizukuInstalled();
  void installShizuku();
  Future<bool?> isMicroGInstalled();
  void installMicroG();
  Future<bool?> isShizukuGranted();
  void requestPermissions();

  Future<String?> getPoem();
  Future<String?> getShizukuVersion();

  Future<List?> getPluginList();
}
