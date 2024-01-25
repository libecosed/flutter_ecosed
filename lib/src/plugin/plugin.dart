import 'package:flutter/material.dart';

abstract class EcosedPlugin extends StatefulWidget {
  const EcosedPlugin({super.key});

  String pluginChannel();
  String pluginName();
  String pluginDescription();
  String pluginAuthor();

  Widget pluginWidget() => this;
}
