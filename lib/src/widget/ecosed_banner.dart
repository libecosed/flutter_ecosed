import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final class EcosedBanner extends StatelessWidget {
  const EcosedBanner({
    super.key,
    this.enabled = true,
    this.location = BannerLocation.topStart,
    required this.child,
  });

  final bool enabled;
  final BannerLocation location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Banner(
      message: 'ECOSED',
      textDirection: TextDirection.ltr,
      location: kDebugMode ? location : BannerLocation.topEnd,
      child: child,
    );
  }
}
