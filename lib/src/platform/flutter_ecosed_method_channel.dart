import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../value/default.dart';
import 'flutter_ecosed_platform_interface.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  @override
  Future<bool?> isShizukuInstalled() async {
    return await methodChannel.invokeMethod<bool>(
      'isShizukuInstalled',
      {'channel': serviceChannel},
    );
  }

  @override
  void installShizuku() {
    methodChannel.invokeMethod<void>(
      'installShizuku',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<bool?> isMicroGInstalled() async {
    return await methodChannel.invokeMethod<bool>(
      'isMicroGInstalled',
        {'channel': serviceChannel},
    );
  }

  @override
  void installMicroG() {
    methodChannel.invokeMethod<void>(
      'installMicroG',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<bool?> isShizukuGranted() async {
    return await methodChannel.invokeMethod<bool>(
      'isShizukuGranted',
      {'channel': serviceChannel},
    );
  }

  @override
  void requestPermissions() {
    methodChannel.invokeMethod<void>(
      'requestPermissions',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<String?> getPoem() async {
    return await methodChannel.invokeMethod<String>(
      'getPoem',
      {'channel': serviceChannel},
    );
  }

  @override
  Future<String?> getShizukuVersion() async {
    return await methodChannel.invokeMethod<String>(
      'getShizukuVersion',
      {'channel': serviceChannel},
    );
  }

  /// 通过引擎实现
  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeMethod<List>(
      'getPlugins',
      {'channel': engineChannel},
    );
  }
}
