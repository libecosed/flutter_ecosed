import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

class ExamplePlugin extends EcosedPlugin {
  const ExamplePlugin({super.key});

  @override
  String pluginName() {
    return 'Example Plugin.';
  }

  @override
  State<ExamplePlugin> createState() => _ExamplePluginState();
}

class _ExamplePluginState extends State<ExamplePlugin> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
