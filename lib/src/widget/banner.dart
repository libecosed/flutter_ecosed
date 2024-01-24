import 'package:flutter/material.dart';

class EcosedBanner extends StatelessWidget {
  const EcosedBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Banner(
        message: 'ECOSED',
        textDirection: TextDirection.ltr,
        location: BannerLocation.topStart,
        color: Colors.pinkAccent,
        child: child);
  }
}
