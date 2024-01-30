import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import '../plugin/plugin_details.dart';
import '../widget/plugin_item.dart';

class Plugin extends StatelessWidget {
  const Plugin(
      {super.key, required this.pluginDetailsList, required this.pluginList});

  final List<PluginDetails> pluginDetailsList;
  final List<EcosedPlugin> pluginList;

  EcosedPlugin? plugin(PluginDetails details) {
    if (pluginList.isNotEmpty) {
      for (var element in pluginList) {
        if (element.pluginChannel() == details.channel) {
          return element;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Column(
        children: pluginDetailsList
            .map((element) => PluginItem(
                  details: element,
                  plugin: plugin(element),
                ))
            .toList(),
      ),
    );
  }
}
