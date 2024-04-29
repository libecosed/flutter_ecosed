import 'package:flutter/foundation.dart';

import '../bridge/native_bridge.dart';
import 'ecosed_platform_interface.dart';

final class FlutterEcosedPlatform extends EcosedPlatformInterface {
  /// 方法通道平台代码调用Android平台独占
  final NativeBridge _bridge = const NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPlatformPluginList() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.getPlatformPluginList();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        return [];
    }
  }

  /// 从客户端启动对话框
  @override
  Future<void> openPlatformDialog() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.openPlatformDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        return await null;
    }
  }

  @override
  Future<void> closePlatformDialog() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.closePlatformDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        return await null;
    }
  }
}
