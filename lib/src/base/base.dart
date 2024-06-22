import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../kernel/kernel.dart';
import '../platform/platform_interface.dart';
import '../plugin/plugin.dart';
import '../widget/inherited.dart';
import '../widget/banner.dart';

base class EcosedBase extends EcosedPlatformInterface
    implements EcosedPlugin, EcosedKernelModule {
  /// 插件作者
  @override
  String pluginAuthor() => 'wyq0918dev';

  /// 插件通道
  @override
  String pluginChannel() => 'ecosed_base';

  /// 插件描述
  @override
  String pluginDescription() => '运行时内核绑定层';

  /// 插件名称
  @override
  String pluginName() => 'EcosedBase';

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

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String _, [
    dynamic __,
  ]) async {
    return await null;
  }

  /// 获取绑定层
  EcosedPlugin get get => EcosedBase();

  /// 管理器布局
  Widget build(BuildContext context) => Container();

  /// 获取管理器
  Widget buildManager(BuildContext context) => pluginWidget(context);

  /// 执行方法
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  /// 使用运行器运行
  Future<void> runWithRunner({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    return await runner(_builder(app)).then((_) {
      if (!kReleaseMode && kIsWeb) {
        // 打印提示信息
        debugPrint('此应用正在Web浏览器中运行, 资源受限.');
      }
    });
  }

  /// 构建器
  Widget _builder(WidgetBuilder app) {
    return EcosedInherited(
      executor: (channel, method, [dynamic arguments]) async {
        return await exec(channel, method, arguments);
      },
      manager: Builder(builder: (context) {
        return buildManager(context);
      }),
      child: EcosedBanner(child: Builder(builder: (context) {
        return app(context);
      })),
    );
  }
}
