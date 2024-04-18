import 'package:flutter/material.dart';

import '../app/app_type.dart';

class EcosedMaterialScaffold extends StatelessWidget {
  const EcosedMaterialScaffold({
    super.key,
    required this.scaffold,
    required this.title,
    required this.body,
  });

  final EcosedScaffold scaffold;
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: scaffold(body, title),
    );
  }
}
