import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract interface class ParserWrapper {
  List<TextSpan> get getSpans;
  void parse(String s);
}

class AnsiParser implements ParserWrapper {
  AnsiParser({required this.context});

  final BuildContext context;

  static const _textCode = 0;
  static const _bracketCode = 1;
  static const _codeCode = 2;

  late List<TextSpan> _spans;

  Color? _foreground;
  Color? _background;

  @override
  List<TextSpan> get getSpans {
    return _spans;
  }

  @override
  void parse(String s) {
    _spans = [];
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
              _spans.add(_createSpan(text.toString()));
              text.clear();
            }
            state = _textCode;
            if (c == 'm') {
              codes.add(code);
              _handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }
          break;
        default:
          break;
      }
    }
    _spans.add(_createSpan(text.toString()));
  }

  void _handleCodes(List<int> codes) {
    if (codes.isEmpty) codes.add(0);
    switch (codes[0]) {
      case 0:
        _foreground = _getColor(0, true);
        _background = _getColor(0, false);
        break;
      case 38:
        _foreground = _getColor(codes[2], true);
        break;
      case 39:
        _foreground = _getColor(0, true);
        break;
      case 48:
        _background = _getColor(codes[2], false);
        break;
      case 49:
        _background = _getColor(0, false);
    }
  }

  Color? _getColor(int colorCode, bool foreground) {
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

  TextSpan _createSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: _foreground,
        backgroundColor: _background,
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
