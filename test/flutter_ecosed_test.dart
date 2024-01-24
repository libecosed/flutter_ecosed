import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEcosedPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List?> getPluginList() {
    return Future.value([]);
  }
}

void main() {
  final FlutterEcosedPlatform initialPlatform = FlutterEcosedPlatform.instance;

  test('$MethodChannelFlutterEcosed is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEcosed>());
  });

  test('getPlatformVersion', () async {
    FlutterEcosed flutterEcosedPlugin = FlutterEcosed();
    MockFlutterEcosedPlatform fakePlatform = MockFlutterEcosedPlatform();
    FlutterEcosedPlatform.instance = fakePlatform;

    expect(await flutterEcosedPlugin.getPlatformVersion(), '42');
  });
}
