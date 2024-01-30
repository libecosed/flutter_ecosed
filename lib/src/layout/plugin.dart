import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';
import '../widget/plugin_item.dart';

class Plugin extends StatelessWidget {
  const Plugin({super.key, required this.pluginDetailsList});

  final List<PluginDetails> pluginDetailsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Column(
        children: pluginDetailsList
            .map((element) => PluginItem(details: element))
            .toList(),
      ),
    );
  }
}
