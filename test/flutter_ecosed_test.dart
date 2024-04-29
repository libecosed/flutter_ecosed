import 'package:flutter_ecosed/src/platform/ecosed_platform_interface.dart';
import 'package:flutter_ecosed/src/platform/flutter_ecosed_platform.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedPlatformInterface {
  @override
  Future<List?> getPlatformPluginList() => Future.value(List.empty());

  @override
  Future<void> openPlatformDialog() => Future.value(null);

  @override
  Future<void> closePlatformDialog() => Future.value(null);
}

void main() {
  final EcosedPlatformInterface initialPlatform = EcosedPlatformInterface.instance;

  test('$FlutterEcosedPlatform is the default instance', () {
    expect(initialPlatform, isInstanceOf<FlutterEcosedPlatform>());
  });

  test('getPlatformPluginList', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    EcosedPlatformInterface.instance = fakePlatform;
    expect(await EcosedPlatformInterface.instance.getPlatformPluginList(),
        List.empty());
  });

  test('openPlatformDialog', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    EcosedPlatformInterface.instance = fakePlatform;
    expect(EcosedPlatformInterface.instance.openPlatformDialog(), null);
  });

  test('closePlatformDialog', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    EcosedPlatformInterface.instance = fakePlatform;
    expect(EcosedPlatformInterface.instance.closePlatformDialog(), null);
  });
}
