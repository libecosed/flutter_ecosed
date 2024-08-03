import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/type/plugin_widget_gatter.dart';
import 'package:flutter_ecosed/src/type/runtiem_checker.dart';
import 'package:provider/provider.dart';

import '../plugin/plugin_details.dart';
import '../type/plugin_getter.dart';
import '../viewmodel/manager_view_model.dart';

class EcosedManager extends StatefulWidget {
  const EcosedManager({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.pluginDetailsList,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
    required this.openDebugMenu,
  });

  final String appName;
  final String appVersion;
  final List<PluginDetails> pluginDetailsList;
  final PluginGetter getPlugin;
  final PluginWidgetGetter getPluginWidget;
  final RuntimeChecker isRuntime;
  final VoidCallback openDebugMenu;

  @override
  State<EcosedManager> createState() => _EcosedManagerState();
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
    // ScrollConfiguration(
    //               // A Scrollbar is built-in below.
    //               behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
    //               child: Scrollbar(
    //                 child: ListView(
    //                   primary: true,
    //                   padding: padding,
    //                   children: listWidgets,
    //                 ),
    //               ),
    //             )
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
                openDebugMenu: widget.openDebugMenu,
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
                getPlugin: widget.getPlugin,
                getPluginWidget: widget.getPluginWidget,
                isRuntime: widget.isRuntime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StateCard extends StatelessWidget {
  const StateCard({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.openDebugMenu,
  });

  final String appName;
  final String appVersion;
  final VoidCallback openDebugMenu;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_command_key,
              size: Theme.of(context).iconTheme.size,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appVersion,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: openDebugMenu,
              icon: Icon(
                Icons.developer_mode,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard(
      {super.key,
      required this.appName,
      required this.appVersion,
      required this.pluginDetailsList});

  final String appName;
  final String appVersion;
  final List<PluginDetails> pluginDetailsList;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Consumer<ManagerViewModel>(
                builder: (context, viewModel, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoItem(
                      title: '应用名称',
                      subtitle: widget.appName,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '应用版本',
                      subtitle: widget.appVersion,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '当前平台',
                      subtitle: Theme.of(context).platform.name,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '插件数量',
                      subtitle: viewModel
                          .pluginCount(widget.pluginDetailsList)
                          .toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class MoreCard extends StatefulWidget {
  const MoreCard({super.key});

  @override
  State<MoreCard> createState() => _MoreCardState();
}

class _MoreCardState extends State<MoreCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '了解 flutter_ecosed',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '了解如何使用 flutter_ecosed 进行开发。',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => IconButton(
                onPressed: () => viewModel.launchPubDev(),
                icon: Icon(
                  Icons.open_in_browser,
                  size: Theme.of(context).iconTheme.size,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PluginCardList extends StatelessWidget {
  const PluginCardList({
    super.key,
    required this.pluginDetailsList,
    required this.appName,
    required this.appVersion,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
  });

  final List<PluginDetails> pluginDetailsList;

  final String appName;
  final String appVersion;
  final PluginGetter getPlugin;
  final PluginWidgetGetter getPluginWidget;
  final RuntimeChecker isRuntime;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: pluginDetailsList
          .map(
            (element) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Builder(
                builder: (context) => PluginCard(
                  details: element,
                  appName: appName,
                  appVersion: appVersion,
                  getPlugin: getPlugin,
                  getPluginWidget: getPluginWidget,
                  isRuntime: isRuntime,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.details,
    required this.appName,
    required this.appVersion,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
  });

  final PluginDetails details;
  final String appName;
  final String appVersion;
  final PluginGetter getPlugin;
  final PluginWidgetGetter getPluginWidget;
  final RuntimeChecker isRuntime;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '通道: ${details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: ${details.author}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<ManagerViewModel>(
                  builder: (context, viewModel, child) => Container(
                    child: viewModel.getPluginIcon(details),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              details.description,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => Row(
                children: [
                  Expanded(
                    child: Text(
                      viewModel.getPluginType(details),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: viewModel.openPlugin(
                      details,
                      getPlugin,
                      isRuntime,
                      getPluginWidget,
                      appName,
                      appVersion,
                    ),
                    child: Text(
                      viewModel.getPluginAction(
                        details,
                        getPlugin,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
