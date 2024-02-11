import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_flutter_ecosed.dart';

abstract class EcosedPlatform extends PlatformInterface {
  EcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static final EcosedPlatform _instance = MethodChannelFlutterEcosed();

  static EcosedPlatform get instance => _instance;

  Future<bool?> isShizukuInstalled() {
    throw UnimplementedError('isShizukuInstalled()方法未实现');
  }

  void installShizuku() {
    throw UnimplementedError('installShizuku()方法未实现');
  }

  Future<bool?> isMicroGInstalled() {
    throw UnimplementedError('isMicroGInstalled()方法未实现');
  }

  void installMicroG() {
    throw UnimplementedError('installMicroG()方法未实现');
  }

  Future<bool?> isShizukuGranted() {
    throw UnimplementedError('isShizukuGranted()方法未实现');
  }

  void requestPermissions() {
    throw UnimplementedError('requestPermissions()方法未实现');
  }

  Future<String?> getPoem() {
    throw UnimplementedError('getPoem()方法未实现');
  }

  Future<String?> getShizukuVersion() {
    throw UnimplementedError('getShizukuVersion()方法未实现');
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList()方法未实现');
  }
}
