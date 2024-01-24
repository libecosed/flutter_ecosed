import 'package:flutter/material.dart';

import '../layout/ecosed_manager.dart';
import '../plugin/plugin.dart';

const bool kIsEcosedDevMode = bool.fromEnvironment(
  'ecosed.library.devmode',
  defaultValue: false,
);

class EcosedApp extends StatefulWidget {
  const EcosedApp({super.key, required this.app, required this.plugins, required this.title});

  final Widget app;
  final List<EcosedPlugin> plugins;
  final String title;

  @override
  State<EcosedApp> createState() => _EcosedAppState();
}

class _EcosedAppState extends State<EcosedApp> {
  @override
  Widget build(BuildContext context) {
    return const EcosedManager();
  }
}
