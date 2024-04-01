library flutter_ecosed;

import 'package:flutter_ecosed/src/platform/method_channel_flutter_ecosed.dart';

import 'src/platform/flutter_ecosed_platform.dart';

export 'src/app/app.dart';
export 'src/plugin/plugin.dart';

class FlutterEcosed extends FlutterEcosedPlatform {
  static void registerWith() {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }
}
