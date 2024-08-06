import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:logging/logging.dart";
import 'package:stack_trace/stack_trace.dart';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AnsiParser {
  static const TEXT = 0, BRACKET = 1, CODE = 2;

  final bool dark;

  AnsiParser(this.dark);

  Color? foreground;
  Color? background;
  List<TextSpan>? spans;

  void parse(String s) {
    spans = [];
    var state = TEXT;
    StringBuffer? buffer;
    var text = StringBuffer();
    var code = 0;
    late List<int> codes;

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];

      switch (state) {
        case TEXT:
          if (c == '\u001b') {
            state = BRACKET;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;

        case BRACKET:
          buffer!.write(c);
          if (c == '[') {
            state = CODE;
          } else {
            state = TEXT;
            text.write(buffer);
          }
          break;

        case CODE:
          buffer!.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans!.add(createSpan(text.toString()));
              text.clear();
            }
            state = TEXT;
            if (c == 'm') {
              codes.add(code);
              handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }

          break;
      }
    }

    spans!.add(createSpan(text.toString()));
  }

  void handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = getColor(0, true);
        background = getColor(0, false);
        break;
      case 38:
        foreground = getColor(codes[2], true);
        break;
      case 39:
        foreground = getColor(0, true);
        break;
      case 48:
        background = getColor(codes[2], false);
        break;
      case 49:
        background = getColor(0, false);
    }
  }

  Color? getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12:
        return dark ? Colors.lightBlue[300] : Colors.indigo[700];
      case 208:
        return dark ? Colors.orange[300] : Colors.orange[700];
      case 196:
        return dark ? Colors.red[300] : Colors.red[700];
      case 199:
        return dark ? Colors.pink[300] : Colors.pink[700];
    }
    return foreground ? Colors.black : Colors.transparent;
  }

  TextSpan createSpan(String text) {
    return TextSpan(
        text: text,
        style: TextStyle(
          color: foreground,
          backgroundColor: background,
        ),
        recognizer: LongPressGestureRecognizer()
          ..onLongPress = () {
            // Clipboard.setData(ClipboardData(text: text));
            // Toast.toast("Copy to paste board");
          });
  }
}

typedef FloggerPrinter = String Function(FloggerRecord record);
typedef FloggerListener = void Function(FloggerRecord record);

/// Configuration options for [LogRecord]
class FloggerConfig {
  /// The name for the default Logger
  final String loggerName;

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
  final FloggerPrinter? printer;

  const FloggerConfig({
    this.loggerName = "App",
    this.printClassName = true,
    this.printMethodName = false,
    this.showDateTime = false,
    this.showDebugLogs = true,
    this.printer,
  });
}

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
    if (record.stackTrace == null && record.object is Error)
      stackTrace = (record.object as Error).stackTrace;
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
    printedMessage += "$loggerName";
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
      final loggingLibrary = "package:logging/src/logger.dart";
      final loggingFlutterLibrary = "package:logging_flutter/src/flogger.dart";
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
  static FloggerConfig _config = FloggerConfig();
  static Logger _logger = Logger(_config.loggerName);

  Flogger._();

  /// Initialize the default [Logger] and set the [FloggerConfig]
  static void init({FloggerConfig config = const FloggerConfig()}) {
    _config = config;
    _logger = Logger(_config.loggerName);
    Logger.root.level = _config.showDebugLogs ? Level.ALL : Level.INFO;
  }

  /// Log a DEBUG message with CONFIG [Level]
  static d(String message, {String? loggerName}) => _log(
        message,
        loggerName: loggerName,
        severity: Level.CONFIG,
      );

  /// Log an INFO message with INFO [Level]
  static i(String message, {String? loggerName}) => _log(
        message,
        loggerName: loggerName,
        severity: Level.INFO,
      );

  /// Log a WARNING message with WARNING [Level]
  static w(String message, {String? loggerName}) => _log(
        message,
        loggerName: loggerName,
        severity: Level.WARNING,
      );

  /// Log an ERROR message with SEVERE [Level]
  static e(String message, {StackTrace? stackTrace, String? loggerName}) =>
      _log(
        message,
        loggerName: loggerName,
        severity: Level.SEVERE,
        stackTrace: stackTrace,
      );

  static void _log(
    String message, {
    String? loggerName,
    required Level severity,
    StackTrace? stackTrace,
  }) {
    if (loggerName == null) {
      // Main logger
      _logger.log(severity, message, null, stackTrace);
    } else {
      // Additional loggers
      Logger(loggerName)..log(severity, message, null, stackTrace);
    }
  }

  /// Register a listener to listen to all logs
  /// Logs are emitted as [FloggerRecord]
  static registerListener(FloggerListener onRecord) {
    Logger.root.onRecord
        .map((e) => FloggerRecord.fromLogger(e, _config))
        .listen(onRecord);
  }

  /// Clear all log listeners
  static clearListeners() {
    Logger.root.clearListeners();
  }
}

ListQueue<OutputEvent> _outputEventBuffer = ListQueue();

class FullLogs {
  StringBuffer fullLogs = StringBuffer('Start: ');
}

class OutputEvent {
  final Level level;
  final List<String> lines;

  OutputEvent(this.level, this.lines);
}

class LogConsole extends StatefulWidget {
  final bool dark;
  final bool showCloseButton;

  LogConsole({this.dark = false, this.showCloseButton = false});

  static Future<void> open(BuildContext context, {bool? dark}) async {
    var logConsole = LogConsole(
      showCloseButton: true,
      dark: dark ?? Theme.of(context).brightness == Brightness.dark,
    );
    PageRoute route;
    if (Platform.isIOS) {
      route = CupertinoPageRoute(builder: (_) => logConsole);
    } else {
      route = MaterialPageRoute(builder: (_) => logConsole);
    }

    await Navigator.push(context, route);
  }

  static void add(OutputEvent outputEvent, {int? bufferSize = 1000}) {
    while (_outputEventBuffer.length >= (bufferSize ?? 1)) {
      _outputEventBuffer.removeFirst();
    }
    _outputEventBuffer.add(outputEvent);
  }

  @override
  _LogConsoleState createState() => _LogConsoleState();
}

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
}

class _LogConsoleState extends State<LogConsole> {
  ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];

  var logs = FullLogs().fullLogs;

  var _scrollController = ScrollController();
  var _filterController = TextEditingController();

  Level? _filterLevel = Level.CONFIG;
  double _logFontSize = 14;

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      setState(() {
        _followBottom = scrolledToBottom;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _refreshFilter();
  }

  void _refreshFilter() {
    var newFilteredBuffer = _renderedBuffer.where((it) {
      var logLevelMatches = it.level.value >= _filterLevel!.value;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });

    if (_followBottom) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: widget.dark
      //     ? ThemeData(
      //         brightness: Brightness.dark,
      //         colorScheme: Theme.of(context).colorScheme.copyWith(
      //               secondary: Colors.blueGrey,
      //             ),
      //       )
      //     : ThemeData(
      //         brightness: Brightness.light,
      //         colorScheme: Theme.of(context).colorScheme.copyWith(
      //               secondary: Colors.lightBlueAccent,
      //             ),
      //       ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTopBar(context),
              SizedBox(height: 8),
              Expanded(
                child: _buildLogContent(),
              ),
              SizedBox(height: 8),
              _buildBottomBar(),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _followBottom ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.arrow_downward,
                color: widget.dark ? Colors.white : Colors.lightBlue[900],
              ),
              onPressed: _scrollToBottom,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogContent() {
    logs.clear();
    return Container(
      color: widget.dark ? Colors.black : Colors.grey[150],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1600,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              var logEntry = _filteredBuffer[index];
              logs.write(logEntry.lowerCaseText + "\n");
              return Text.rich(
                logEntry.span,
                key: Key(logEntry.id.toString()),
                style: TextStyle(
                    fontSize: _logFontSize,
                    color: logEntry.level.toColor(widget.dark)),
              );
            },
            itemCount: _filteredBuffer.length,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.content_copy_rounded,
              color: Colors.greenAccent,
            ),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: logs.toString(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _logFontSize++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _logFontSize--;
              });
            },
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.red[200],
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
                logs.clear();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20),
              controller: _filterController,
              onChanged: (s) => _refreshFilter(),
              decoration: InputDecoration(
                labelText: "Filter log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 20),
          DropdownButton(
            value: _filterLevel,
            items: [
              DropdownMenuItem(
                child: Text("DEBUG"),
                value: Level.CONFIG,
              ),
              DropdownMenuItem(
                child: Text("INFO"),
                value: Level.INFO,
              ),
              DropdownMenuItem(
                child: Text("WARNING"),
                value: Level.WARNING,
              ),
              DropdownMenuItem(
                child: Text("ERROR"),
                value: Level.SEVERE,
              ),
            ],
            onChanged: (dynamic value) {
              _filterLevel = value;
              _refreshFilter();
            },
          )
        ],
      ),
    );
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;

    setState(() {
      _followBottom = true;
    });

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(widget.dark);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }
}

class LogBar extends StatelessWidget {
  final bool? dark;
  final Widget? child;

  LogBar({this.dark, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!dark!)
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 3,
              ),
          ],
        ),
        child: Material(
          color: dark! ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }
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
