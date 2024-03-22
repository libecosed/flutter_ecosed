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

import 'package:flutter/material.dart';

import '../platform/flutter_ecosed_platform.dart';
import '../plugin/plugin.dart';
import '../values/method.dart';
import 'app_state.dart';
import 'app_type.dart';
import 'app_wrapper.dart';

class EcosedApp extends EcosedPlugin
    implements AppWrapper, FlutterEcosedPlatform {
  const EcosedApp({
    super.key,
    required this.title,
    required this.home,
    required this.scaffold,
    required this.location,
    required this.plugins,
  });

  /// {@tool snippet}
  /// 应用名称
  ///
  /// 此名称将在管理器的顶部状态卡片的标题
  /// 和详细信息卡片的应用名称项上显示
  ///
  /// ```dart
  /// EcosedApp(
  ///   title: '应用名称',
  /// )
  /// ```
  /// {@end-tool}
  final String title;

  /// {@tool snippet}
  /// 应用主页
  ///
  /// 传入[EcosedExec]exec:插件方法的调用, [Widget]body: 管理器的布局
  /// 返回主页布局传入[EcosedScaffold]作为body
  ///
  /// ```dart
  /// EcosedApp(
  ///   home: (exec, body) {
  ///     // exec('插件通道名称', '插件方法名称');
  ///     // body 管理器的界面
  ///     return body;
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  final EcosedHome home;

  /// {@tool snippet}
  /// 应用脚手架
  ///
  /// body:应用主页
  ///
  /// 返回带有[Banner]的[Scaffold]为此[Widget]布局
  ///
  /// ```dart
  /// EcosedApp(
  ///   scaffold: (body) {
  ///     return Scaffold(
  ///       body: body,
  ///     );
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  final EcosedScaffold scaffold;

  /// 横幅位置
  final BannerLocation location;

  /// 插件列表
  final List<EcosedPlugin> plugins;

  @override
  State<EcosedApp> createState() => EcosedAppState();

  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_app';

  @override
  String pluginDescription() => title;

  @override
  Future<Object?> onMethodCall(String name) async {
    switch (name) {
      case getPluginMethod:
        return getPluginList();
      case openDialogMethod:
        openDialog();
        return null;
      default:
        return null;
    }
  }

  /// internal function
  @override
  List<EcosedPlugin> initialPlugin() => [this];

  /// internal function
  @override
  Future<List?> getPluginList() {
    return FlutterEcosedPlatform.instance.getPluginList();
  }

  /// internal function
  @override
  void openDialog() {
    FlutterEcosedPlatform.instance.openDialog();
  }
}
