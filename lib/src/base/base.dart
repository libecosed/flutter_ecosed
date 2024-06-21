import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/kernel/kernel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../platform/platform_interface.dart';
import '../inherited/inherited.dart';
import '../plugin/plugin.dart';
import '../widget/banner.dart';

abstract base class EcosedBase extends EcosedPlatformInterface
    implements EcosedKernelModule {
  /// 插件作者
  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() {
    // TODO: implement pluginChannel
    throw UnimplementedError();
  }

  @override
  String pluginDescription() {
    // TODO: implement pluginDescription
    throw UnimplementedError();
  }

  @override
  String pluginName() {
    // TODO: implement pluginName
    throw UnimplementedError();
  }

  /// 插件界面
  @override
  Widget pluginWidget(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: MediaQuery.platformBrightnessOf(context),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: const Locale('zh', 'CN'),
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Navigator(
            onGenerateInitialRoutes: (navigator, name) => [
              MaterialPageRoute(
                builder: (context) => build(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<dynamic> onMethodCall(String method, [arguments]) async {}

  Widget build(BuildContext context);

  Widget buildManager(BuildContext context) => pluginWidget(context);

  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]);

  Widget builder(WidgetBuilder app) {
    return EcosedInherited(
      executor: (channel, method, [dynamic arguments]) async {
        return await exec(channel, method, arguments);
      },
      manager: Builder(
        builder: (context) {
          return buildManager(context);
        },
      ),
      child: EcosedBanner(
        child: Builder(
          builder: (context) {
            return app(context);
          },
        ),
      ),
    );
  }

  /// 显示提示
  Future<void> runWithRunner({
    required Future<void> Function(Widget app) runner,
    required Widget child,
  }) async {
    if (!kReleaseMode && kIsWeb) {
      // 打印提示信息
      debugPrint('此应用正在Web浏览器中运行, 资源受限.');
    }
    return await runner(child);
  }
}
