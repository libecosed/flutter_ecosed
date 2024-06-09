import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/platform/platform_interface.dart';
import 'package:flutter_ecosed/src/plugin/plugin.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedPlatformInterface {
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {}
}

void main() {
  final EcosedPlatformInterface initialPlatform =
      EcosedPlatformInterface.instance;

  test('$EcosedRuntime is the default instance', () {
    expect(initialPlatform, isInstanceOf<EcosedRuntime>());
  });

  test('runEcosedApp', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    EcosedPlatformInterface.instance = fakePlatform;
    expect(
      EcosedPlatformInterface.instance.runEcosedApp(
        app: (context) => Container(),
        plugins: const <EcosedPlugin>[],
        runner: (app) async => runApp(app),
      ),
      Future.value(),
    );
  });
}
