import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';
import 'overview.dart';
import 'plugin.dart';

class Manager extends StatelessWidget {
  const Manager({super.key, required this.pluginDetailsList});

  final List<PluginDetails> pluginDetailsList;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          const Overview(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(),
          ),
          Plugin(pluginDetailsList: pluginDetailsList),
        ],
      ),
    );
  }
}
