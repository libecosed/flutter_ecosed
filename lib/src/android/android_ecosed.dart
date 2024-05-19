import 'dart:io';

import 'package:flutter/services.dart';

import 'platform_interface.dart';

final class AndroidEcosed implements AndroidEcosedPlatform {
  /// 平台接口实例
  final AndroidEcosedPlatform _platform = AndroidEcosedPlatform.instance;

  /// 获取插件列表
  @override
  Future<List?> getPlatformPluginList() async {
    return await _invokePlatform(
      invoke: () async => await _platform.getPlatformPluginList(),
      error: () async => List.empty(),
    );
  }

  /// 打开对话框
  @override
  Future<bool?> openPlatformDialog() async {
    return await _invokePlatform(
      invoke: () async => await _platform.openPlatformDialog(),
      error: () async => false,
    );
  }

  /// 关闭对话框
  @override
  Future<bool?> closePlatformDialog() async {
    return await _invokePlatform(
      invoke: () async => await _platform.closePlatformDialog(),
      error: () async => false,
    );
  }

  /// 平台调用处理机制
  Future<dynamic> _invokePlatform({
    required Future<dynamic> Function() invoke,
    required Future<dynamic> Function() error,
  }) async {
    if (Platform.isAndroid) {
      try {
        return await invoke.call();
      } on PlatformException {
        return await error.call();
      }
    }
    return await error.call();
  }
}
