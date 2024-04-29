import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../bridge/bridge_wrapper.dart';
import 'default_platform.dart';

abstract class EcosedPlatformInterface extends PlatformInterface
    implements BridgeWrapper {
  EcosedPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  /// 实例
  static EcosedPlatformInterface _instance = DefaultPlatform();

  /// 获取实例
  static EcosedPlatformInterface get instance => _instance;

  /// 设置实例
  static set instance(EcosedPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    throw UnimplementedError('getPlatformPluginList()方法未实现');
  }

  /// 打开对话框
  @override
  Future<void> openPlatformDialog() async {
    throw UnimplementedError('openPlatformDialog()方法未实现');
  }

  @override
  Future<void> closePlatformDialog() async {
    throw UnimplementedError('closePlatformDialog()方法未实现');
  }
}
