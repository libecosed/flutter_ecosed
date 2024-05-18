library flutter_ecosed;

import 'src/platform/ecosed_platform_interface.dart';
import 'src/platform/flutter_ecosed_platform.dart';

export 'src/app/app.dart';
export 'src/plugin/plugin.dart';
export 'src/executor/executor.dart';

final class FlutterEcosed {
  const FlutterEcosed();

  /// 注册插件
  static void registerWith() {
    EcosedPlatformInterface.instance = FlutterEcosedPlatform();
  }
}