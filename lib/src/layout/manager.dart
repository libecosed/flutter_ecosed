import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/layout/overview.dart';
import 'package:flutter_ecosed/src/layout/plugin.dart';

import '../plugin/plugin_person.dart';

class Manager extends StatelessWidget {
  const Manager({super.key, required this.pluginPersonList});

  final List<PluginPerson> pluginPersonList;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Overview(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(),
          ),
          Plugin(pluginPersonList: pluginPersonList)
        ],
      ),
    );
  }
}
