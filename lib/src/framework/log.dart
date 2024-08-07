import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../event/output_event.dart';
import '../type/logger_listener.dart';
import '../widget/log_page.dart';
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
      (record) => LogPage.add(
        outputEvent: OutputEvent(
          record.level,
          [record.printable()],
        ),
        bufferSize: 1000,
      ),
    );
  }

  /// Debug级别
  static void d({
    required String tag,
    required String message,
  }) {
    _printLog(
      message: message,
      loggerName: tag,
      severity: Level.CONFIG,
    );
  }

  /// Info级别
  static void i({
    required String message,
    required String tag,
  }) {
    _printLog(
      message: message,
      loggerName: tag,
      severity: Level.INFO,
    );
  }

  /// Warning级别
  static void w({
    required String message,
    required String tag,
  }) {
    _printLog(
      message: message,
      loggerName: tag,
      severity: Level.WARNING,
    );
  }

  /// Error级别
  static void e({
    required String message,
    required String tag,
    StackTrace? stackTrace,
  }) {
    _printLog(
      message: message,
      loggerName: tag,
      severity: Level.SEVERE,
      stackTrace: stackTrace,
    );
  }

  /// 打印日志
  static void _printLog({
    required String message,
    required String loggerName,
    required Level severity,
    StackTrace? stackTrace,
  }) {
    Logger(loggerName).log(
      severity,
      message,
      null,
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
