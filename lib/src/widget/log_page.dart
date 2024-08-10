import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../event/event_buffer.dart';
import '../event/rendered_event.dart';
import '../framework/ansi_parser.dart';
import '../framework/log_level.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  final ScrollController _scrollController = ScrollController();
  final StringBuffer _logs = StringBuffer('Start: ');

  List<RenderedEvent> _filteredBuffer = [];
  // bool _scrollListenerEnabled = true;
  // bool _followBottom = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(
  //     () {
  //       if (!_scrollListenerEnabled) return;
  //       final scrolledToBottom = _scrollController.offset >=
  //           _scrollController.position.maxScrollExtent;
  //       setState(() => _followBottom = scrolledToBottom);
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _renderedBuffer.clear();
    for (var event in EventBuffer.outputEventBuffer) {
      final ParserWrapper parser = AnsiParser(context: context);
      final String text = event.lines.join('\n');
      int currentId = 0;
      parser.parse(text);
      _renderedBuffer.add(
        RenderedEvent(
          currentId++,
          event.level,
          TextSpan(children: parser.getSpans),
          text.toLowerCase(),
        ),
      );
    }
    setState(
      () => _filteredBuffer = _renderedBuffer.where(
        (it) {
          if (it.level.value < Level.CONFIG.value) {
            return false;
          } else {
            return true;
          }
        },
      ).toList(),
    );
    // if (_followBottom) {
    //   Future.delayed(
    //     Duration.zero,
    //     () async {
    //       _scrollListenerEnabled = false;
    //       setState(() => _followBottom = true);
    //       await _scrollController.animateTo(
    //         _scrollController.position.maxScrollExtent,
    //         duration: const Duration(milliseconds: 400),
    //         curve: Curves.easeOut,
    //       );
    //       _scrollListenerEnabled = true;
    //     },
    //   );
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logs.clear();
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
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
              color: logEntry.level.toColor(context),
            ),
          );
        },
      ),
    );
  }
}
