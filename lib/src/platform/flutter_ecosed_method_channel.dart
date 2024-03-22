import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:html' as html show window;

import 'flutter_ecosed_platform.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPluginList() async {
    if (!kIsWeb) {
      return await methodChannel.invokeListMethod(
        'getPlugins',
        {'channel': 'ecosed_engine'},
      );
    } else {
      return [];
    }
  }

  /// 从客户端启动对话框
  @override
  void openDialog() {
    if (!kIsWeb) {
      methodChannel.invokeMethod(
        'openDialog',
        {'channel': 'ecosed_invoke'},
      );
    } else {
      html.window.alert('the function unsupported web');
    }
  }

  @override
  void openPubDev() {
    if (!kIsWeb) {
      methodChannel.invokeMethod(
        'openPubDev',
        {'channel': 'ecosed_invoke'},
      );
    } else {
      html.window.location.href = 'https://pub.dev/packages/flutter_ecosed';
    }
  }
}
