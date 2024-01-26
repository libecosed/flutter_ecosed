import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import '../layout/manager.dart';
import '../platform/flutter_ecosed.dart';
import '../plugin/plugin.dart';
import '../value/default_info.dart';
import 'banner.dart';

abstract class EcosedAppWrapper {
  List<EcosedPlugin> initialPlugin();

  /// 调用插件方法
  Object? execPluginCall(String name);
}

typedef Exec = Object? Function(String channel, String method);
typedef RunApp = void Function(Widget app);
typedef EcosedApps = Widget Function(VoidCallback open, Exec exec);

class EcosedApp extends EcosedPlugin implements EcosedAppWrapper {
  const EcosedApp(
      {super.key,
      required this.app,
      required this.plugins,
      required this.title});

  final EcosedApps app;
  final List<EcosedPlugin> plugins;
  final String title;

  @override
  State<EcosedApp> createState() => _EcosedAppState();

  @override
  String pluginName() => 'EcosedApp';

  @override
  String pluginAuthor() => defaultAuthor;

  @override
  String pluginChannel() => 'flutter_ecosed_app';

  @override
  String pluginDescription() => title;

  @override
  Object? onEcosedMethodCall(String name) {
    return null;
  }

  @override
  Object? execPluginCall(String name) {
    return '';
  }

  @override
  List<EcosedPlugin> initialPlugin() {
    return [this, const FlutterEcosed()];
  }
}

class _EcosedAppState extends State<EcosedApp> {
  final ValueNotifier<int> _managerIndex = ValueNotifier(0);
  final List<EcosedPlugin> _pluginList = [];

  final int app = 0;
  final int managerIndex = 1;

  @override
  void initState() {
    for (var element in widget.initialPlugin()) {
      _pluginList.add(element);
    }
    for (var element in widget.plugins) {
      _pluginList.add(element);
    }
    super.initState();
  }

  Object? exec(String channel, String method) {
    for (var element in _pluginList) {
      if (element.pluginChannel() == channel) {
        return element.onEcosedMethodCall(method);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
            MaterialApp(
                title: widget.title,
                home: EcosedBanner(
                    child: ValueListenableBuilder(
                        valueListenable: _managerIndex,
                        builder: (context, value, child) {
                          return IndexedStack(
                            index: value,
                            children: [
                              Container(
                                  child: widget.app(
                                      () => _managerIndex.value = managerIndex,
                                      (channel, method) =>
                                          exec(channel, method))),
                              //widget.app(manager),
                              EcosedHome(onPressed: () {
                                _managerIndex.value = app;
                              }),
                            ],
                          );
                        })),
                theme: ThemeData(colorScheme: lightDynamic, useMaterial3: true),
                darkTheme:
                    ThemeData(colorScheme: darkDynamic, useMaterial3: true),
                themeMode: ThemeMode.system));
  }
}
