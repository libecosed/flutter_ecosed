import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/interface/ecosed_interface.dart';
import 'package:flutter_ecosed/src/plugin/plugin_runtime.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';
import 'package:flutter_ecosed/src/type/runner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedInterface {
  @override
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
  ) async {}
}

void main() {
  final EcosedInterface initialPlatform = EcosedInterface.instance;

  test('$EcosedRuntime is the default instance', () {
    expect(initialPlatform, isInstanceOf<EcosedRuntime>());
  });

  test('runEcosedApp', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    EcosedInterface.instance = fakePlatform;
    expect(
      EcosedInterface.instance.runEcosedApp(
        (app) async => runApp(app),
        () => const <EcosedRuntimePlugin>[],
        (context, open, exec) => const Placeholder(),
      ),
      Future.value(),
    );
  });
}
