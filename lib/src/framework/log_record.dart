import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

/// Contains all the information about the [LogRecord]
/// and can be printed with [printable] based on [LoggerRecord]
class LoggerRecord {
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

  LoggerRecord._(
    this.logRecord,
    this.loggerName,
    this.message,
    this.level,
    this.time,
    this.stackTrace,
    this.className,
    this.methodName,
  );

  /// Create a [LoggerRecord] from a [LogRecord]
  factory LoggerRecord.fromLogger(LogRecord record) {
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
    // Build Logger record
    return LoggerRecord._(
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
      const loggingLibrary = "package:logging/src/logger.dart";
      const ecosedLibrary = "package:flutter_ecosed/flutter_ecosed.dart";
      final currentFrames = Trace.current().frames.toList();
      currentFrames.removeWhere((element) => element.library == ecosedLibrary);
      // Capture the last frame from the logging library
      final lastLoggerIndex = currentFrames.lastIndexWhere(
        (element) => element.library == loggingLibrary,
      );
      return currentFrames[lastLoggerIndex + 1];
    } catch (e) {
      return null;
    }
  }

  static MapEntry<String?, String?> _getClassAndMethodNames(Frame frame) {
    String? className;
    String? methodName;
    try {
      final member = frame.member!;
      if (member.contains(".")) {
        className = member.split(".")[0];
      } else {
        className = "";
      }
      if (member.contains(".")) {
        methodName = member.split(".")[1];
      } else {
        methodName = member;
      }
    } catch (e) {
      return MapEntry(className, methodName);
    }
    return MapEntry(className, methodName);
  }
}
