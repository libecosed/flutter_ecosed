import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../platform/ecosed_platform_interface.dart';
import 'method_channel.dart';

abstract class AndroidEcosedPlatform extends PlatformInterface
    implements EcosedPlatformInterface {
  AndroidEcosedPlatform() : super(token: _token);

  /// 令牌
  static final Object _token = Object();

  /// 实例
  static AndroidEcosedPlatform get instance => MethodChannelAndroidEcosed();
}
