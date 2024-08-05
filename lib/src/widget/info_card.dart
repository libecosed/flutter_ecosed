import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../plugin/plugin_details.dart';
import '../viewmodel/manager_view_model.dart';
import 'info_item.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.pluginDetailsList,
  });

  final String appName;
  final String appVersion;
  final List<PluginDetails> pluginDetailsList;

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
                      subtitle: appName,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '应用版本',
                      subtitle: appVersion,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '当前平台',
                      subtitle: Theme.of(context).platform.name,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '插件数量',
                      subtitle: viewModel.pluginCount().toString(),
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
