import 'engine_bridge.dart';

base mixin BridgeMixin {
  late EngineBridge _bridge;

  void initBridge() {
    _bridge = EngineBridge()();
  }

  EngineBridge get bridgeScope => _bridge;
}
