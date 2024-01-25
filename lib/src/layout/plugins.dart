import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../platform/flutter_ecosed.dart';
import '../widget/module.dart';

class PluginPage extends StatefulWidget {
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage> {
  List _pluginList = [
    '{"channel":"unknown","title":"unknown","description":"unknown","author":"unknown","version":"unknown"}'
  ];
  final _ecosedNative = const FlutterEcosed();

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
    return Column(
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

class PluginPerson {
  String channel;
  String title;
  String description;
  String author;
  String version;

  PluginPerson(
      {required this.channel,
      required this.title,
      required this.description,
      required this.author,
      required this.version});

  factory PluginPerson.fromJson(Map<String, dynamic> json) {
    return PluginPerson(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        version: json['version']);
  }
}
