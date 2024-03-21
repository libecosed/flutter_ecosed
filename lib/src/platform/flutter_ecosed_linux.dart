import 'flutter_ecosed_method_channel.dart';

class FlutterEcosedLinux extends FlutterEcosedPlatform {
  FlutterEcosedLinux();

  static void registerWith() {
    FlutterEcosedPlatform.instance = FlutterEcosedLinux();
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
