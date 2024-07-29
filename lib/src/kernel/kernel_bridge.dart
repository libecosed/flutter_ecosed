import 'kernel_module.dart';

final class KernelBridge extends EcosedKernelModule {}

base mixin KernelBridgeMixin {
  late KernelBridge _kernelBridge;

  void initKernelBridge() => _kernelBridge = KernelBridge();

  KernelBridge get kernelBridgeScope => _kernelBridge;
}
