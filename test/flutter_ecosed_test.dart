import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/platform/platform_interface.dart';
import 'package:flutter_ecosed/src/plugin/plugin_base.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedPlatformInterface {
  @override
  Future<void> runEcosedApp({
    required Widget app,
    required List<BaseEcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {}

  @override
  Future<void> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    throw UnimplementedError();
  }

  @override
  Widget getManagerWidget() {
    throw UnimplementedError();
  }
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
        app: Container(),
        plugins: const <BaseEcosedPlugin>[],
        runner: (app) async => runApp(app),
      ),
      Future.value(),
    );
  });
}
