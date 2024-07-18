import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../engine/bridge_mixin.dart';
import '../values/tag.dart';
import '../framework/context_wrapper.dart';
import '../framework/log.dart';
import '../kernel/kernel_bridge.dart';
import '../kernel/module.dart';
import '../platform/ecosed_interface.dart';
import '../plugin/plugin_base.dart';
import '../runtime/runtime_mixin.dart';
import '../values/banner.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';
import '../server/server.dart';
import '../widget/banner.dart';

base class EcosedBase extends ContextWrapper
    with
        BaseMixin,
        RuntimeMixin,
        KernelBridgeMixin,
        ServerBridgeMixin,
        EngineBridgeMixin
    implements
        BaseWrapper,
        EcosedInterface,
        EcosedRuntimePlugin,
        EcosedKernelModule {
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

  /// 管理器布局
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    return pluginWidget(context);
  }

  /// 执行方法
  @override
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  /// 使用运行器运行
  @override
  Future<void> runWithRunner({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    return await runner(_builder(child: app));
  }

  /// 执行插件方法
  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await exec(
      channel,
      method,
      arguments,
    );
  }

  /// 获取管理器
  @override
  Widget getManagerWidget() {
    return Builder(
      builder: (context) {
        return buildManager(context);
      },
    );
  }

  /// 运行应用
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {
    // 初始化Flutter相关
    _initFlutter();
    // 初始化内核
    _initKernle();
    // 初始化服务
    _initServer();
    // 初始化引擎
    _initEngine();
  }

  /// 初始化Flutter相关组件
  Future<void> _initFlutter() async {
    // 打印横幅
    Log.d(baseTag, '\n${utf8.decode(base64Decode(banner))}');
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// 初始化内核
  Future<void> _initKernle() async {
    // 初始化内核桥接
    initKernelBridge();
  }

  /// 初始化服务
  Future<void> _initServer() async {
    // 初始化服务桥接
    initServerBridge();
  }

  /// 初始化引擎
  Future<void> _initEngine() async {
    // 初始化引擎桥接
    initEngineBridge();
    // 初始化引擎
    await engineBridgerScope.onCreateEngine(this);
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
}

class LoginViewmodel extends ChangeNotifier {}
