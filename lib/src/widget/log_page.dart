import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:logging/logging.dart";

class AnsiParser {
  static const TEXT = 0;
  static const BRACKET = 1;
  static const CODE = 2;

  final bool dark;

  AnsiParser(this.dark);

  Color? foreground;
  Color? background;
  List<TextSpan>? spans;

  void parse(String s) {
    spans = [];
    var state = TEXT;
    StringBuffer? buffer;
    final text = StringBuffer();
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
    if (codes.isEmpty) codes.add(0);
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
          // TODO: 复制剪贴板
          // Clipboard.setData(ClipboardData(text: text));
          // Toast.toast("Copy to paste board");
        },
    );
  }
}

ListQueue<OutputEvent> _outputEventBuffer = ListQueue();

class OutputEvent {
  final Level level;
  final List<String> lines;

  OutputEvent(this.level, this.lines);
}

class LogConsole extends StatefulWidget {
  const LogConsole({
    super.key,
  });

  static void add(OutputEvent outputEvent, {int? bufferSize = 1000}) {
    while (_outputEventBuffer.length >= (bufferSize ?? 1)) {
      _outputEventBuffer.removeFirst();
    }
    _outputEventBuffer.add(outputEvent);
  }

  @override
  State<LogConsole> createState() => _LogConsoleState();
}

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedEvent(
    this.id,
    this.level,
    this.span,
    this.lowerCaseText,
  );
}

class FullLogs {
  StringBuffer fullLogs = StringBuffer('Start: ');
}

class _LogConsoleState extends State<LogConsole> {
  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];

  var logs = FullLogs().fullLogs;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  bool get dark => Theme.of(context).brightness == Brightness.dark;

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
      var logLevelMatches = it.level.value >= Level.CONFIG.value;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() => _filteredBuffer = newFilteredBuffer);
    if (_followBottom) Future.delayed(Duration.zero, _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    logs.clear();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1600,
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _filteredBuffer.length,
          itemBuilder: (context, index) {
            final logEntry = _filteredBuffer[index];
            logs.write("${logEntry.lowerCaseText}\n");
            return Text.rich(
              logEntry.span,
              key: Key(logEntry.id.toString()),
              style: TextStyle(
                fontSize: 14,
                color: logEntry.level.toColor(dark),
              ),
            );
          },
        ),
      ),
    );
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;
    setState(() => _followBottom = true);
    final scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    _scrollListenerEnabled = true;
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(dark);
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
