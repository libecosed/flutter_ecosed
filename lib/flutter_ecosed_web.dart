import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/platform/flutter_ecosed_method_channel.dart';
import 'src/platform/flutter_ecosed_platform.dart';

class FlutterEcosedWeb extends FlutterEcosedPlatform {
  FlutterEcosedWeb();

  static void registerWith(Registrar registrar) {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }
}
