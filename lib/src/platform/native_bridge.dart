import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ecosed_platform.dart';

class NativeBridge implements FlutterEcosedPlatform {
  const NativeBridge();

  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  @override
  Future<List?> getPluginList() async {
    return await methodChannel.invokeListMethod(
      'getPlugins',
      {'channel': 'ecosed_engine'},
    );
  }

  @override
  void openDialog() {
    methodChannel.invokeMethod(
      'openDialog',
      {'channel': 'ecosed_invoke'},
    );
  }

  @override
  void openPubDev() {
    methodChannel.invokeMethod(
      'openPubDev',
      {'channel': 'ecosed_invoke'},
    );
  }
}
