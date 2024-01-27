import 'package:flutter/material.dart';

typedef EcosedExec = Object? Function(String channel, String method);
typedef EcosedApps = Widget Function(Widget view, EcosedExec exec);