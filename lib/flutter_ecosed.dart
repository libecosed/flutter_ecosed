/// flutter_ecosed.
library flutter_ecosed;

import 'src/platform/platform_interface.dart';
import 'src/runtime/runtime.dart';

export 'src/entry/entry.dart';
export 'src/plugin/plugin.dart';
export 'src/invoke/invoke.dart';

/// 平台插件注册
final class FlutterEcosedPlatform {
  const FlutterEcosedPlatform();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedRuntime();
  }
}
