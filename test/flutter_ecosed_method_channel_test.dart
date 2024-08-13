import 'package:flutter/services.dart';
import 'package:flutter_ecosed/src/platform/ecosed_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEcosed platform = MethodChannelEcosed();
  const MethodChannel channel = MethodChannel('flutter_ecosed');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlugins':
            return List.empty();
          case 'openDialog':
            return true;
          case 'closeDialog':
            return true;
          default:
            return await null;
        }
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
    expect(await platform.openPlatformDialog(), true);
  });

  test('closePlatformDialog', () async {
    expect(await platform.closePlatformDialog(), true);
  });
}
