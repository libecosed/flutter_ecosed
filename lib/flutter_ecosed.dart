library flutter_ecosed;

import 'src/platform/flutter_ecosed_platform.dart';
import 'src/platform/method_channel_flutter_ecosed.dart';

export 'src/app/app.dart';
export 'src/plugin/plugin.dart';

class FlutterEcosed extends FlutterEcosedPlatform {
  /// 注册插件
  static void registerWith() {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }
}
