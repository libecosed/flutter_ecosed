import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_flutter_ecosed.dart';

abstract class FlutterEcosedPlatform extends PlatformInterface {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static final FlutterEcosedPlatform _instance = MethodChannelFlutterEcosed();

  static FlutterEcosedPlatform get instance => _instance;

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
