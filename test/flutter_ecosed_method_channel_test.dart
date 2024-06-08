import 'package:flutter/services.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  EcosedRuntime runtime = EcosedRuntime();
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
    expect(await runtime.getPlatformPluginList(), List.empty());
  });

  test('openPlatformDialog', () async {
    expect(runtime.openPlatformDialog(), null);
  });

  test('closePlatformDialog', () async {
    expect(runtime.closePlatformDialog(), null);
  });
}
