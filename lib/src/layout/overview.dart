import 'dart:math';

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
            color: Theme.of(context).colorScheme.errorContainer,
            icon: Icons.check_circle_outline,
            title: '欧吼？是有点问题喔:(',
            subtitle: 'flutter_ecosed',
          ),
        ),



        // Stepper(
        //   currentStep: currentStep,
        //   onStepContinue: () {
        //     setState(() {
        //       currentStep = min(2, currentStep + 1);
        //     });
        //   },
        //   onStepCancel: () {
        //     setState(() {
        //       currentStep = max(0, currentStep - 1);
        //     });
        //   },
        //   onStepTapped: (index) {
        //     setState(() {
        //       currentStep = index;
        //     });
        //   },
        //   steps: [
        //     Step(
        //       title: Text('安装并激活Shizuku'),
        //       content: MaterialButton(
        //         onPressed: () {},
        //         child: Text('安装'),
        //       ),
        //     ),
        //     Step(
        //       title: Text('授予Shizuku权限'),
        //       content: MaterialButton(
        //         onPressed: () {},
        //         child: Text('安装'),
        //       ),
        //     ),
        //     Step(
        //       title: Text('安装或启用谷歌基础服务'),
        //       content: MaterialButton(
        //         onPressed: () {},
        //         child: Text('安装'),
        //       ),
        //       isActive: true
        //     ),
        //   ],
        // ),




        // Visibility(
        //   visible: true,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        //     child: WarningCard(
        //       title: 'Shizuku版本过低或未安装',
        //       actions: [
        //         TextButton(onPressed: (){}, child: Text('安装'))
        //       ],
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: true,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        //     child: WarningCard(
        //       title: '未授予Shizuku权限',
        //       actions: [
        //         TextButton(onPressed: () {}, child: Text('申请权限'))
        //       ],
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: true,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        //     child: WarningCard(
        //       title: '您的设备不支持谷歌基础服务',
        //       actions: [
        //         TextButton(onPressed: () {}, child: Text('申请权限')),
        //         TextButton(onPressed: () {}, child: Text('安装'))
        //       ],
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: InfoCard(),
        )
      ],
    );
  }
}
