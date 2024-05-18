import 'package:flutter/material.dart';

typedef EcosedExec = Future<dynamic> Function(String channel, String method);
typedef EcosedHome = Widget Function(BuildContext context, Widget manager);
typedef EcosedScaffold = Scaffold Function(Widget body, String title);
typedef EcosedApps = MaterialApp Function(Widget home, String title);
