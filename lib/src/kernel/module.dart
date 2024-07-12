import 'package:flutter/widgets.dart';

import '../plugin/plugin_base.dart';

abstract class EcosedKernelModule implements BaseEcosedPlugin {
  @override
  String get pluginAuthor => 'wyq0918dev';

  @override
  String get pluginChannel => 'ecosed_kernel_module';

  @override
  String get pluginDescription => 'EcosedKernelModule';

  @override
  String get pluginName => 'EcosedKernelModule';

  @override
  Widget pluginWidget(BuildContext context) {
    return const Text('Kernel Module');
  }

  @override
  Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
    return await null;
  }
}
