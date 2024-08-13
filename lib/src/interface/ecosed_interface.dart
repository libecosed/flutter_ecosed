import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../entry/default_entry.dart';
import '../type/runner.dart';

/// 实现平台接口的抽象类
abstract class EcosedInterface extends PlatformInterface {
  EcosedInterface() : super(token: _token);

  /// 令牌
  static final Object _token = Object();

  /// 实例
  static EcosedInterface _instance = DefaultEntry();

  /// 获取实例
  static EcosedInterface get instance => _instance;

  /// 设置实例
  static set instance(EcosedInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 运行应用
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    throw UnimplementedError(
      '未实现runEcosedApp()方法, $error',
    );
  }
}
