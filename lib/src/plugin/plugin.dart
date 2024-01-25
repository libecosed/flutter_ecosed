import 'package:flutter/material.dart';

abstract class EcosedPlugin extends StatefulWidget {
  const EcosedPlugin({super.key});

  String pluginName();

  Widget pluginWidget() => this;
}
