import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_interface.dart';

final class MethodChannelAndroidEcosed extends AndroidEcosedPlatform {
  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final _arguments = const {'channel': 'ecosed_engine'};

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await methodChannel.invokeListMethod<String?>(
      'getPlugins',
      _arguments,
    );
  }

  @override
  Future<List?> getKernelModuleList() async {
    return List.empty();
  }

  /// 打开对话框
  @override
  Future<bool?> openPlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>(
      'openDialog',
      _arguments,
    );
  }

  /// 关闭对话框
  @override
  Future<bool?> closePlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>(
      'closeDialog',
      _arguments,
    );
  }
}
