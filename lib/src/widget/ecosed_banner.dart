import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final class EcosedBanner extends StatelessWidget {
  const EcosedBanner({
    super.key,
    this.enabled = true,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: 'EcosedApp',
        textDirection: TextDirection.ltr,
        location: kDebugMode ? BannerLocation.topStart : BannerLocation.topEnd,
        child: child,
      ),
    );
  }
}
