import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ecosed_platform_interface.dart';

final class FlutterEcosedPlatform extends EcosedPlatformInterface {
  /// 方法通道平台代码调用Android平台独占
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final _arguments = const {'channel': 'ecosed_engine'};

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPlatformPluginList() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeListMethod<String?>(
          'getPlugins',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => List.empty(),
      iOS: () async => List.empty(),
      linux: () async => List.empty(),
      macOS: () async => List.empty(),
      windows: () async => List.empty(),
    );
  }

  /// 从客户端启动对话框
  @override
  Future<bool?> openPlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeMethod<bool?>(
          'openDialog',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async => await null,
    );
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await _withPlatform(
      android: () async => await _invokeAndroid(
        invoke: () async => await methodChannel.invokeMethod<bool?>(
          'closeDialog',
          _arguments,
        ),
        error: () async => List.empty(),
      ),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async => await null,
    );
  }

  Future<dynamic> _withPlatform({
    required Future<dynamic> Function() android,
    required Future<dynamic> Function() fuchsia,
    required Future<dynamic> Function() iOS,
    required Future<dynamic> Function() linux,
    required Future<dynamic> Function() macOS,
    required Future<dynamic> Function() windows,
  }) async {
    if (Platform.isAndroid) {
      return await android.call();
    } else if (Platform.isFuchsia) {
      return await fuchsia.call();
    } else if (Platform.isIOS) {
      return await iOS.call();
    } else if (Platform.isLinux) {
      return await linux.call();
    } else if (Platform.isMacOS) {
      return await macOS.call();
    } else if (Platform.isWindows) {
      return await windows.call();
    } else {
      return await null;
    }
  }

  /// 平台调用处理机制
  Future<dynamic> _invokeAndroid({
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
