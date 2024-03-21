import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_ecosed_method_channel.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

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
