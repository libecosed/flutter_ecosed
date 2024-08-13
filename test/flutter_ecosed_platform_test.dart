import 'package:flutter_ecosed/src/interface/ecosed_platform.dart';
import 'package:flutter_ecosed/src/platform/ecosed.dart';
import 'package:flutter_ecosed/src/platform/ecosed_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEcosedPlatform
    with MockPlatformInterfaceMixin
    implements EcosedPlatform {
  @override
  Future<List?> getPlatformPluginList() async => List.empty();
  @override
  Future<bool?> openPlatformDialog() async => true;
  @override
  Future<bool?> closePlatformDialog() async => true;
}

void main() {
  final EcosedPlatform initialPlatform = EcosedPlatform.instance;

  test('$MethodChannelEcosed 是默认实例.', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEcosed>());
  });

  test('getPlatformPluginList', () async {
    FlutterEcosed ecosedPlugin = FlutterEcosed();
    EcosedPlatform.instance = MockFlutterEcosedPlatform();
    expect(await ecosedPlugin.getPlatformPluginList(), List.empty());
  });

  test('openPlatformDialog', () async {
    FlutterEcosed ecosedPlugin = FlutterEcosed();
    EcosedPlatform.instance = MockFlutterEcosedPlatform();
    expect(await ecosedPlugin.openPlatformDialog(), true);
  });

  test('closePlatformDialog', () async {
    FlutterEcosed ecosedPlugin = FlutterEcosed();
    EcosedPlatform.instance = MockFlutterEcosedPlatform();
    expect(await ecosedPlugin.closePlatformDialog(), true);
  });
}
