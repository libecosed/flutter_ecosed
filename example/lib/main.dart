import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> implements EcosedPlugin {
  _ExampleAppState();

  /// 应用名称
  static const String _appName = 'flutter_ecosed 示例应用';

  /// 页面索引
  static final ValueNotifier<int> _pageIndex = ValueNotifier(0);

  /// 方法执行
  static late dynamic _exec;

  /// 计数 - 测试用
  static final ValueNotifier<int> _counter = ValueNotifier(0);

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
  Future<Object?> onMethodCall(String name) async {
    if (name == "add") {
      _counter.value++;
    }
    return await null;
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
            _exec = exec;
            return ValueListenableBuilder(
              valueListenable: _pageIndex,
              builder: (context, value, child) {
                return IndexedStack(
                  index: value,
                  children: <Widget>[
                    FutureBuilder(
                      future: rootBundle
                          .loadString('packages/flutter_ecosed/README.md'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Markdown(
                            data: snapshot.data!,
                            selectable: true,
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('自述文件加载错误'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    Container(child: body),
                    Focus(
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
                              Uri.parse(
                                'https://pub.dev/packages/flutter_ecosed',
                              ),
                            )
                            ..setJavaScriptMode(
                              JavaScriptMode.unrestricted,
                            ),
                        ),
                      ),
                    ),
                    Focus(
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
                              Uri.parse(
                                'https://github.com/libecosed/flutter_ecosed',
                              ),
                            )
                            ..setJavaScriptMode(
                              JavaScriptMode.unrestricted,
                            ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          plugins: [this],
          title: _appName,
          location:
              kDebugMode ? BannerLocation.topStart : BannerLocation.topEnd,
          scaffold: (body, title) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: [
                  IconButton(
                    onPressed: () => _exec(pluginChannel(), "add"),
                    icon: ValueListenableBuilder(
                      valueListenable: _counter,
                      builder: (context, value, child) {
                        return Text(
                          value.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      },
                    ),
                  )
                ],
              ),
              body: body,
              bottomNavigationBar: ValueListenableBuilder(
                valueListenable: _pageIndex,
                builder: (context, value, child) {
                  return NavigationBar(
                    selectedIndex: value,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: '主页',
                        tooltip: '自述文件REDAME.md',
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
                      _pageIndex.value = value;
                    },
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _exec(pluginChannel(), "add"),
                tooltip: '点击增加右上角的数字大小,此功能通过EcosedPlugin方法调用实现.',
                child: const Icon(Icons.add),
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
