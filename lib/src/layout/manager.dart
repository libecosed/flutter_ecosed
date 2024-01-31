import 'package:flutter/material.dart';

import '../app.dart';
import 'overview.dart';
import 'plugin.dart';

class Manager extends StatelessWidget {
  const Manager(
      {super.key,
      required this.pluginDetailsList,
      required this.appName,
      required this.pluginList});

  final String appName;
  final List<PluginDetails> pluginDetailsList;
  final List<EcosedPlugin> pluginList;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Overview(
            appName: appName,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(),
          ),
          Plugin(
            pluginDetailsList: pluginDetailsList,
            pluginList: pluginList,
          ),
        ],
      ),
    );
  }
}
