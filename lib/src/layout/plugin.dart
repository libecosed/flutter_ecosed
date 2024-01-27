import 'package:flutter/material.dart';

import '../plugin/plugin_person.dart';
import '../widget/plugin_item.dart';

class Plugin extends StatelessWidget {
  const Plugin({super.key, required this.pluginPersonList});

  final List<PluginPerson> pluginPersonList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: pluginPersonList
            .map((element) => PluginItem(person: element))
            .toList(),
      ),
    );
  }
}
