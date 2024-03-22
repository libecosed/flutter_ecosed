//import 'dart:html' as html show window;

import 'package:flutter/foundation.dart';

import 'flutter_ecosed_platform.dart';
import 'native_bridge.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  final NativeBridge bridge = NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPluginList() async {
    if (!kIsWeb) {
      return await bridge.getPluginList();
    } else {
      return [];
    }
  }

  /// 从客户端启动对话框
  @override
  void openDialog() {
    if (!kIsWeb) {
      bridge.openDialog();
    } else {
      //html.window.alert('the function unsupported web');
    }
  }

  @override
  void openPubDev() {
    if (!kIsWeb) {
      bridge.openPubDev();
    } else {
      //html.window.location.href = 'https://pub.dev/packages/flutter_ecosed';
    }
  }
}
