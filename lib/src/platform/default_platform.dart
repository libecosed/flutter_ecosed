import 'package:flutter/foundation.dart';

import 'ecosed_platform_interface.dart';

final class DefaultPlatform extends EcosedPlatformInterface {
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
