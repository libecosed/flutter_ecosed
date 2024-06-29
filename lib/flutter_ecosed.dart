/// flutter_ecosed.
library flutter_ecosed;

import 'src/platform/platform_entry.dart';
import 'src/platform/platform_interface.dart';

export 'src/export/export.dart';

/// 平台插件注册
final class EcosedPlatformRegister {
  const EcosedPlatformRegister();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}
