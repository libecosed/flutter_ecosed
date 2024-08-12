import 'package:flutter/foundation.dart';

import '../interface/ecosed_interface.dart';
import '../type/runner.dart';
import 'base.dart';

base mixin BaseEntry on EcosedInterface {
  @override
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
  ) async {
    final EcosedInterface interface = EcosedBase()();
    try {
      return await interface.runEcosedApp(runner, plugins, app);
    } catch (e) {
      debugPrint(e.toString());
      return await super.runEcosedApp(runner, plugins, app);
    }
  }
}
