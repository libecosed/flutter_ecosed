import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart';

import '../bridge/native_bridge.dart';
import 'ecosed_platform_interface.dart';

final class FlutterEcosedPlatform extends EcosedPlatformInterface {
  FlutterEcosedPlatform() {}

  /// 方法通道平台代码调用Android平台独占
  final NativeBridge _bridge = const NativeBridge();

  /// 从引擎获取原生插件JSON
  @override
  Future<List?> getPlatformPluginList() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.getPlatformPluginList();
      case TargetPlatform.fuchsia:
        return List.empty();
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        final message = TEXT(
            'This is not really an error, but we are pretending for the sake '
            'of this test.\n\nResource error.\nDo you want to try again?');
        final title = TEXT('Dart MessageBox Test');

        final result = MessageBox(
            NULL,
            message,
            title,
            MESSAGEBOX_STYLE.MB_ICONWARNING | // Warning
                MESSAGEBOX_STYLE.MB_CANCELTRYCONTINUE | // Action button
                MESSAGEBOX_STYLE.MB_DEFBUTTON2 // Second button is the default
            );

        free(message);
        free(title);

        switch (result) {
          case MESSAGEBOX_RESULT.IDCANCEL:
            print('Cancel pressed');
          case MESSAGEBOX_RESULT.IDTRYAGAIN:
            print('Try Again pressed');
          case MESSAGEBOX_RESULT.IDCONTINUE:
            print('Continue pressed');
        }
      default:
        return List.empty();
    }
  }

  /// 从客户端启动对话框
  @override
  Future<void> openPlatformDialog() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.openPlatformDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        return await null;
    }
  }

  @override
  Future<void> closePlatformDialog() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _bridge.closePlatformDialog();
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        return await null;
    }
  }
}
