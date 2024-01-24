import 'package:flutter/material.dart';

import '../layout/ecosed_manager.dart';
import '../plugin/plugin.dart';

class EcosedKit extends StatelessWidget {
  const EcosedKit({super.key, required this.title, required this.plugins, required this.app});

  final String title;
  final List<EcosedPlugin> plugins;
  final Widget app;

  @override
  Widget build(BuildContext context) {
    return const EcosedManager();
  }
}
