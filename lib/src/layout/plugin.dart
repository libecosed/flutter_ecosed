import 'package:flutter/material.dart';

import '../../flutter_ecosed.dart';
import '../plugin/plugin_details.dart';
import '../widget/plugin_item.dart';
import 'manager.dart';

class Plugin extends StatelessWidget {
  const Plugin({super.key, required this.pluginDetailsList, required this.thirdPluginList});

  final List<PluginDetails> pluginDetailsList;
  final List<EcosedPlugin> thirdPluginList;

  EcosedPlugin? third(PluginDetails details) {
    if (thirdPluginList.isNotEmpty) {
      for (var element in thirdPluginList) {
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
            .map((element) => PluginItem(details: element, thirdPlugin: third(element),))
            .toList(),
      ),
    );
  }
}
