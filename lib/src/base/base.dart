import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../engine/bridge_mixin.dart';
import '../plugin/plugin_runtime.dart';
import '../type/runner.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../values/tag.dart';
import '../framework/context_wrapper.dart';
import '../framework/log.dart';
import '../kernel/kernel_bridge.dart';
import '../kernel/kernel_module.dart';
import '../interface/ecosed_interface.dart';
import '../runtime/runtime_mixin.dart';
import '../values/drawable.dart';
import '../server/server.dart';
import '../viewmodel/manager_view_model.dart';
import '../widget/banner.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';

/// 绑定通信层
///
///
/// 绑定通信层是框架交互通信的中心.
/// 所有功能的调用汇集于此, 被运行时继承后调用.
///
/// 基类[EcosedBase]的构建一共有10个类参与.
/// * 继承1个类, 继承自[ContextWrapper].
/// * 混入5个类, 分别是[RuntimeMixin], [BaseMixin], [KernelBridgeMixin], [ServerBridgeMixin], [EngineBridgeMixin].
/// * 实现4个接口, 分别是[BaseWrapper], [EcosedInterface], [EcosedRuntimePlugin], [EcosedKernelModule].
///
/// 以下是对这些类的描述.
///
/// * [ContextWrapper] : 上下文包装器 - 实现上下文接口.
///
/// * [RuntimeMixin] : 混入运行时 - 运行时初始化入口.
/// * [BaseMixin] : 混入绑定层 - 插件入口.
/// * [KernelBridgeMixin] : 内核桥接混入 - 内核相关操作.
/// * [ServerBridgeMixin] : 服务桥接混入 - 服务相关操作.
/// * [EngineBridgeMixin] : 引擎桥接混入 - 引擎相关操作.
///
/// * [BaseWrapper] : 绑定层包装器 - 实现绑定层功能抽象接口.
/// * [EcosedInterface] : 实现框架接口.
/// * [EcosedRuntimePlugin] : 实现运行时插件接口.
/// * [EcosedKernelModule] : 实现内核模块接口.
///
base class EcosedBase extends ContextWrapper
    with
        RuntimeMixin,
        BaseMixin,
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
  String get pluginAuthor => developerName;

  /// 插件通道
  @override
  String get pluginChannel => 'ecosed_base';

  /// 插件描述
  @override
  String get pluginDescription => '框架各个部分的绑定与通信';

  /// 插件名称
  @override
  String get pluginName => 'EcosedBase';

  /// 插件界面
  @override
  Widget pluginWidget(BuildContext context) {
    return ChangeNotifierProvider<ManagerViewModel>(
      create: (context) => ManagerViewModel(context),
      child: build(context),
    );
  }

  // 此方法通过运行时继承后重写
  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  // 此方法通过运行时继承后重写
  /// 管理器布局
  @override
  Widget build(BuildContext context) => const Placeholder();

  // 此方法通过运行时继承后重写
  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) => pluginWidget(context);

  // 此方法通过运行时继承后重写
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
    required Future<void> Function(Widget app) runner,
  }) async {
    return await runner(Builder(
      builder: (context) => Theme(
        data: ThemeData(
          brightness: MediaQuery.platformBrightnessOf(context),
        ),
        child: Material(
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
                initialRoute: routeApp,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case routeApp:
                      return MaterialPageRoute(
                        builder: (context) {
                          attachBuildContext(context);
                          return EcosedBanner(child: app);
                        },
                      );
                    case routeManager:
                      return MaterialPageRoute(
                        builder: (context) => buildManager(context),
                      );
                    default:
                      return MaterialPageRoute(
                        builder: (context) => const Placeholder(),
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    ));
  }

  /// 执行引擎方法
  @override
  Future<dynamic> execEngine(
    String method, [
    dynamic arguments,
  ]) async {
    return await engineBridgerScope.onMethodCall(
      method,
      arguments,
    );
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

  // 此方法通过运行时继承后重写
  /// 打开调试菜单
  @override
  Future<void> openDebugMenu() async => await launchManager();

  // 此方法仅供绑定层与运行时调用
  /// 获取导航主机上下文
  @override
  BuildContext get host => getBuildContext();

  /// 打开管理器
  @override
  Future<dynamic> launchManager() async {
    return await Navigator.of(host, rootNavigator: true)
        .pushNamed(routeManager);
  }

  /// 运行应用
  ///
  ///
  @mustCallSuper
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<EcosedRuntimePlugin> plugins,
    required Runner runner,
  }) async {
    // 初始化Flutter相关
    // 打印横幅
    Log.d(baseTag, '\n${utf8.decode(base64Decode(banner))}');
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化内核
    // await RustLib.init();
    // Log.i(baseTag, greet(name: 'flutter_ecosed'));
    // 初始化内核桥接
    await initKernelBridge();
    // 初始化服务
    // 初始化服务桥接
    await initServerBridge();
    // 初始化引擎
    // 初始化引擎桥接
    await initEngineBridge();
    // 初始化引擎
    await engineBridgerScope.onCreateEngine(this);
  }
}
