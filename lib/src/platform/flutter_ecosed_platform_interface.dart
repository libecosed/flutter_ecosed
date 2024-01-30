import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ecosed_method_channel.dart';

abstract class FlutterEcosedPlatform extends PlatformInterface {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEcosedPlatform _instance = MethodChannelFlutterEcosed();

  static FlutterEcosedPlatform get instance => _instance;

  static set instance(FlutterEcosedPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isShizukuInstalled() {
    throw UnimplementedError('isShizukuInstalled() has not been implemented.');
  }

  void installShizuku() {
    throw UnimplementedError('installShizuku() has not been implemented.');
  }

  Future<bool?> isMicroGInstalled() {
    throw UnimplementedError('isMicroGInstalled() has not been implemented.');
  }

  void installMicroG() {
    throw UnimplementedError('installMicroG() has not been implemented.');
  }

  Future<bool?> isShizukuGranted() {
    throw UnimplementedError('isShizukuGranted() has not been implemented.');
  }

  void requestPermissions() {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  Future<String?> getPoem() {
    throw UnimplementedError('getPoem() has not been implemented.');
  }

  Future<String?> getShizukuVersion() {
    throw UnimplementedError('getShizukuVersion() has not been implemented.');
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList() has not been implemented.');
  }
}
