library flutter_ecosed;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ecosed_platform.dart';

class NativeBridge implements FlutterEcosedPlatform {
  const NativeBridge();

  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 获取插件列表
  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeListMethod(
      'getPlugins',
      {'channel': 'ecosed_engine'},
    );
  }

  /// 打开对话框
  @override
  void openDialog() {
    methodChannel.invokeMethod(
      'openDialog',
      {'channel': 'ecosed_invoke'},
    );
  }
}
