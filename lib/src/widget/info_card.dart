import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/manager_view_model.dart';
import 'info_item.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

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
                      subtitle: viewModel.getAppName,
                    ),
                    const SizedBox(height: 16),
                    InfoItem(
                      title: '应用版本',
                      subtitle: viewModel.getAppVersion,
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
