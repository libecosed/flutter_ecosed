import 'package:flutter/material.dart';

import '../plugin/plugin_base.dart';
import '../service/service_mixin.dart';

final class EcosedLibKernel extends EcosedKernelModule with VMServiceWrapper {
  EcosedLibKernel();
}

abstract class EcosedKernelModule implements BaseEcosedPlugin {
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
  Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
    return await null;
  }
}

final class KernelBridge extends EcosedKernelModule {}

final class SystemCall extends EcosedKernelModule {}

final class FileSystem extends EcosedKernelModule {}
