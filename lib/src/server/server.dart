import '../kernel/kernel_module.dart';
import '../service/service_mixin.dart';

final class Shizuku extends EcosedKernelModule with VMServiceWrapper {}

base class ShizukuApps {}

final class ServerBridge {}

base mixin class ServerBridgeMixin {
  late ServerBridge _serverBridge;

  void initServerBridge() => _serverBridge = ServerBridge();

  ServerBridge get serverBridgeScope => _serverBridge;
}
