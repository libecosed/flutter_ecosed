import 'package:flutter/material.dart';

import '../plugin/plugin.dart';
import '../service/service_mixin.dart';

final class EcosedLibKernel with VMServiceWrapper {
  EcosedLibKernel();

  final EcosedKernelModule module = EcosedKernelModule();
}

base class EcosedKernelModule implements EcosedPlugin {
  // 内核模块列表
  final List<EcosedKernelModule> moduleList = [
    KernelBridge(),
  ];

  @override
  Future<dynamic> onMethodCall(String method, [arguments]) async {
    return await null;
  }

  @override
  String pluginAuthor() => '';

  @override
  String pluginChannel() => '';

  @override
  String pluginDescription() => '';

  @override
  String pluginName() => '';

  @override
  Widget pluginWidget(BuildContext context) {
    return Container();
  }
}

final class KernelBridge extends EcosedKernelModule {}

final class FileSystem extends EcosedKernelModule {}
