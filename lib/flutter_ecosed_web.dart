/// flutter_ecosed for web.
library flutter_ecosed_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' show window;

import 'src/base/base.dart';
import 'src/platform/interface.dart';
import 'src/plugin/plugin.dart';

/// Web插件注册
final class EcosedWebRegister extends EcosedBase {
  EcosedWebRegister();

  /// 注册插件
  static void registerWith(Registrar registrar) {
    EcosedPlatformInterface.instance = EcosedWebRegister();
  }

  /// 启动应用
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    await super.runWithRunner(
      app: app,
      plugins: plugins,
      runner: runner,
    );
  }

  /// 插件通道
  @override
  String pluginChannel() => '';

  /// 插件描述
  @override
  String pluginDescription() => '';

  /// 插件名称
  @override
  String pluginName() => '';

  /// 执行方法
  @override
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    if (!kReleaseMode && kIsWeb) {
      // 弹出对话框
      window.alert(
        '方法execPluginMethod("$channel", "$method", "$arguments")无法在Web浏览器中执行, 将返回null.',
      );
    }
    return await null;
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('此功能不支持Web.'),
    );
  }
}
