import 'dart:collection';

import 'output_event.dart';

class EventBuffer {
  static ListQueue<OutputEvent> outputEventBuffer = ListQueue();
}
