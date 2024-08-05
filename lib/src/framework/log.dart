import 'package:flutter/foundation.dart';

class Log {
  /// Info级别
  static void i(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// Debug级别
  static void d(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// Error级别
  static void e(String tag, String message, dynamic exceptino) {
    _printLog(tag, message, exceptino, true);
  }

  /// Verbose级别
  static void v(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// Warring级别
  static void w(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// 打印日志
  static void _printLog(
    String tag,
    String message,
    dynamic exceptino,
    bool hasException,
  ) {
    if (hasException) {
      debugPrint('tag: $tag - message: $message - exceptino:\n$exceptino');
    } else {
      debugPrint('tag: $tag - message: $message');
    }
  }
}
