import 'package:flutter/material.dart';

import '../plugin/plugin.dart';
import '../service/service_mixin.dart';

final class EcosedLibKernel extends EcosedKernelModule with VMServiceWrapper {
  EcosedLibKernel();
}

abstract class EcosedKernelModule implements EcosedPlugin {
  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_kernel_module';

  @override
  String pluginDescription() => 'EcosedKernelModule';

  @override
  String pluginName() => 'EcosedKernelModule';

  @override
  Widget pluginWidget(BuildContext context) {
    return const Text('Kernel Module');
  }

  @override
  Future<dynamic> onMethodCall(String method, [arguments]) async {
    return await null;
  }
}

class KernelBridge extends EcosedKernelModule {}

class SystemCall extends EcosedKernelModule {}

class FileSystem extends EcosedKernelModule {}
