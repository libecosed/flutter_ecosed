import 'flutter_ecosed_platform_interface.dart';

class FlutterEcosedWindows extends FlutterEcosedPlatform {
  FlutterEcosedWindows();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedWindows();
  }

  @override
  Future<List?> getPluginList() {
    // TODO: implement getPluginList
    return super.getPluginList();
  }

  @override
  void openDialog() {
    // TODO: implement openDialog
    super.openDialog();
  }

  @override
  void openPubDev() {
    // TODO: implement openPubDev
    super.openPubDev();
  }
}
