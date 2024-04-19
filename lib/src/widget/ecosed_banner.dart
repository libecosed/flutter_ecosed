import 'package:flutter/material.dart';

final class EcosedBanner extends StatelessWidget {
  const EcosedBanner({
    super.key,
    required this.location,
    required this.child,
  });

  final BannerLocation location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'EcosedApp',
      location: location,
      color: Colors.pinkAccent,
      child: child,
    );
  }
}
