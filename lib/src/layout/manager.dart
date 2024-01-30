import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import '../plugin/plugin_details.dart';
import 'overview.dart';
import 'plugin.dart';

typedef PushPlugin = void Function(BuildContext context, String channel);

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
