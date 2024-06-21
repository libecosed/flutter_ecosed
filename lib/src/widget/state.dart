import 'package:flutter/material.dart';

final class StateCard extends StatelessWidget {
  const StateCard({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.openDialog,
    required this.closeDialog,
  });

  final String appName;
  final String appVersion;
  final VoidCallback openDialog;
  final VoidCallback closeDialog;

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
                      '版本:\t$appVersion',
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
                    title: const Text('调试菜单 (Flutter)'),
                    children: <SimpleDialogOption>[
                      SimpleDialogOption(
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: const Text('打开平台调试菜单'),
                          leading: Icon(
                            Icons.android,
                            size: Theme.of(context).iconTheme.size,
                            color: Colors.green,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          enabled: Theme.of(context).platform ==
                              TargetPlatform.android,
                          onTap: openDialog,
                        ),
                      ),
                      SimpleDialogOption(
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: const Text('关闭平台调试菜单'),
                          leading: Icon(
                            Icons.android,
                            size: Theme.of(context).iconTheme.size,
                            color: Colors.green,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          enabled: Theme.of(context).platform ==
                              TargetPlatform.android,
                          onTap: closeDialog,
                        ),
                      ),
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
