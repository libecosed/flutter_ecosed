import 'package:flutter/material.dart';

typedef EcosedExec = Object? Function(String channel, String method);
typedef EcosedHome = Widget Function(Widget view, EcosedExec exec);