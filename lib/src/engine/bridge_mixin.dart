import 'engine_bridge.dart';

/// 引擎桥接
base mixin EngineBridgeMixin {
  /// 引擎桥接
  late EngineBridge _engineBridge;

  /// 初始化引擎桥接
  Future<void> initEngineBridge() async => _engineBridge = EngineBridge()();

  /// 获取引擎桥接
  EngineBridge get engineBridgerScope => _engineBridge;
}
