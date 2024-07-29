import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 角标横幅
final class EcosedBanner extends StatelessWidget {
  const EcosedBanner({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;
    return Banner(
      message: 'EcosedApp',
      textDirection: TextDirection.ltr,
      location: BannerLocation.topStart,
      layoutDirection: TextDirection.ltr,
      color: Colors.pink,
      child: child,
    );
  }
}
