import '../interface/ecosed_interface.dart';
import '../type/runner.dart';
import 'base.dart';

base mixin BaseEntry on EcosedInterface {
  /// 入口
  @override
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    final EcosedInterface interface = EcosedBase()();
    try {
      return await interface.runEcosedApp(runner, plugins, app, error);
    } catch (exception) {
      return await super.runEcosedApp(runner, plugins, app, exception);
    }
  }
}
