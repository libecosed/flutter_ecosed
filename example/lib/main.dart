import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const String appName = 'flutter_ecosed 示例应用';

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return EcosedApp(
          home: (context, exec, body) {
            return body;
          },
          plugins: const [ExamplePlugin()],
          title: appName,
          location: BannerLocation.topStart,
          scaffold: (body) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(appName),
              ),
              body: body,
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

class ExamplePlugin extends StatelessWidget implements EcosedPlugin {
  const ExamplePlugin({super.key});

  @override
  Future<Object?> onMethodCall(String name) async {
    return await null;
  }

  @override
  String pluginAuthor() => 'ExampleAuthor';

  @override
  String pluginChannel() => 'example_channel';

  @override
  String pluginDescription() => 'this is an example plugin.';

  @override
  String pluginName() => 'ExamplePlugin';

  @override
  Widget pluginWidget(BuildContext context) => this;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Plugin'),
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
