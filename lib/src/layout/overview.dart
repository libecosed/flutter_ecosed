import 'package:flutter/material.dart';

import '../widget/info_card.dart';
import '../widget/state_card.dart';
import '../widget/warning_card.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: StateCard(
            color: Theme.of(context).colorScheme.primaryContainer,
            icon: Icons.check_circle_outline,
            title: 'flutter_ecosed',
            subtitle: 'flutter_ecosed',
          ),
        ),

        Visibility(
          visible: true,
          child: WarningCard(
            title: '哦豁,环境异常:(',
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: InfoCard(),
        ),
      ],
    );
  }
}
