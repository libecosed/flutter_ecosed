import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

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
}

class _ExamplePluginState extends State<ExamplePlugin> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
