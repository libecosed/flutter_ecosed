import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

extension LevelExtension on Level {
  Color toColor(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (this == Level.CONFIG) {
      return dark ? Colors.white38 : Colors.black38;
    } else if (this == Level.INFO) {
      return dark ? Colors.white : Colors.black;
    } else if (this == Level.WARNING) {
      return Colors.orange;
    } else if (this == Level.SEVERE) {
      return Colors.red;
    } else if (this == Level.SHOUT) {
      return Colors.pinkAccent;
    } else {
      return dark ? Colors.white : Colors.black;
    }
  }
}
