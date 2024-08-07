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
    Widget app,
    List<EcosedRuntimePlugin> plugins,
    Runner runner,
  ) async {}

  @override
  Future<void> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    throw UnimplementedError();
  }

  @override
  Future<void> openDebugMenu() {
    throw UnimplementedError();
  }
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
        Container(),
        const <EcosedRuntimePlugin>[],
        (app) async => runApp(app),
      ),
      Future.value(),
    );
  });
}
