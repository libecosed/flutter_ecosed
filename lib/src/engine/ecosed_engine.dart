library flutter_ecosed;

import 'package:flutter/foundation.dart';

import '../bridge/native_bridge.dart';
import '../platform/flutter_ecosed_platform.dart';

class EcosedEngine extends FlutterEcosedPlatform {
  EcosedEngine();

  final NativeBridge bridge = const NativeBridge();


  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getAndroidPluginList() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await bridge.getAndroidPluginList();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return [];
      default:
        return [];
    }
  }

  /// 从客户端启动对话框
  @override
  void openAndroidDialog() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        bridge.openAndroidDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
    }
  }
}
