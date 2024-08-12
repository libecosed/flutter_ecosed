import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../interface/ecosed_platform.dart';
import '../utils/platform.dart';

final class PlatformMethod extends EcosedPlatform {
  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final Map<String, String> _arguments = const {'channel': 'ecosed_engine'};

  @override
  Future<List?> getPlatformPluginList() async {
    return kUseNative
        ? await methodChannel.invokeListMethod<String?>(
            'getPlugins',
            _arguments,
          )
        : await null;
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return kUseNative
        ? await methodChannel.invokeMethod<bool?>(
            'openDialog',
            _arguments,
          )
        : await null;
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return kUseNative
        ? await methodChannel.invokeMethod<bool?>(
            'closeDialog',
            _arguments,
          )
        : await null;
  }
}
