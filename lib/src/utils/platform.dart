import 'dart:io';

bool get kUseNative => Platform.isAndroid || Platform.isIOS;

bool get kIsDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

bool get kIsMobile => Platform.isAndroid || Platform.isIOS;
