import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:provider/provider.dart';

import '../viewmodel/manager_view_model.dart';
import 'home_page.dart';
import 'log_page.dart';
import 'plugin_page.dart';
import 'settings_page.dart';

class EcosedManager extends StatefulWidget {
  const EcosedManager({super.key});

  @override
  State<EcosedManager> createState() => _EcosedManagerState();
}

class _EcosedManagerState extends State<EcosedManager> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 当前页面
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '主页',
          tooltip: '主页',
          enabled: true,
        ),
        NavigationDestination(
          icon: Icon(Icons.bug_report_outlined),
          selectedIcon: Icon(Icons.bug_report),
          label: '日志',
          tooltip: '日志',
          enabled: true,
        ),
        NavigationDestination(
          icon: Icon(Icons.extension_outlined),
          selectedIcon: Icon(Icons.extension),
          label: '插件',
          tooltip: '插件',
          enabled: true,
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: '设置',
          tooltip: '设置',
          enabled: true,
        ),
      ],
      smallBreakpoint: const WidthPlatformBreakpoint(end: 600),
      mediumBreakpoint: const WidthPlatformBreakpoint(begin: 600, end: 840),
      largeBreakpoint: const WidthPlatformBreakpoint(begin: 840),
      selectedIndex: _currentIndex,
      body: (context) => PageTransitionSwitcher(
        duration: const Duration(
          milliseconds: 300,
        ),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        child: [
          const HomePage(),
          const LogPage(),
          const PluginPage(),
          const SettingsPage(),
        ][_currentIndex],
      ),
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      onSelectedIndexChange: (index) => setState(
        () => _currentIndex = index,
      ),
      useDrawer: false,
      appBar: AppBar(
        title: const Text('管理器'),
        actions: [
          Tooltip(
            message: '调试菜单',
            child: Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => IconButton(
                onPressed: viewModel.openDebugMenu,
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ),
        ],
      ),
      appBarBreakpoint: Breakpoints.standard,
    );
  }
}
