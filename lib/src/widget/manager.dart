import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/widget/info.dart';
import 'package:flutter_ecosed/src/widget/more.dart';
import 'package:flutter_ecosed/src/widget/plugin.dart';
import 'package:flutter_ecosed/src/widget/state.dart';

import '../plugin/plugin_details.dart';

final class EcosedManager extends StatefulWidget {
  const EcosedManager({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.openDialog,
    required this.closeDialog,
    required this.pluginCount,
    required this.pluginDetailsList,
    required this.isAllowPush,
    required this.isRuntime,
    required this.pluginWidget,
  });

  final String appName;
  final String appVersion;
  final VoidCallback openDialog;
  final VoidCallback closeDialog;
  final int pluginCount;
  final List<PluginDetails> pluginDetailsList;
  final bool Function(PluginDetails details) isAllowPush;
  final bool Function(PluginDetails details) isRuntime;
  final Widget Function(
    BuildContext context,
    PluginDetails details,
  ) pluginWidget;

  @override
  State<EcosedManager> createState() => _EcosedManagerState();
}

final class _EcosedManagerState extends State<EcosedManager> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理器'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: StateCard(
                appName: widget.appName,
                appVersion: widget.appVersion,
                openDialog: widget.openDialog,
                closeDialog: widget.closeDialog,
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
                pluginCount: widget.pluginCount,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: LearnMoreCard(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: PluginListCard(
                pluginDetailsList: widget.pluginDetailsList,
                appName: widget.appName,
                appVersion: widget.appVersion,
                isAllowPush: widget.isAllowPush,
                isRuntime: widget.isAllowPush,
                pluginWidget: widget.pluginWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
