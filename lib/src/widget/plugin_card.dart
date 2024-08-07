import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../plugin/plugin_details.dart';
import '../viewmodel/manager_view_model.dart';

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.details,
  });

  final PluginDetails details;

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
                  Tooltip(
                    message: viewModel.getPluginTooltip(details),
                    child: TextButton(
                      onPressed: viewModel.openPlugin(details),
                      child: Text(
                        viewModel.getPluginAction(details),
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
