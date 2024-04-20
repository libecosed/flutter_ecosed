import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bridge_wrapper.dart';

final class NativeBridge implements BridgeWrapper {
  const NativeBridge();

  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final arguments = const {'channel': 'ecosed_engine'};

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await methodChannel.invokeListMethod<String?>(
      'getPlugins',
      arguments,
    );
  }

  /// 打开对话框
  @override
  Future<void> openPlatformDialog() async {
    return await methodChannel.invokeMethod<void>(
      'openDialog',
      arguments,
    );
  }

  /// 关闭对话框
  @override
  Future<void> closePlatformDialog() async {
    return await methodChannel.invokeMethod<void>(
      'closeDialog',
      arguments,
    );
  }
}
