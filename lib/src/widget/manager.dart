import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../plugin/plugin_details.dart';
import '../viewmodel/manager_view_model.dart';

class EcosedManager extends StatefulWidget {
  const EcosedManager({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.pluginDetailsList,
    required this.pluginList,
  });

  final String appName;
  final String appVersion;
  final List<PluginDetails> pluginDetailsList;
  final Widget pluginList;

  @override
  State<EcosedManager> createState() => _EcosedManagerState();
}

class _EcosedManagerState extends State<EcosedManager> {
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
              child: widget.pluginList,
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
  });

  final String appName;
  final String appVersion;

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
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text('调试菜单'),
                    children: <SimpleDialogOption>[
                      SimpleDialogOption(
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: const Text('关闭'),
                          leading: const FlutterLogo(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          enabled: true,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  );
                },
                useRootNavigator: false,
              ),
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
                builder: (context, viewModel, child) {
                  return Column(
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
                            .pluginCount(list: widget.pluginDetailsList)
                            .toString(),
                      ),
                    ],
                  );
                },
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
              builder: (context, viewModel, child) {
                return IconButton(
                  onPressed: () => viewModel.launchPubDev(),
                  icon: Icon(
                    Icons.open_in_browser,
                    size: Theme.of(context).iconTheme.size,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
