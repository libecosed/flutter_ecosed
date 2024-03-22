library flutter_ecosed;

import 'src/platform/flutter_ecosed_method_channel.dart';
import 'src/platform/flutter_ecosed_platform.dart';

export 'src/app/app.dart';
export 'src/plugin/plugin.dart';

class FlutterEcosed extends FlutterEcosedPlatform {
  FlutterEcosed();

  static void registerWith() {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }
}
