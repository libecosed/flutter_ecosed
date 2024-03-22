import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterEcosedPlatform extends PlatformInterface {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  /// 实例
  static late FlutterEcosedPlatform _instance;

  /// 获取实例
  static FlutterEcosedPlatform get instance => _instance;

  /// 设置实例
  static set instance(FlutterEcosedPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 获取插件列表
  Future<List?> getPluginList() {
    throw UnimplementedError('getPluginList()方法未实现');
  }

  /// 打开对话框
  void openDialog() {
    throw UnimplementedError('openDialog()方法未实现');
  }
}
