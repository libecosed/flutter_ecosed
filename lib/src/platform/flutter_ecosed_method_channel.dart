import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ecosed_platform_interface.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  @override
  Future<List?> getPluginList() async {
    Map<String, dynamic> map = {"channel": "ecosed_engine"};
    final list = await methodChannel.invokeMethod<List>('getPlugins', map);
    return list;
  }
}
