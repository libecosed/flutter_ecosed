/// 平台插件注册及外部访问接口
library flutter_ecosed;

import 'src/platform/platform_entry.dart';
import 'src/platform/platform_interface.dart';

export 'src/export/export.dart';

/// 平台插件注册
/// 插件注册由Flutter接管,无需手动注册
final class EcosedPlatformRegister {
  const EcosedPlatformRegister();

  /// 注册插件
  /// 插件注册由Flutter接管,无需手动注册
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}