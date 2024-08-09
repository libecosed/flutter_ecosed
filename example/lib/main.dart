import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

Future<void> main() async {
  await runEcosedApp(
    app: const MyApp(),
    plugins: const [ExamplePlugin()],
    runner: (app) async => runApp(app),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Global.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(Global.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              onPressed: () => openDebugMenu(),
              child: const Text('调试菜单'),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            ValueListenableBuilder(
              valueListenable: Global.counter,
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await execPluginMethod(
            'example_channel',
            Global.add,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Global全局类
class Global {
  const Global();

  /// 应用名称
  static const String appName = 'flutter_ecosed 示例应用';

  /// 计数
  static final ValueNotifier<int> counter = ValueNotifier(0);

  /// 计数器
  static const String add = 'add';
}

final class ExamplePlugin extends StatelessWidget implements EcosedPlugin {
  const ExamplePlugin({super.key});

  /// “ExampleAuthor”为作者信息,替换为你自己的名字即可,通过[pluginAuthor]方法定义.
  @override
  String get pluginAuthor => 'ExampleAuthor';

  /// “example_channel”为插件的通道,可以理解为插件的唯一标识,我们通常使用全小写英文字母加下划线的命名方式,通过[pluginChannel]方法定义.
  @override
  String get pluginChannel => 'example_channel';

  /// "Example description"为插件的描述,通过[pluginDescription]方法定.
  @override
  String get pluginDescription => 'Example description';

  /// “Example Plugin”为插件的名称,通过[pluginName]方法定义.
  @override
  String get pluginName => 'ExamplePlugin';

  @override
  Widget pluginWidget(BuildContext context) => this;

  /// [onMethodCall]方法为插件的方法调用.
  @override
  Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
    switch (method) {
      case Global.add:
        return Global.counter.value++;
      default:
        return await null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello, World!'),
    );
  }
}
