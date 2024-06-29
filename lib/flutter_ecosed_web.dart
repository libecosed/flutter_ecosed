/// flutter_ecosed for web.
library flutter_ecosed_web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/platform/entry.dart';
import 'src/platform/interface.dart';

/// Web插件注册
final class EcosedWebRegister {
  const EcosedWebRegister();

  /// 注册插件
  static void registerWith(Registrar registrar) {
    EcosedPlatformInterface.instance = EcosedPlatformEntry();
  }
}
