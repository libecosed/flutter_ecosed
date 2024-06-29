/// Web插件注册
library flutter_ecosed_web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/platform/platform_entry.dart';
import 'src/platform/platform_interface.dart';

/// Web插件注册
/// 插件注册由Flutter接管,无需手动注册
final class EcosedWebRegister {
  const EcosedWebRegister();

  /// 注册插件
  /// 插件注册由Flutter接管,无需手动注册
  static void registerWith(Registrar registrar) {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}
