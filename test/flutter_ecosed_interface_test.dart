import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/entry/default_entry.dart';
import 'package:flutter_ecosed/src/interface/ecosed_interface.dart';
import 'package:flutter_ecosed/src/type/runner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedInterface
    with MockPlatformInterfaceMixin
    implements EcosedInterface {
  bool isInitialized = false;

  @override
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    isInitialized = true;
  }
}

void main() {
  final EcosedInterface initialInterface = EcosedInterface.instance;

  test('$DefaultEntry 是默认实例.', () {
    expect(initialInterface, isInstanceOf<DefaultEntry>());
  });

  test('runEcosedApp', () async {
    MockFlutterEcosedInterface fakePlatform = MockFlutterEcosedInterface();
    EcosedInterface.instance = fakePlatform;
    await EcosedInterface.instance.runEcosedApp(
      (_) async => {},
      () => const [],
      (_, __, ___) => const Placeholder(),
      null,
    );
    expect(fakePlatform.isInitialized, true);
  });
}
