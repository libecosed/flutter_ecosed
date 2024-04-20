import 'package:flutter/foundation.dart';

import 'flutter_ecosed_platform.dart';

final class DefaultPlatform extends FlutterEcosedPlatform {
  @override
  Future<List?> getPlatformPluginList() async {
    return List.empty();
  }

  @override
  Future<void> openPlatformDialog() async {
    return debugPrint(
      'openPlatformDialog: the function unsupported the platform.',
    );
  }

  @override
  Future<void> closePlatformDialog() async {
    return debugPrint(
      'closePlatformDialog: the function unsupported the platform.',
    );
  }
}
