import 'dart:io';

import 'package:win32/win32.dart';

import '../bridge/native_bridge.dart';
import 'ecosed_platform_interface.dart';

final class FlutterEcosedPlatform extends EcosedPlatformInterface {
  /// 方法通道平台代码调用Android平台独占
  final NativeBridge _bridge = const NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPlatformPluginList() async {
    return await _withPlatform(
      android: () async => await _bridge.getPlatformPluginList(),
      fuchsia: () async => List.empty(),
      iOS: () async => List.empty(),
      linux: () async => List.empty(),
      macOS: () async => List.empty(),
      windows: () async => List.empty(),
    );
  }

  /// 从客户端启动对话框
  @override
  Future<void> openPlatformDialog() async {
    return await _withPlatform(
      android: () async => await _bridge.openPlatformDialog(),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async {
        final result = MessageBox(
            NULL,
            TEXT('Hello World!'),
            TEXT('Dart MessageBox Test'),
            MESSAGEBOX_STYLE.MB_ICONWARNING | // Warning
                MESSAGEBOX_STYLE.MB_CANCELTRYCONTINUE | // Action button
                MESSAGEBOX_STYLE.MB_DEFBUTTON2 // Second button is the default
            );

        switch (result) {
          case MESSAGEBOX_RESULT.IDCANCEL:
          case MESSAGEBOX_RESULT.IDTRYAGAIN:
          case MESSAGEBOX_RESULT.IDCONTINUE:
        }
        return await null;
      },
    );
  }

  @override
  Future<void> closePlatformDialog() async {
    return await _withPlatform(
      android: () async => await _bridge.closePlatformDialog(),
      fuchsia: () async => await null,
      iOS: () async => await null,
      linux: () async => await null,
      macOS: () async => await null,
      windows: () async => await null,
    );
  }

  Future<dynamic> _withPlatform({
    required Future<dynamic> Function() android,
    required Future<dynamic> Function() fuchsia,
    required Future<dynamic> Function() iOS,
    required Future<dynamic> Function() linux,
    required Future<dynamic> Function() macOS,
    required Future<dynamic> Function() windows,
  }) async {
    if (Platform.isAndroid) {
      return await android.call();
    } else if (Platform.isFuchsia) {
      return await fuchsia.call();
    } else if (Platform.isIOS) {
      return await iOS.call();
    } else if (Platform.isLinux) {
      return await linux.call();
    } else if (Platform.isMacOS) {
      return await macOS.call();
    } else if (Platform.isWindows) {
      return await windows.call();
    } else {
      return await null;
    }
  }

  bool _isMobil() {
    return Platform.isAndroid || Platform.isFuchsia || Platform.isIOS;
  }

  bool _isDesktop() {
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }
}
