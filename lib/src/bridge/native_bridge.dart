import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bridge_wrapper.dart';

final class NativeBridge implements BridgeWrapper {
  const NativeBridge();

  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await methodChannel.invokeListMethod(
      'getPlugins',
      {'channel': 'ecosed_engine'},
    );
  }

  /// 打开对话框
  @override
  void openPlatformDialog() {
    methodChannel.invokeMethod(
      'openDialog',
      {'channel': 'ecosed_engine'},
    );
  }

  /// 关闭对话框
  @override
  void closePlatformDialog() {
    methodChannel.invokeMethod(
      'closeDialog',
      {'channel': 'ecosed_engine'},
    );
  }
}
