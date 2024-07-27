/// 平台插件注册和API导出
library flutter_ecosed;

import 'src/export/export.dart';

export 'src/export/export.dart'
    show EcosedPlugin, runEcosedApp, execPluginMethod, openDebugMenu
    hide registerEcosed;

/// 平台插件注册
/// 插件注册由Flutter框架接管, 请勿手动注册.
final class EcosedPlatformRegister {
  const EcosedPlatformRegister();

  /// 注册插件
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  static void registerWith() => registerEcosed();
}
