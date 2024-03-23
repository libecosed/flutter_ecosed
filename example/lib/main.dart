import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) {
        return const ExampleApp();
      },
    );
  }
}

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
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          home: EcosedApp(
            home: (exec, body) {
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
          ),
          builder: DevicePreview.appBuilder,
          title: appName,
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          locale: DevicePreview.locale(context),
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
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
    return Container();
  }
}
