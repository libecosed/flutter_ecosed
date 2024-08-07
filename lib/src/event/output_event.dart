import 'package:logging/logging.dart';

class OutputEvent {
  final Level level;
  final List<String> lines;

  const OutputEvent(
    this.level,
    this.lines,
  );
}
