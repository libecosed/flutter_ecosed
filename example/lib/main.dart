import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends EcosedPlugin {
  const ExampleApp({super.key});

  @override
  String pluginAuthor() => 'ExampleApp';

  @override
  String pluginChannel() => 'ExampleApp';

  @override
  String pluginDescription() => 'ExampleApp';

  @override
  String pluginName() => 'ExampleApp';

  @override
  State<ExampleApp> createState() => _ExampleAppState();

  @override
  Future<Object?> onPlatformCall(String name) async {
    return null;
  }
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
            plugins: [widget],
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
        );
      },
    );
  }
}
