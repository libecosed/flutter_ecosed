import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../event/event_buffer.dart';
import '../event/output_event.dart';
import '../type/logger_listener.dart';
import 'log_record.dart';

final class Log {
  /// 初始化日志
  static void init() {
    Logger.root.level = Level.ALL;
    if (kDebugMode) {
      Log.registerListener(
        (record) => log(
          record.printable(),
          stackTrace: record.stackTrace,
        ),
      );
    }
    Log.registerListener(
      (record) {
        while (EventBuffer.outputEventBuffer.length >= 1000) {
          EventBuffer.outputEventBuffer.removeFirst();
        }
        EventBuffer.outputEventBuffer.add(
          OutputEvent(
            record.level,
            [record.printable()],
          ),
        );
      },
    );
  }

  /// Debug级别
  static void d({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.CONFIG,
      message: message,
    );
  }

  /// Info级别
  static void i({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.INFO,
      message: message,
    );
  }

  /// Warning级别
  static void w({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.WARNING,
      message: message,
    );
  }

  /// Error级别
  static void e({
    required String tag,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _printLog(
      tag: tag,
      level: Level.SEVERE,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 打印日志
  static void _printLog({
    required String tag,
    required Level level,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return Logger(tag).log(
      level,
      message,
      error,
      stackTrace,
      null,
    );
  }

  static void registerListener(LoggerListener onRecord) {
    Logger.root.onRecord
        .map((e) => LoggerRecord.fromLogger(e))
        .listen(onRecord);
  }

  static void clearListeners() {
    Logger.root.clearListeners();
  }
}
