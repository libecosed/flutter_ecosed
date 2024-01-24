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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList() has not been implemented.');
  }
}
