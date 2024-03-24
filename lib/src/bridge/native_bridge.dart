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
import 'package:flutter/services.dart';

import 'bridge_wrapper.dart';

class NativeBridge implements BridgeWrapper {
  const NativeBridge();

  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 获取插件列表
  @override
  Future<List?> getAndroidPluginList() async {
    return await methodChannel.invokeListMethod(
      'getPlugins',
      {'channel': 'ecosed_engine'},
    );
  }

  /// 打开对话框
  @override
  void openAndroidDialog() {
    methodChannel.invokeMethod(
      'openDialog',
      {'channel': 'ecosed_invoke'},
    );
  }
}
