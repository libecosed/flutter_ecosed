import 'package:flutter/widgets.dart';

import '../plugin/plugin.dart';

final class EcosedRuntime implements EcosedPlugin {
  EcosedRuntime({
    required this.app,
    required this.plugins,
    required this.runApplication,
  });

  final Widget Function(Widget manager) app;
  final List<EcosedPlugin> plugins;
  final void Function(Widget app) runApplication;

  late List<EcosedPlugin> _pluginList;

  Future<void> call() async {

    _pluginList = <EcosedPlugin>[];
    _pluginList.add(this);
    _pluginList.addAll(plugins);


    Widget manager = const Text('');

    runApplication(app(manager));
  }

  @override
  Future<dynamic> onMethodCall(String method) async {
    return await null;
  }

  @override
  String pluginAuthor() => 'wyq0918dev';

  @override
  String pluginChannel() => 'ecosed_runtime';

  @override
  String pluginDescription() => 'Ecosed Runtime';

  @override
  String pluginName() => 'EcosedRuntime';

  @override
  Widget pluginWidget(BuildContext context) {
    return Container();
  }
}
