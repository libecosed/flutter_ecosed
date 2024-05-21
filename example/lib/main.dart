import 'dart:async';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  await runEcosedApp(
    app: (manager) => const MyApp(),
    plugins: const <EcosedPlugin>[ExamplePlugin()],
    runApplication: (app) async => runApp(app),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  SizeSelected windowSize = SizeSelected.compact;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: Global.transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    switch (width) {
      case < Global.compactWidthBreakpoint:
        windowSize = SizeSelected.compact;
        if (status != AnimationStatus.reverse &&
            status != AnimationStatus.dismissed) {
          controller.reverse();
        }
      case < Global.mediumWidthBreakpoint:
        windowSize = SizeSelected.medium;
        if (status != AnimationStatus.forward &&
            status != AnimationStatus.completed) {
          controller.forward();
        }
      default:
        windowSize = SizeSelected.expanded;
        if (status != AnimationStatus.forward &&
            status != AnimationStatus.completed) {
          controller.forward();
        }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > Global.mediumWidthBreakpoint ? 1 : 0;
    }
  }

  /// Widget的构建入口
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          railAnimation: railAnimation,
          appBar: (title) => AppBar(
            title: Text(title),
          ),
          body: (body) => Expanded(
            child: MyHomePage(manager: body),
          ),
          navigationRail: ValueListenableBuilder(
            valueListenable: Global.pageIndex,
            builder: (context, value, child) {
              return NavigationRail(
                extended: windowSize == SizeSelected.expanded,
                destinations: Global.navRailDestinations,
                selectedIndex: value,
                onDestinationSelected: (index) {
                  Global.pageIndex.value = index;
                  Global.showFab.value = Global.pageIndex.value == 0;
                },
              );
            },
          ),
          navigationBar: ValueListenableBuilder(
            valueListenable: Global.pageIndex,
            builder: (context, value, child) {
              return NavigationBar(
                selectedIndex: value,
                destinations: Global.appBarDestinations,
                onDestinationSelected: (index) {
                  Global.pageIndex.value = index;
                  Global.showFab.value = Global.pageIndex.value == 0;
                },
              );
            },
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: Global.showFab,
            builder: (context, value, child) {
              return Visibility(
                visible: value,
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    onPressed: () =>
                        context.execPluginMethod('example_channel', Method.add),
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// 主页布局类型枚举
enum SizeSelected {
  ///折叠
  compact,

  /// 中等
  medium,

  /// 展开
  expanded,
}

/// Global全局类
class Global {
  const Global();

  /// 应用名称
  static const String appName = 'flutter_ecosed 示例应用';

  /// compact阈值
  static const double compactWidthBreakpoint = 600;

  /// medium阈值
  static const double mediumWidthBreakpoint = 840;

  /// 大小切换动画速率
  static const double transitionLength = 500;

  /// 页面索引
  static final ValueNotifier<int> pageIndex = ValueNotifier(0);

  /// 计数
  static final ValueNotifier<int> counter = ValueNotifier(0);

  /// 是否显示FAB
  static final ValueNotifier<bool> showFab = ValueNotifier(true);

  /// 导航栏目的地
  static const List<NavigationDestination> appBarDestinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: '主页',
      tooltip: '主页',
      enabled: true,
    ),
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: '管理器',
      tooltip: 'flutter_ecosed管理器页面',
      enabled: true,
    ),
    NavigationDestination(
      icon: Icon(Icons.publish_outlined),
      selectedIcon: Icon(Icons.publish),
      label: 'Pub包',
      tooltip: 'Pub包发布页面',
      enabled: true,
    ),
    NavigationDestination(
      icon: Icon(Icons.code_outlined),
      selectedIcon: Icon(Icons.code),
      label: 'GitHub',
      tooltip: 'GitHub源码存储仓库',
      enabled: true,
    ),
  ];

  /// 纵向导航栏目的地
  static final List<NavigationRailDestination> navRailDestinations =
      appBarDestinations
          .map(
            (destination) => NavigationRailDestination(
              icon: Tooltip(
                message: destination.label,
                child: destination.icon,
              ),
              selectedIcon: Tooltip(
                message: destination.label,
                child: destination.selectedIcon,
              ),
              label: Text(destination.label),
              disabled: false,
            ),
          )
          .toList();
}

/// 调用方法
class Method {
  /// 计数器
  static const String add = 'add';
}

class NavigationTransition extends StatefulWidget {
  const NavigationTransition({
    super.key,
    required this.scaffoldKey,
    required this.animationController,
    required this.railAnimation,
    required this.navigationRail,
    required this.navigationBar,
    required this.appBar,
    required this.body,
    required this.floatingActionButton,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  final CurvedAnimation railAnimation;
  final Widget navigationRail;
  final Widget navigationBar;
  final Widget floatingActionButton;
  final PreferredSizeWidget Function(String title) appBar;
  final Widget Function(Widget manager) body;

  @override
  State<NavigationTransition> createState() => _NavigationTransitionState();
}

class _NavigationTransitionState extends State<NavigationTransition> {
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  late final ReverseAnimation barAnimation;
  bool controllerInitialized = false;
  bool showDivider = false;

  @override
  void initState() {
    super.initState();
    controller = widget.animationController;
    railAnimation = widget.railAnimation;
    barAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return EcosedApp(
          home: (context, manager) {
            return Row(
              children: <Widget>[
                RailTransition(
                  animation: railAnimation,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: widget.navigationRail,
                ),
                widget.body(manager),
              ],
            );
          },
          plugins: const [ExamplePlugin()],
          title: Global.appName,
          location: BannerLocation.topStart,
          scaffold: (body, title) {
            return Scaffold(
              key: widget.scaffoldKey,
              appBar: widget.appBar(title),
              body: body,
              bottomNavigationBar: BarTransition(
                animation: barAnimation,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: widget.navigationBar,
              ),
              floatingActionButton: widget.floatingActionButton,
            );
          },
          materialApp: (home, title) {
            return MaterialApp(
              home: home,
              title: title,
              theme: ThemeData(colorScheme: light),
              darkTheme: ThemeData(colorScheme: dark),
              // ignore: deprecated_member_use
              useInheritedMediaQuery: true,
            );
          },
        );
      },
    );
  }
}

class ExamplePlugin implements EcosedPlugin {
  const ExamplePlugin();

  /// “ExampleAuthor”为作者信息,替换为你自己的名字即可,通过[pluginAuthor]方法定义.
  @override
  String pluginAuthor() => 'ExampleAuthor';

  /// “example_channel”为插件的通道,可以理解为插件的唯一标识,我们通常使用全小写英文字母加下划线的命名方式,通过[pluginChannel]方法定义.
  @override
  String pluginChannel() => 'example_channel';

  /// "Example description"为插件的描述,通过[pluginDescription]方法定.
  @override
  String pluginDescription() => 'Example description';

  /// “Example Plugin”为插件的名称,通过[pluginName]方法定义.
  @override
  String pluginName() => 'Example Plugin';

  /// 右下角的打开按钮是打开[pluginWidget]方法定义的界面.
  @override
  Widget pluginWidget(BuildContext context) => const ExamplePluginPage();

  /// [onMethodCall]方法为插件的方法调用.
  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case Method.add:
        return Global.counter.value++;
      default:
        return await null;
    }
  }
}

class ExamplePluginPage extends StatelessWidget {
  const ExamplePluginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Plugin'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.manager});

  final Widget manager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Global.pageIndex,
      builder: (context, value, child) {
        return IndexedStack(
          index: value,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: Global.counter,
              builder: (context, value, child) {
                return HomeScreen(counter: value);
              },
            ),
            ManagerScreen(manager: manager),
            const WebViewScreen(
              url: 'https://pub.dev/packages/flutter_ecosed',
            ),
            const WebViewScreen(
              url: 'https://github.com/libecosed/flutter_ecosed',
            ),
          ],
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key, required this.manager});

  final Widget manager;

  @override
  Widget build(BuildContext context) {
    return Container(child: manager);
  }
}

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key, required this.url});

  final String url;

  bool canShowWebView() {
    if (kIsWeb) return false;
    if (Platform.isAndroid || Platform.isIOS) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return canShowWebView()
        ? Focus(
            onKeyEvent: (node, event) {
              if (!kIsWeb) {
                if ({
                  LogicalKeyboardKey.arrowLeft,
                  LogicalKeyboardKey.arrowRight,
                  LogicalKeyboardKey.arrowUp,
                  LogicalKeyboardKey.arrowDown,
                  LogicalKeyboardKey.tab
                }.contains(event.logicalKey)) {
                  return KeyEventResult.skipRemainingHandlers;
                }
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              onSecondaryTap: () {},
              child: WebViewWidget(
                controller: WebViewController()
                  ..loadRequest(
                    Uri.parse(url),
                  )
                  ..setJavaScriptMode(
                    JavaScriptMode.unrestricted,
                  ),
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '当前操作系统${Theme.of(context).platform.name}不支持WebView组件,请通过浏览器打开.',
                ),
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse(url),
                  ),
                  child: const Text('通过浏览器打开'),
                ),
              ],
            ),
          );
  }
}

/// 左侧垂直导航切换动画
class RailTransition extends StatefulWidget {
  const RailTransition({
    super.key,
    required this.animation,
    required this.backgroundColor,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<RailTransition> createState() => _RailTransition();
}

class _RailTransition extends State<RailTransition> {
  late Animation<Offset> offsetAnimation;
  late Animation<double> widthAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool ltr = Directionality.of(context) == TextDirection.ltr;
    widthAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));
    offsetAnimation = Tween<Offset>(
      begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: widthAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

///底部导航切换动画
class BarTransition extends StatefulWidget {
  const BarTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Color backgroundColor;
  final Widget child;

  @override
  State<BarTransition> createState() => _BarTransition();
}

class _BarTransition extends State<BarTransition> {
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> heightAnimation;

  @override
  void initState() {
    super.initState();
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
    heightAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          heightFactor: heightAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.2,
            0.8,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.4,
            1.0,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}
