import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import '../type/logger_listener.dart';
import '../type/logger_printer.dart';

/// Contains all the information about the [LogRecord]
/// and can be printed with [printable] based on [FloggerConfig]
class FloggerRecord {
  /// Original [LogRecord] from [Logger]
  final LogRecord logRecord;

  /// Print configuration
  final FloggerConfig config;

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
    this.config,
    this.loggerName,
    this.message,
    this.level,
    this.time,
    this.stackTrace,
    this.className,
    this.methodName,
  );

  /// Create a [FloggerRecord] from a [LogRecord]
  factory FloggerRecord.fromLogger(
    LogRecord record,
    FloggerConfig config,
  ) {
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
      config,
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
    if (config.printer != null) return config.printer!(this);
    var printedMessage = "";
    if (config.showDateTime && time != null) {
      printedMessage += "[${time!.toIso8601String()}] ";
    }
    printedMessage += "${_levelShort(level)}/";
    printedMessage += loggerName;
    if (className != null && config.printClassName) {
      if (methodName != null && config.printMethodName) {
        printedMessage += " $className#$methodName: ";
      } else {
        printedMessage += " $className: ";
      }
    } else if (methodName != null && config.printMethodName) {
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
      const loggingFlutterLibrary = "package:logging_flutter/src/flogger.dart";
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

/// Convenience singleton with static methods to
/// interact with [Logger]
/// Logs can be configured with [FloggerConfig]
/// Logs can be listened to with [FloggerListener]
abstract class Flogger {
  static FloggerConfig _config = const FloggerConfig();

  /// Initialize the default [Logger] and set the [FloggerConfig]
  static void init({FloggerConfig config = const FloggerConfig()}) {
    _config = config;
    Logger.root.level = _config.showDebugLogs ? Level.ALL : Level.INFO;
  }

  /// Log a DEBUG message with CONFIG [Level]
  static d(String message, {required String loggerName}) => _log(
        message: message,
        loggerName: loggerName,
        severity: Level.CONFIG,
      );

  /// Log an INFO message with INFO [Level]
  static i(String message, {required String loggerName}) => _log(
        message: message,
        loggerName: loggerName,
        severity: Level.INFO,
      );

  /// Log a WARNING message with WARNING [Level]
  static w(String message, {required String loggerName}) => _log(
        message: message,
        loggerName: loggerName,
        severity: Level.WARNING,
      );

  /// Log an ERROR message with SEVERE [Level]
  static e(String message,
          {StackTrace? stackTrace, required String loggerName}) =>
      _log(
        message: message,
        loggerName: loggerName,
        severity: Level.SEVERE,
        stackTrace: stackTrace,
      );

  static void _log({
    required String message,
    required String loggerName,
    required Level severity,
    StackTrace? stackTrace,
  }) {
    // Additional loggers
    Logger(loggerName).log(severity, message, null, stackTrace);
  }

  /// Register a listener to listen to all logs
  /// Logs are emitted as [FloggerRecord]
  static registerListener(LoggerListener onRecord) {
    Logger.root.onRecord
        .map((e) => FloggerRecord.fromLogger(e, _config))
        .listen(onRecord);
  }

  /// Clear all log listeners
  static clearListeners() {
    Logger.root.clearListeners();
  }
}

/// Configuration options for [LogRecord]
class FloggerConfig {
  /// Print the class name where the log was triggered
  final bool printClassName;

  /// Print the method name where the log was triggered
  final bool printMethodName;

  /// Print the date and time when the log occurred
  final bool showDateTime;

  /// Print logs with Debug severity
  final bool showDebugLogs;

  /// Print logs with a custom format
  /// If set, ignores all other print options
  final LoggerPrinter? printer;

  const FloggerConfig({
    this.printClassName = true,
    this.printMethodName = true,
    this.showDateTime = true,
    this.showDebugLogs = true,
    this.printer,
  });
}

class Log extends Flogger {
  /// Info级别
  static void i(
    String tag,
    String message,
  ) {
    Flogger.i(
      message,
      loggerName: tag,
    );
  }

  /// Debug级别
  static void d(
    String tag,
    String message,
  ) {
    Flogger.d(
      message,
      loggerName: tag,
    );
  }

  /// Error级别
  static void e(
    String tag,
    String message,
    dynamic exceptino,
  ) {
    Flogger.e(
      message,
      stackTrace: exceptino,
      loggerName: tag,
    );
  }

  /// Warring级别
  static void w(
    String tag,
    String message,
  ) {
    Flogger.w(
      message,
      loggerName: tag,
    );
  }
}
