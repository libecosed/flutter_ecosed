import 'package:flutter/material.dart';

import '../app/app_type.dart';

final class EcosedMaterialApp extends StatelessWidget {
  const EcosedMaterialApp({
    super.key,
    required this.title,
    required this.materialApp,
    required this.home,
  });

  final String title;
  final EcosedApps materialApp;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: materialApp(home, title),
    );
  }
}
