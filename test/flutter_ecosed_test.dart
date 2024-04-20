import 'package:flutter_ecosed/src/platform/flutter_ecosed_platform.dart';
import 'package:flutter_ecosed/src/platform/method_channel_flutter_ecosed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEcosedPlatform {
  @override
  Future<List?> getPlatformPluginList() => Future.value(List.empty());

  @override
  Future<void> openPlatformDialog() => Future.value(null);

  @override
  Future<void> closePlatformDialog() => Future.value(null);
}

void main() {
  final FlutterEcosedPlatform initialPlatform = FlutterEcosedPlatform.instance;

  test('$MethodChannelFlutterEcosed is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEcosed>());
  });

  test('getPlatformPluginList', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    FlutterEcosedPlatform.instance = fakePlatform;
    expect(await FlutterEcosedPlatform.instance.getPlatformPluginList(),
        List.empty());
  });

  test('openPlatformDialog', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    FlutterEcosedPlatform.instance = fakePlatform;
    expect(FlutterEcosedPlatform.instance.openPlatformDialog(), null);
  });

  test('closePlatformDialog', () async {
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    FlutterEcosedPlatform.instance = fakePlatform;
    expect(FlutterEcosedPlatform.instance.closePlatformDialog(), null);
  });
}
