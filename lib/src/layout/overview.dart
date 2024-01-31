import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key, required this.appName});

  final String appName;

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const FlutterLogo(),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.appName,
                          textAlign: TextAlign.left,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Powered by Flutter Ecosed',
                          textAlign: TextAlign.left,
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: MaterialBanner(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            backgroundColor: Colors.transparent,
            content: Text('哦豁,环境异常:('),
            actions: [
              Visibility(
                visible: true,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('安装Shizuku'),
                ),
              ),
              Visibility(
                visible: true,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('安装microG'),
                ),
              ),
              Visibility(
                visible: true,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('申请所需权限'),
                ),
              ),
            ],
            dividerColor: Colors.transparent,
            forceActionsBelow: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '应用版本',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        '1.0',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        '内核版本',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        '1.0',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '设备架构',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        '1.0',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Shizuku版本',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        '1.0',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
