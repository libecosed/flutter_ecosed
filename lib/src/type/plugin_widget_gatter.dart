import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';

typedef PluginWidgetGetter = Widget Function(
  BuildContext context,
  PluginDetails details,
);
