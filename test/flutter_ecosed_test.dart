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
  Future<List?> getKernelModuleList() => Future.value(List.empty());

  @override
  Future<bool?> openPlatformDialog() => Future.value(true);

  @override
  Future<bool?> closePlatformDialog() => Future.value(true);
}

void main() {
  final EcosedPlatformInterface initialPlatform =
      EcosedPlatformInterface.instance;

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
