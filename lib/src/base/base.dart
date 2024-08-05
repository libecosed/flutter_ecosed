import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/viewmodel/manager_view_model.dart';
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
import '../widget/banner.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';

base class EcosedBase extends ContextWrapper
    with
        RuntimeMixin,
        BaseMixin,
        KernelBridgeMixin,
        ServerBridgeMixin,
        EngineBridgeMixin,
        ChangeNotifier
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
      create: (context) {
        final viewModel = buildViewModel(context);
        assert(() {
          if (viewModel is! ManagerViewModel) {
            throw FlutterError('View Model 类型错误');
          }
          return true;
        }());
        return viewModel as ManagerViewModel;
      },
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
  Future<void> _runWithRunner({
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
  @protected
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
  Future<void> openDebugMenu() async {
    await buildDialog(getBuildContext(), false);
  }

  /// 打开管理器
  @protected
  @override
  Future<dynamic> launchManager() async {
    return await Navigator.of(
      getBuildContext(),
      rootNavigator: true,
    ).pushNamed(routeManager);
  }

  /// 运行应用
  ///
  ///
  @protected
  @mustCallSuper
  @override
  Future<void> runEcosedApp(
    Widget app,
    List<EcosedRuntimePlugin> plugins,
    Runner runner,
  ) async {
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

    await init(plugins);

    return await _runWithRunner(
      app: app,
      runner: runner,
    );
  }

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) => this;

  @override
  Future<SimpleDialog?> buildDialog(
    BuildContext context,
    bool isManager,
  ) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => Text(
        isManager.toString(),
      ),
    );
  }

  @override
  Future<SimpleDialog?> launchDialog() async {
    return await buildDialog(getBuildContext(), true);
  }

  @override
  Future<void> init(List<EcosedRuntimePlugin> plugins) {
    throw UnimplementedError('');
  }
}
