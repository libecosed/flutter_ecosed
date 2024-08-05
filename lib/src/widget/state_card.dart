import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/manager_view_model.dart';

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
            Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => IconButton(
                onPressed: viewModel.openDebugMenu,
                icon: Icon(
                  Icons.developer_mode,
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
