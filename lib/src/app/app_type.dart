import 'package:flutter/material.dart';

typedef EcosedExec = Object? Function(String channel, String method);
typedef EcosedApps = Widget Function(EcosedExec exec, Widget body);
typedef EcosedScaffold = Scaffold Function(Widget body);
