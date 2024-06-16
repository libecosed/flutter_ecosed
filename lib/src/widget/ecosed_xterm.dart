import 'package:flutter/widgets.dart';
import 'package:xterm/xterm.dart';

final class EcosedXterm extends StatelessWidget {
  const EcosedXterm({
    super.key,
    required this.terminal,
  });

  final Terminal terminal;

  @override
  Widget build(BuildContext context) {
    return TerminalView(terminal);
  }
}
