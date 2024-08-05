import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../interface/ecosed_platform.dart';

final class PlatformMethod extends EcosedPlatform {
  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final Map<String, String> _arguments = const {'channel': 'ecosed_engine'};

  @override
  Future<List?> getPlatformPluginList() async {
    return await methodChannel.invokeListMethod<String?>(
      'getPlugins',
      _arguments,
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>('openDialog', _arguments);
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>('closeDialog', _arguments);
  }
}
