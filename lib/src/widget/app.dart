import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/value/default_info.dart';
import 'package:flutter_ecosed/src/widget/banner.dart';

import '../layout/manager.dart';
import '../plugin/plugin.dart';

typedef RunApp = void Function(Widget app);
typedef EcosedApps = Widget Function(VoidCallback openManager);

class EcosedApp extends EcosedPlugin {
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
  String pluginDescription() => '应用入口';
}

class _EcosedAppState extends State<EcosedApp> {
  final ValueNotifier<int> _managerIndex = ValueNotifier(1);

  final int app = 0;
  final int managerIndex = 1;

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
                              Container(child: widget.app(() {
                                _managerIndex.value = managerIndex;
                              })),
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
