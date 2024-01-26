import 'package:flutter/material.dart';

import 'overview.dart';
import 'plugins.dart';

class EcosedHome extends StatefulWidget {
  const EcosedHome({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<EcosedHome> createState() => _EcosedHomeState();
}

class _EcosedHomeState extends State<EcosedHome> {
  final ValueNotifier<int> _pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("管理器"),
          leading: IconButton(
              onPressed: widget.onPressed, icon: const Icon(Icons.arrow_back)),
        ),
        body: ValueListenableBuilder(
            valueListenable: _pageIndex,
            builder: (context, value, child) {
              return IndexedStack(
                index: value,
                children: [
                  const OverviewPage(),
                  Text('data'),
                  const PluginPage(),
                ],
              );
            }),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _pageIndex,
            builder: (context, value, child) {
              return NavigationBar(
                  selectedIndex: _pageIndex.value,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: "概览",
                      tooltip: "查看插件工作状态",
                      enabled: true,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.manage_accounts_outlined),
                      selectedIcon: Icon(Icons.manage_accounts),
                      label: "管理",
                      tooltip: "管理插件",
                      enabled: true,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.extension_outlined),
                      selectedIcon: Icon(Icons.extension),
                      label: "插件",
                      tooltip: "管理插件",
                      enabled: true,
                    ),
                  ],
                  onDestinationSelected: (index) {
                    _pageIndex.value = index;
                  },
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected);
            }));
  }
}
