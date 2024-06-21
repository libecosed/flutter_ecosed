import 'package:flutter/material.dart';

import '../plugin/plugin.dart';
import '../service/service_mixin.dart';

final class EcosedLibKernel with VMServiceWrapper {
  EcosedLibKernel();

}

abstract class EcosedKernelModule implements EcosedPlugin {
  @override
  Future onMethodCall(String method, [arguments]) {
    // TODO: implement onMethodCall
    throw UnimplementedError();
  }

  @override
  String pluginAuthor() {
    // TODO: implement pluginAuthor
    throw UnimplementedError();
  }

  @override
  String pluginChannel() {
    // TODO: implement pluginChannel
    throw UnimplementedError();
  }

  @override
  String pluginDescription() {
    // TODO: implement pluginDescription
    throw UnimplementedError();
  }

  @override
  String pluginName() {
    // TODO: implement pluginName
    throw UnimplementedError();
  }

  @override
  Widget pluginWidget(BuildContext context) {
    // TODO: implement pluginWidget
    throw UnimplementedError();
  }
}

class KernelBridge extends EcosedKernelModule {}

class SystemCall extends EcosedKernelModule {}

class FileSystem extends EcosedKernelModule {}
