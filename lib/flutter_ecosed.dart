/// flutter_ecosed.
library flutter_ecosed;

import 'src/platform/entry.dart';
import 'src/platform/interface.dart';

export 'src/export/export.dart';
export 'src/plugin/plugin.dart';

/// 平台插件注册
final class EcosedPlatformRegister {
  const EcosedPlatformRegister();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}
