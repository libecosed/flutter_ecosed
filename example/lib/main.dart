import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget implements EcosedPlugin {
  const ExampleApp({super.key});

  /// 应用名称
  static const String appName = 'flutter_ecosed 示例应用';

  /// 页面索引
  static ValueNotifier<int> pageIndex = ValueNotifier(0);

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

  @override
  Future<Object?> onMethodCall(String name) async {
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

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return EcosedApp(
          home: (context, exec, body) {
            return ValueListenableBuilder(
              valueListenable: pageIndex,
              builder: (context, value, child) {
                return IndexedStack(
                  index: value,
                  children: <Widget>[
                    FutureBuilder(
                      future: rootBundle.loadString('packages/flutter_ecosed/README.md'),
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
                                  'https://pub.dev/packages/flutter_ecosed'),
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
                                  'https://github.com/libecosed/flutter_ecosed'),
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
          title: appName,
          location: BannerLocation.topStart,
          scaffold: (body) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(appName),
              ),
              body: body,
              bottomNavigationBar: ValueListenableBuilder(
                valueListenable: pageIndex,
                builder: (context, value, child) {
                  return NavigationBar(
                    selectedIndex: value,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Home',
                        tooltip: 'Home',
                        enabled: true,
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: 'Manager',
                        tooltip: 'Manager',
                        enabled: true,
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.publish_outlined),
                        selectedIcon: Icon(Icons.publish),
                        label: 'PubDev',
                        tooltip: 'PubDev',
                        enabled: true,
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.code_outlined),
                        selectedIcon: Icon(Icons.code),
                        label: 'GitHub',
                        tooltip: 'GitHub',
                        enabled: true,
                      ),
                    ],
                    onDestinationSelected: (value) {
                      pageIndex.value = value;
                    },
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
