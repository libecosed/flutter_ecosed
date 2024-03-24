/// Copyright flutter_ecosed
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///   http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
library flutter_ecosed;

import 'package:flutter/foundation.dart';

import '../bridge/native_bridge.dart';
import 'flutter_ecosed_platform.dart';

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  final NativeBridge _bridge = const NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getAndroidPluginList() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.getAndroidPluginList();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return [];
      default:
        return [];
    }
  }

  /// 从客户端启动对话框
  @override
  void openAndroidDialog() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        _bridge.openAndroidDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
    }
  }
}
