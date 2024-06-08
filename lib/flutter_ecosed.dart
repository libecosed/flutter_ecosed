/// flutter_ecosed.
library flutter_ecosed;

import 'package:flutter_ecosed/src/runtime/runtime.dart';

import 'src/platform/ecosed_platform_interface.dart';

export 'src/entry/entry.dart';
export 'src/plugin/plugin.dart';
export 'src/extension/extension.dart';

final class FlutterEcosed {
  const FlutterEcosed();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = EcosedRuntime();
  }
}
