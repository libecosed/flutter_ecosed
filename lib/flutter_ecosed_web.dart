/// flutter_ecosed for web.
library flutter_ecosed_web;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'src/platform/platform_interface.dart';
import 'src/plugin/plugin.dart';
import 'src/widget/ecosed_banner.dart';
import 'src/widget/ecosed_inherited.dart';

/// Web插件注册
final class FlutterEcosedWeb extends EcosedPlatformInterface {
  FlutterEcosedWeb();

  /// 注册插件
  static void registerWith(Registrar registrar) {
    EcosedPlatformInterface.instance = FlutterEcosedWeb();
  }

  /// 启动应用
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    return await tip(
      plugins: plugins,
      runner: runner(
        EcosedInherited(
          executor: (channel, method) async => exec(
            channel: channel,
            method: method,
          ),
          manager: Directionality(
            textDirection: TextDirection.ltr,
            child: Localizations(
              locale: const Locale('zh', 'CN'),
              delegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              child: const Center(
                child: Text('此功能不支持Web.'),
              ),
            ),
          ),
          child: EcosedBanner(
            child: Builder(
              builder: (context) => app(context),
            ),
          ),
        ),
      ),
    );
  }

  /// 显示提示
  Future<void> tip({
    required List<EcosedPlugin> plugins,
    required Future<void> runner,
  }) async {
    debugPrint('此应用正在Web浏览器中运行, ${plugins.length}个插件将不会被加载.');
    return await runner;
  }

  /// 执行方法
  Future<dynamic> exec({
    required String channel,
    required String method,
  }) async {
    web.window.alert('此功能"execPluginMethod($channel, $method)"不支持Web, 将返回空.');
    return await null;
  }
}
