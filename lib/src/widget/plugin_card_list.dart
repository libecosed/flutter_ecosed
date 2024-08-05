import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';
import 'plugin_card.dart';

class PluginCardList extends StatelessWidget {
  const PluginCardList({
    super.key,
    required this.pluginDetailsList,
    required this.appName,
    required this.appVersion,
  });

  final List<PluginDetails> pluginDetailsList;
  final String appName;
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: pluginDetailsList
          .map(
            (element) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Builder(
                builder: (context) => PluginCard(
                  details: element,
                  appName: appName,
                  appVersion: appVersion,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
