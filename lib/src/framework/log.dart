import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import '../event/output_event.dart';
import '../type/logger_listener.dart';
import '../widget/log_page.dart';

/// Contains all the information about the [LogRecord]
/// and can be printed with [printable] based on [FloggerConfig]
class FloggerRecord {
  /// Original [LogRecord] from [Logger]
  final LogRecord logRecord;

  /// [Logger] name
  final String loggerName;

  /// Log severity
  final Level level;

  /// Log message
  final String message;

  /// Log time
  final DateTime? time;

  /// [Error] stacktrace
  final StackTrace? stackTrace;

  /// Class name where the log was triggered
  final String? className;

  /// Method name where the log was triggered
  final String? methodName;

  FloggerRecord._(
    this.logRecord,
    this.loggerName,
    this.message,
    this.level,
    this.time,
    this.stackTrace,
    this.className,
    this.methodName,
  );

  /// Create a [FloggerRecord] from a [LogRecord]
  factory FloggerRecord.fromLogger(LogRecord record) {
    // Get ClassName and MethodName
    final classAndMethodNames = _getClassAndMethodNames(_getLogFrame()!);
    String? className = classAndMethodNames.key;
    String? methodName = classAndMethodNames.value;
    // Get stacktrace from record stackTrace or record object
    StackTrace? stackTrace = record.stackTrace;
    if (record.stackTrace == null && record.object is Error) {
      stackTrace = (record.object as Error).stackTrace;
    }
    // Get message
    var message = record.message;
    // Maybe add object
    if (record.object != null) message += " - ${record.object}";
    // Build Flogger record
    return FloggerRecord._(
      record,
      record.loggerName,
      message,
      record.level,
      record.time,
      stackTrace,
      className,
      methodName,
    );
  }

  /// Convert the log to a printable [String]
  String printable() {
    var printedMessage = "";
    if (time != null) {
      printedMessage += "[${time!.toIso8601String()}] ";
    }
    printedMessage += "${_levelShort(level)}/";
    printedMessage += loggerName;
    if (className != null) {
      if (methodName != null) {
        printedMessage += " $className#$methodName: ";
      } else {
        printedMessage += " $className: ";
      }
    } else if (methodName != null) {
      printedMessage += " $methodName: ";
    } else {
      printedMessage += ": ";
    }
    printedMessage += message;
    return printedMessage;
  }

  static String _levelShort(Level level) {
    if (level == Level.CONFIG) {
      return "D";
    } else if (level == Level.INFO) {
      return "I";
    } else if (level == Level.WARNING) {
      return "W";
    } else if (level == Level.SEVERE) {
      return "E";
    } else {
      return "?";
    }
  }

  static Frame? _getLogFrame() {
    try {
      // Capture the frame where the log originated from the current trace
      const loggingLibrary = "package:logging/src/logger.dart";
      const loggingFlutterLibrary =
          "package:flutter_ecosed/src/framework/log.dart";
      final currentFrames = Trace.current().frames.toList();
      // Remove all frames from the logging_flutter library
      currentFrames
          .removeWhere((element) => element.library == loggingFlutterLibrary);
      // Capture the last frame from the logging library
      final lastLoggerIndex = currentFrames
          .lastIndexWhere((element) => element.library == loggingLibrary);
      return currentFrames[lastLoggerIndex + 1];
    } catch (e) {}
    return null;
  }

  static MapEntry<String?, String?> _getClassAndMethodNames(Frame frame) {
    String? className;
    String? methodName;
    try {
      // This variable can be ClassName.MethodName or only a function name, when it doesn't belong to a class, e.g. main()
      final member = frame.member!;
      // If there is a . in the member name, it means the method belongs to a class. Thus we can split it.
      if (member.contains(".")) {
        className = member.split(".")[0];
      } else {
        className = "";
      }
      // If there is a . in the member name, it means the method belongs to a class. Thus we can split it.
      if (member.contains(".")) {
        methodName = member.split(".")[1];
      } else {
        methodName = member;
      }
    } catch (e) {}
    return MapEntry(className, methodName);
  }
}

class FullLogs {
  StringBuffer fullLogs = StringBuffer('Start: ');
}

extension LevelExtension on Level {
  Color toColor(bool dark) {
    if (this == Level.CONFIG) {
      return dark ? Colors.white38 : Colors.black38;
    } else if (this == Level.INFO) {
      return dark ? Colors.white : Colors.black;
    } else if (this == Level.WARNING) {
      return Colors.orange;
    } else if (this == Level.SEVERE) {
      return Colors.red;
    } else if (this == Level.SHOUT) {
      return Colors.pinkAccent;
    } else {
      return dark ? Colors.white : Colors.black;
    }
  }
}

final class Log {
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

  /// Register a listener to listen to all logs
  /// Logs are emitted as [FloggerRecord]
  static void registerListener(LoggerListener onRecord) {
    Logger.root.onRecord
        .map((e) => FloggerRecord.fromLogger(e))
        .listen(onRecord);
  }

  /// Clear all log listeners
  static void clearListeners() {
    Logger.root.clearListeners();
  }
}
