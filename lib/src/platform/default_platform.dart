import 'package:flutter/foundation.dart';

import 'ecosed_platform_interface.dart';

final class DefaultPlatform extends EcosedPlatformInterface {
  @override
  Future<List?> getPlatformPluginList() async {
    return List.empty();
  }

  @override
  Future<List?> getKernelModuleList() async {
    return List.empty();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    debugPrint('openPlatformDialog: the function unsupported the platform.');
    return false;
  }

  @override
  Future<bool?> closePlatformDialog() async {
    debugPrint('closePlatformDialog: the function unsupported the platform.');
    return false;
  }
}
