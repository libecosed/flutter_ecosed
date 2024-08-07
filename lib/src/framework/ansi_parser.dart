import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AnsiParser {
  static const _textCode = 0;
  static const _bracketCode = 1;
  static const _codeCode = 2;

  AnsiParser({required this.context});

  final BuildContext context;

  Color? foreground;
  Color? background;
  List<TextSpan>? spans;

  void parse(String s) {
    spans = [];
    var state = _textCode;
    StringBuffer? buffer;
    final text = StringBuffer();
    var code = 0;
    late List<int> codes;

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];
      switch (state) {
        case _textCode:
          if (c == '\u001b') {
            state = _bracketCode;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;
        case _bracketCode:
          buffer!.write(c);
          if (c == '[') {
            state = _codeCode;
          } else {
            state = _textCode;
            text.write(buffer);
          }
          break;
        case _codeCode:
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
            state = _textCode;
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
        return _dark ? Colors.lightBlue[300] : Colors.indigo[700];
      case 208:
        return _dark ? Colors.orange[300] : Colors.orange[700];
      case 196:
        return _dark ? Colors.red[300] : Colors.red[700];
      case 199:
        return _dark ? Colors.pink[300] : Colors.pink[700];
    }
    return foreground ? Colors.black : Colors.transparent;
  }

  bool get _dark {
    return Theme.of(context).brightness == Brightness.dark;
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
