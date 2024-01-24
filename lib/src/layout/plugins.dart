import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_ecosed/src/json.dart';

import '../widget/module.dart';

class PluginPage extends StatefulWidget {
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage> {
  List _pluginList = ['{"unknown":"unknown"}'];
  final _ecosedNative = FlutterEcosed();

  @override
  void initState() {
    super.initState();
    initPluginsState();
  }

  Future<void> initPluginsState() async {
    List pluginList;
    try {
      pluginList = await _ecosedNative.getPluginList() ?? ['Unknown plugins'];
    } on PlatformException {
      pluginList = ['Failed to get plugin list.'];
    }
    if (!mounted) return;
    setState(() {
      _pluginList = pluginList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: _pluginList
            .map((e) => Plugin(
                  title: PluginPerson.fromJson(jsonDecode(e)).title,
                  version: PluginPerson.fromJson(jsonDecode(e)).version,
                  author: PluginPerson.fromJson(jsonDecode(e)).author,
                  description: PluginPerson.fromJson(jsonDecode(e)).description,
                ))
            .toList());
  }
}
