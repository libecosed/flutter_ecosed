import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class EcosedPlatformInterface extends PlatformInterface {
  EcosedPlatformInterface() : super(token: _token);

  /// 令牌
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
  Future<List?> getPlatformPluginList() async {
    throw UnimplementedError('getPlatformPluginList()方法未实现');
  }

  /// 打开对话框
  Future<bool?> openPlatformDialog() async {
    throw UnimplementedError('openPlatformDialog()方法未实现');
  }

  /// 关闭对话框
  Future<bool?> closePlatformDialog() async {
    throw UnimplementedError('closePlatformDialog()方法未实现');
  }
}

final class DefaultPlatform extends EcosedPlatformInterface {
  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return List.empty();
  }

  /// 打开对话框
  @override
  Future<bool?> openPlatformDialog() async {
    debugPrint('openPlatformDialog: the function unsupported the platform.');
    return false;
  }

  /// 关闭对话框
  @override
  Future<bool?> closePlatformDialog() async {
    debugPrint('closePlatformDialog: the function unsupported the platform.');
    return false;
  }
}
