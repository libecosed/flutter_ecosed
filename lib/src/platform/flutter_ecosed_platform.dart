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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../bridge/bridge_wrapper.dart';

abstract class FlutterEcosedPlatform extends PlatformInterface
    implements BridgeWrapper {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();

  /// 实例
  static late FlutterEcosedPlatform _instance;

  /// 获取实例
  static FlutterEcosedPlatform get instance => _instance;

  /// 设置实例
  static set instance(FlutterEcosedPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 获取插件列表
  @override
  Future<List?> getAndroidPluginList() async {
    throw UnimplementedError('getPluginList()方法未实现');
  }

  /// 打开对话框
  @override
  void openAndroidDialog() {
    throw UnimplementedError('openDialog()方法未实现');
  }
}
