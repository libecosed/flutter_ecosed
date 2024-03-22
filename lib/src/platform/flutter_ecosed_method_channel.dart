import 'package:flutter/foundation.dart';

import 'flutter_ecosed_platform.dart';
import 'native_bridge.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  final NativeBridge bridge = const NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPluginList() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await bridge.getPluginList();
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
  void openDialog() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        bridge.openDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
    }
  }
}
