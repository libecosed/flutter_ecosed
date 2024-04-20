import 'package:flutter/services.dart';
import 'package:flutter_ecosed/src/platform/method_channel_flutter_ecosed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterEcosed platform = MethodChannelFlutterEcosed();
  const MethodChannel channel = MethodChannel('flutter_ecosed');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return List.empty();
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformPluginList', () async {
    expect(await platform.getPlatformPluginList(), List.empty());
  });

  test('openPlatformDialog', () async {
    expect(platform.openPlatformDialog(), null);
  });

  test('closePlatformDialog', () async {
    expect(platform.closePlatformDialog(), null);
  });
}
