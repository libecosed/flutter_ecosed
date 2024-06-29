import 'package:flutter/material.dart';
import 'package:flutter_ecosed/src/platform/interface.dart';
import 'package:flutter_ecosed/src/plugin/plugin.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedPlatformInterface {
  @override
  Future<void> runEcosedApp({
    required WidgetBuilder app,
    required List<EcosedPlugin> plugins,
    required Future<void> Function(Widget app) runner,
  }) async {}

  @override
  Future<void> execPluginMethod(
    BuildContext context,
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    throw UnimplementedError();
  }

  @override
  Widget getManagerWidget(BuildContext context) {
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
        app: (context) => Container(),
        plugins: const <EcosedPlugin>[],
        runner: (app) async => runApp(app),
      ),
      Future.value(),
    );
  });
}
