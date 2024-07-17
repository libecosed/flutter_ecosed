import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../engine/bridge_mixin.dart';
import '../framework/context_wrapper.dart';
import '../kernel/kernel_bridge.dart';
import '../kernel/module.dart';
import '../plugin/plugin_base.dart';
import '../runtime/runtime.dart';
import '../runtime/runtime_mixin.dart';
import 'base_wrapper.dart';
import '../server/server.dart';
import '../widget/banner.dart';

base class EcosedBase extends ContextWrapper
    with RuntimeMixin, KernelBridgeMixin, ServerBridgeMixin, EngineBridgeMixin
    implements BaseWrapper, BaseEcosedPlugin, EcosedKernelModule {
  /// 构造函数
  EcosedBase() : super(attach: true);

  /// 插件作者
  @override
  String get pluginAuthor => 'wyq0918dev';

  /// 插件通道
  @override
  String get pluginChannel => 'ecosed_base';

  /// 插件描述
  @override
  String get pluginDescription => '框架运行时、库操作系统内核、系统服务和框架引擎的绑定与通信';

  /// 插件名称
  @override
  String get pluginName => 'EcosedBase';

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
          child: Builder(
            builder: (context) => build(context),
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

  /// 运行时入口
  BaseWrapper call() {
    initRuntime();
    return ecosedRuntime;
  }

  /// 获取绑定层
  BaseEcosedPlugin get get => EcosedBase();

  /// 获取运行时
  EcosedRuntime get _runtime => EcosedRuntime();

  /// 管理器布局
  Widget build(BuildContext context) => const Placeholder();

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
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    return await runner(_builder(child: app));
  }

  Widget _builder({
    required Widget child,
  }) {
    return MultiProvider(
      providers: [
        Provider<LoginViewmodel>(create: (_) => LoginViewmodel()),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          onGenerateInitialRoutes: (navigator, name) => [
            MaterialPageRoute(
              builder: (_) => EcosedBanner(child: child),
            ),
          ],
        ),
      ),
    );
  }

  /// 执行插件方法
  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await exec(channel, method, arguments);
  }

  /// 获取管理器
  @override
  Widget getManagerWidget() {
    return Builder(builder: (context) => buildManager(context));
  }

  /// 运行应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    throw UnimplementedError();
  }
}

class LoginViewmodel extends ChangeNotifier {}
