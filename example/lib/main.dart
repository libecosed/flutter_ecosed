import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EcosedApp(
          app: (view, exec) => Scaffold(
                appBar: AppBar(
                  title: const Text('FlutterEcosed Example App'),
                ),
                body: view,
              ),
          bannerLocation: BannerLocation.topStart,
          appName: 'FlutterEcosed',
          plugins: const [ExamplePlugin()]),
    );
  }
}

class ExamplePlugin extends EcosedPlugin {
  const ExamplePlugin({super.key});

  @override
  String pluginName() => 'Example Plugin.';

  @override
  State<ExamplePlugin> createState() => _ExamplePluginState();

  @override
  String pluginAuthor() => 'example';

  @override
  String pluginChannel() => 'flutter_example';

  @override
  String pluginDescription() => 'example';

  @override
  void onEcosedAdded() {}

  @override
  Object? onEcosedMethodCall(String name) {
    return null;
  }
}

class _ExamplePluginState extends State<ExamplePlugin> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
