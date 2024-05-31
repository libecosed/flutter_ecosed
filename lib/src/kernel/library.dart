import 'dart:ffi';
import 'dart:io';

import 'binding.g.dart';

final class KernelLib {
  /// 绑定
  static late EcosedKernelBindings _bindings;

  /// 获取绑定
  static EcosedKernelBindings get bindings => _bindings;

  static void bindingInitialized() {
    _bindings = EcosedKernelBindings(_dynamicLibrary);
  }

  static const String _libName = 'flutter_ecosed';

  static final DynamicLibrary _dynamicLibrary = () {
    if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('$_libName.framework/$_libName');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('$_libName.dll');
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }();
}
