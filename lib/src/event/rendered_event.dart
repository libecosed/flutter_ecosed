import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  const RenderedEvent(
    this.id,
    this.level,
    this.span,
    this.lowerCaseText,
  );
}
