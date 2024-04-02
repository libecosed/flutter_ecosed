import 'package:flutter/material.dart';

import '../plugin/plugin.dart';
import 'app_state.dart';
import 'app_type.dart';

class EcosedApp extends StatefulWidget {
  const EcosedApp({
    super.key,
    required this.title,
    required this.home,
    required this.scaffold,
    required this.location,
    required this.plugins, required this.materialApp,
  });

  /// 应用名称
  ///
  /// 此名称将在管理器的顶部状态卡片的标题
  /// 和详细信息卡片的应用名称项上显示
  final String title;

  /// 应用主页
  ///
  /// 传入[EcosedExec]exec:插件方法的调用, [Widget]body: 管理器的布局
  /// 返回主页布局传入[EcosedScaffold]作为body
  final EcosedHome home;

  /// 应用脚手架
  ///
  /// body:应用主页
  /// 返回带有[Banner]的[Scaffold]为此[Widget]布局
  final EcosedScaffold scaffold;

  final EcosedApps materialApp;

  /// 横幅位置
  final BannerLocation location;

  /// 插件列表
  final List<EcosedPlugin> plugins;

  @override
  State<EcosedApp> createState() => EcosedAppState();
}
