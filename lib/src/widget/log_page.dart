import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../event/event_buffer.dart';
import '../event/output_event.dart';
import '../event/rendered_event.dart';
import '../framework/ansi_parser.dart';
import '../framework/log_full.dart';
import '../framework/log_level.dart';

class LogPage extends StatefulWidget {
  const LogPage({
    super.key,
  });

  static void add({
    required OutputEvent outputEvent,
    required int bufferSize,
  }) {
    while (EventBuffer.outputEventBuffer.length >= bufferSize) {
      EventBuffer.outputEventBuffer.removeFirst();
    }
    EventBuffer.outputEventBuffer.add(outputEvent);
  }

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  final StringBuffer _logs = FullLogs().fullLogs;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();
  List<RenderedEvent> _filteredBuffer = [];
  int _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (!_scrollListenerEnabled) return;
        final scrolledToBottom = _scrollController.offset >=
            _scrollController.position.maxScrollExtent;
        setState(() => _followBottom = scrolledToBottom);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _renderedBuffer.clear();
    for (var event in EventBuffer.outputEventBuffer) {
      _renderedBuffer.add(
        _renderEvent(event),
      );
    }
    var newFilteredBuffer = _renderedBuffer.where(
      (it) {
        if (!(it.level.value >= Level.CONFIG.value)) {
          return false;
        } else if (_filterController.text.isNotEmpty) {
          return it.lowerCaseText.contains(
            _filterController.text.toLowerCase(),
          );
        } else {
          return true;
        }
      },
    ).toList();
    setState(() => _filteredBuffer = newFilteredBuffer);
    if (_followBottom) {
      Future.delayed(
        Duration.zero,
        _scrollToBottom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _logs.clear();
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
            _logs.write("${logEntry.lowerCaseText}\n");
            return Text.rich(
              logEntry.span,
              key: Key(logEntry.id.toString()),
              style: TextStyle(
                fontSize: 14,
                color: logEntry.level.toColor(_dark(context)),
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
    final AnsiParser parser = AnsiParser(_dark(context));
    final String text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }

  bool _dark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
