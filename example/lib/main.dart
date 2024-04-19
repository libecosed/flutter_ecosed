import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const ExampleApp());
}

class Executor {
  const Executor(this.exec);
  final dynamic exec;
  Future<dynamic> call(String channel, String method) async {
    return await exec(channel, method);
  }
}

extension ContextExecutor on BuildContext {
  Future<dynamic> execPluginMethod(String channel, String method) async {
    return await Global.executor(channel, method);
  }
}

/// Global全局类
class Global {
  /// 应用名称
  static const String appName = 'flutter_ecosed 示例应用';

  /// 页面索引
  static final ValueNotifier<int> pageIndex = ValueNotifier(0);

  /// 方法执行
  static late Executor executor;

  /// 计数 - 测试用
  static final ValueNotifier<int> counter = ValueNotifier(0);

  /// 是否显示FAB
  static final ValueNotifier<bool> showFab = ValueNotifier(true);
}

class ExecutorBuilder extends StatefulWidget {
  const ExecutorBuilder({super.key, required this.exec, required this.child});

  final Future<dynamic> Function(String, String) exec;
  final Widget child;

  @override
  State<ExecutorBuilder> createState() => _ExecutorBuilderState();
}

class _ExecutorBuilderState extends State<ExecutorBuilder> {
  @override
  void initState() {
    super.initState();
    Global.executor = Executor(widget.exec);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> implements EcosedPlugin {
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

  /// [onMethodCall]方法为插件的方法调用.
  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case "add":
        Global.counter.value++;
        return Global.counter.value;
      default:
        return await null;
    }
  }

  /// 右下角的打开按钮是打开[pluginWidget]方法定义的界面.
  @override
  Widget pluginWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Plugin'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }

  /// Widget的构建入口
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return EcosedApp(
          home: (context, exec, body) {
            return ExecutorBuilder(
              exec: exec,
              child: ValueListenableBuilder(
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
                      ManagerScreen(body: body),
                      const WebViewScreen(
                        url: 'https://pub.dev/packages/flutter_ecosed',
                      ),
                      const WebViewScreen(
                        url: 'https://github.com/libecosed/flutter_ecosed',
                      ),
                    ],
                  );
                },
              ),
            );
          },
          plugins: [this],
          title: Global.appName,
          location:
              kDebugMode ? BannerLocation.topStart : BannerLocation.topEnd,
          scaffold: (body, title) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: body,
              bottomNavigationBar: ValueListenableBuilder(
                valueListenable: Global.pageIndex,
                builder: (context, value, child) {
                  return NavigationBar(
                    selectedIndex: value,
                    destinations: const [
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
                    ],
                    onDestinationSelected: (value) {
                      Global.pageIndex.value = value;
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
                    child: FloatingActionButton(
                      onPressed: () =>
                          context.execPluginMethod(pluginChannel(), "add"),
                      tooltip: '点击增加右上角的数字大小,此功能通过EcosedPlugin方法调用实现.',
                      child: const Icon(Icons.add),
                    ),
                  );
                },
              ),
            );
          },
          materialApp: (home, title) {
            return MaterialApp(
              home: home,
              title: title,
              theme: ThemeData(colorScheme: light),
              darkTheme: ThemeData(colorScheme: dark),
            );
          },
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
  const ManagerScreen({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(child: body);
  }
}

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android ||
            Theme.of(context).platform == TargetPlatform.iOS
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
