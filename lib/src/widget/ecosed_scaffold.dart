import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/app/app_type.dart';

class EcosedScaffoldWidget extends StatelessWidget {
  const EcosedScaffoldWidget({
    super.key,
    required this.scaffold,
    required this.body,
  });

  final EcosedScaffold scaffold;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: scaffold(body),
    );
  }
}
