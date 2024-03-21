import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ecosed_platform_interface.dart';





abstract class FlutterEcosedPlatform extends PlatformInterface {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEcosedPlatform _instance = MethodChannelFlutterEcosed();

  static FlutterEcosedPlatform get instance => _instance;

  static set instance(FlutterEcosedPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList()方法未实现');
  }

  void openDialog() {
    throw UnimplementedError('openDialog()方法未实现');
  }

  void openPubDev() {
    throw UnimplementedError('openPubDev()方法未实现');
  }
}
