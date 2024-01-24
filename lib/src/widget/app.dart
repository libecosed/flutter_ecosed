import 'package:flutter/material.dart';

import '../plugin/plugin.dart';

const bool kIsEcosedDevMode = bool.fromEnvironment(
  'ecosed.library.devmode',
  defaultValue: false,
);

class EcosedApp extends StatefulWidget {
  const EcosedApp({super.key, required this.app, required this.plugin});

  final Widget app;
  final List<EcosedPlugin> plugin;

  @override
  State<EcosedApp> createState() => _EcosedAppState();
}

class _EcosedAppState extends State<EcosedApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
