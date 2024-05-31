import 'dart:async';
import 'dart:isolate';

import 'binding.g.dart';
import 'library.dart';

final EcosedKernelBindings _bindings = KernelLib.bindings;

///
///
///
///
///
///
///
///

int sum(int a, int b) => _bindings.sum(a, b);

Future<int> sumAsync(int a, int b) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumRequestId++;
  final _SumRequest request = _SumRequest(requestId, a, b);
  final Completer<int> completer = Completer<int>();
  _sumRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

class _SumRequest {
  final int id;
  final int a;
  final int b;

  const _SumRequest(this.id, this.a, this.b);
}

class _SumResponse {
  final int id;
  final int result;

  const _SumResponse(this.id, this.result);
}

int _nextSumRequestId = 0;

final Map<int, Completer<int>> _sumRequests = <int, Completer<int>>{};

Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _SumResponse) {
        final Completer<int> completer = _sumRequests[data.id]!;
        _sumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  await Isolate.spawn(
    (SendPort sendPort) async {
      final ReceivePort helperReceivePort = ReceivePort()
        ..listen((dynamic data) {
          if (data is _SumRequest) {
            final int result = _bindings.sum_long_running(data.a, data.b);
            final _SumResponse response = _SumResponse(data.id, result);
            sendPort.send(response);
            return;
          }
          throw UnsupportedError(
            'Unsupported message type: ${data.runtimeType}',
          );
        });
      sendPort.send(helperReceivePort.sendPort);
    },
    receivePort.sendPort,
  );
  return completer.future;
}();
