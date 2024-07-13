import 'engine_bridge.dart';

/// 引擎桥接
base mixin EngineBridgeMixin {
  /// 引擎桥接
  late EngineBridge _bridge;

  /// 初始化引擎桥接
  void initBridge() => _bridge = EngineBridge()();

  /// 获取引擎桥接
  EngineBridge get bridgeScope => _bridge;
}
