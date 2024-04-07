import 'package:flutter/material.dart';

typedef EcosedExec = Future<Object?> Function(String channel, String method);
typedef EcosedHome = Widget Function(
    BuildContext context, EcosedExec exec, Widget body);
typedef EcosedScaffold = Scaffold Function(Widget body, String title);
typedef EcosedApps = MaterialApp Function(Widget home, String title);
