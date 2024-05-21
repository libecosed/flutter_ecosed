import 'package:flutter/widgets.dart';

import '../platform/ecosed_platform_interface.dart';
import '../plugin/plugin.dart';
import '../values/methods.dart';
import '../widget/ecosed_banner.dart';

final class EcosedRuntime implements EcosedPlugin, EcosedPlatformInterface {
  EcosedRuntime({
    required this.app,
    required this.plugins,
    required this.runApplication,
  });

  final Widget Function(Widget manager) app;
  final List<EcosedPlugin> plugins;
  final Future<void> Function(Widget app) runApplication;

  final EcosedPlatformInterface _platform = EcosedPlatformInterface.instance;

  late List<EcosedPlugin> _pluginList;

  Future<void> call() async {
    await _init();

    Widget manager = const Text('');

    await runApplication(EcosedBanner(child: app(manager)));
  }

  Future<void> _init() async {
    _pluginList = <EcosedPlugin>[];
    _pluginList.add(this);
    _pluginList.addAll(plugins);
  }

  @override
  Future<dynamic> onMethodCall(String method) async {
    switch (method) {
      case getPluginMethod:
        return await getPlatformPluginList();
      case openDialogMethod:
        return await openPlatformDialog();
      case closeDialogMethod:
        return await closePlatformDialog();
      default:
        return await null;
    }
  }

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'runtime';

  @override
  String pluginDescription() => 'Ecosed Runtime';

  @override
  String pluginName() => 'EcosedRuntime';

  @override
  Widget pluginWidget(BuildContext context) {
    return Container();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return await _platform.getPlatformPluginList();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _platform.openPlatformDialog();
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await _platform.closePlatformDialog();
  }
}
