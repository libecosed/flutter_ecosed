import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_ecosed_platform.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  MethodChannelFlutterEcosed();

  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  static void registerWith() {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeListMethod(
      'getPlugins',
      {'channel': 'ecosed_engine'},
    );
  }

  /// 从客户端启动对话框
  @override
  void openDialog() {
    methodChannel.invokeMethod(
      'openDialog',
      {'channel': 'ecosed_invoke'},
    );
  }

  @override
  void openPubDev() {
    methodChannel.invokeMethod(
      'openPubDev',
      {'channel': 'ecosed_invoke'},
    );
  }
}
