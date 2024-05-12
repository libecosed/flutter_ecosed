import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bridge_wrapper.dart';
import 'method_channel.dart';

abstract class AndroidPlatform extends PlatformInterface
    implements BridgeWrapper {
  AndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AndroidPlatform _instance = MethodChannelAndroid();

  static AndroidPlatform get instance => _instance;

  static set instance(AndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  Future<List?> getPlatformPluginList() {
    throw UnimplementedError('getPlatformPluginList()方法未实现');
  }

  @override
  Future<void> openPlatformDialog() {
    throw UnimplementedError('openPlatformDialog()方法未实现');
  }

  @override
  Future<void> closePlatformDialog() {
    throw UnimplementedError('closePlatformDialog()方法未实现');
  }
}
