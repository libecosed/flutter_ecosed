import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
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
import '../widget/log_page.dart';
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
        EcosedRuntimePlugin,
        EcosedInterface,
        EcosedKernelModule,
        BaseWrapper {
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
        // 初始化View Model
        final viewModel = buildViewModel(context);
        assert(() {
          // 判断View Model类型
          if (viewModel is! ManagerViewModel) {
            // 抛出异常
            throw FlutterError('View Model 类型错误');
          }
          return true;
        }());
        // 转换类型后返回
        return viewModel as ManagerViewModel;
      },
      child: buildLayout(context),
    );
  }

  /// 运行应用
  @override
  Future<void> runEcosedApp(
    Widget app,
    List<EcosedRuntimePlugin> plugins,
    Runner runner,
  ) async {
    init_aaa();
    // 打印横幅
    Log.d(baseTag, '\n${utf8.decode(base64Decode(banner))}');
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化内核桥接
    await initKernelBridge();
    // await RustLib.init();
    // Log.i(baseTag, greet(name: 'flutter_ecosed'));
    // TODO: 内核相关操作

    // 初始化服务桥接
    await initServerBridge();
    // TODO: 服务相关操作

    // 初始化引擎桥接
    await initEngineBridge();
    // 初始化引擎
    await engineBridgerScope.onCreateEngine(this);
    // 初始化应用
    await init(plugins);
    // 启动应用
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
                observers: [
                  RouteObserver(
                    change: (name) {
                      Log.d(baseTag, '当前页面$name');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
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

  /// 打开调试菜单
  @override
  Future<void> openDebugMenu() async {
    await buildDialog(getBuildContext(), false);
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  @override
  Future<void> init(List<EcosedRuntimePlugin> plugins) {
    throw UnimplementedError('');
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) => pluginWidget(context);

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) => this;

  /// 管理器布局
  @override
  Widget buildLayout(BuildContext context) => const Placeholder();

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

  /// 打开管理器
  @protected
  @override
  Future<dynamic> launchManager() async {
    return await Navigator.of(
      getBuildContext(),
      rootNavigator: true,
    ).pushNamed(routeManager);
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
      {'channel': 'ecosed_engine', ...?arguments},
    );
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
}

class RouteObserver extends NavigatorObserver {
  RouteObserver({required this.change});

  final Function(String? route) change;

  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    change(route.settings.name);
  }

  @override
  void didPop(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    change(previousRoute?.settings.name);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    change(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    change(newRoute?.settings.name);
  }
}

class SampleClass {
  final String name;
  final int id;

  SampleClass({
    required this.name,
    required this.id,
  });

  static void printSomeLogs() {
    Flogger.d("Debug message");

    Flogger.i("Info message");
    Flogger.i("Info message with object - ${SampleClass(name: "John", id: 1)}");

    Flogger.w("Warning message");
    try {
      throw Exception("Something bad happened");
    } catch (e) {
      Flogger.w("Warning message with exception $e");
    }

    Flogger.e("Error message with exception - ${Exception("Test Error")}");

    Flogger.i("Info message with a different logger name", loggerName: "Dio");

    // throw Exception("This has been thrown");
  }
}

class ExternalPackage {
  static void printSomeLogs() {
    Logger.root.config("Debug message");

    Logger.root.info("Info message");
    Logger.root.info("Info message with object - ${ExternalPackage()}");

    Logger.root.warning("Warning message");
    try {
      throw Exception("Something bad happened");
    } catch (e) {
      Logger.root.info("Warning message with exception $e");
    }

    Logger.root
        .severe("Error message with exception - ${Exception("Test Error")}");

    Logger("Isar").info("Info message with a different logger name");

    // throw Exception("This has been thrown");
  }
}

// void main() {
//   runZonedGuarded(() {
//     runApp(MyApp());
//     init();
//   }, (error, stack) {
//     // Catch and log crashes
//     Flogger.e('Unhandled error - $error', stackTrace: stack);
//   });
// }

void init_aaa() {
  // Init
  Flogger.init(
    config: FloggerConfig(
      printClassName: true,
      printMethodName: true,
      showDateTime: true,
      showDebugLogs: true,
    ),
  );
  if (kDebugMode) {
    // Send logs to debug console
    Flogger.registerListener(
      (record) => log(record.printable(), stackTrace: record.stackTrace),
    );
  }
  // Send logs to App Console
  Flogger.registerListener(
    (record) => LogConsole.add(
      OutputEvent(record.level, [record.printable()]),
      bufferSize: 1000, // Remember the last X logs
    ),
  );
  // You can also use "registerListener" to log to Crashlytics or any other services
  if (kReleaseMode) {
    Flogger.registerListener((record) {
      // Filter logs that may contain sensitive data
      if (record.loggerName != "App") return;
      if (record.message.contains("apiKey")) return;
      if (record.message.contains("password")) return;
      // Send logs to logging services
      // FirebaseCrashlytics.instance.log(record.message);
      // DatadogSdk.instance.logs?.info(record.message);
    });
  }
  SampleClass.printSomeLogs();
}