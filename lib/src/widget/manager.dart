import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import '../plugin/plugin_details.dart';
import 'info_card.dart';
import 'more_card.dart';
import 'plugin_card_list.dart';
import 'state_card.dart';

class EcosedManager extends StatefulWidget {
  const EcosedManager({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.pluginDetailsList,
  });

  final String appName;
  final String appVersion;
  final List<PluginDetails> pluginDetailsList;

  @override
  State<EcosedManager> createState() => _EcosedManagerState();
}

class A extends Breakpoint {
  @override
  bool isActive(BuildContext context) {
    return true;
  }
}

class _EcosedManagerState extends State<EcosedManager> {
  final ScrollController _scrollController = ScrollController();

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
          icon: Icon(Icons.abc),
          label: 'home',
        ),
        NavigationDestination(
          icon: Icon(Icons.abc),
          label: 'home',
        ),
      ],
      appBar: AppBar(
        title: const Text('管理器'),
      ),
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      appBarBreakpoint: Breakpoints.standard,
      useDrawer: false,
      body: (context) => Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: StateCard(
                appName: widget.appName,
                appVersion: widget.appVersion,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: InfoCard(
                appName: widget.appName,
                appVersion: widget.appVersion,
                pluginDetailsList: widget.pluginDetailsList,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: MoreCard(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: PluginCardList(
                pluginDetailsList: widget.pluginDetailsList,
                appName: widget.appName,
                appVersion: widget.appVersion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
