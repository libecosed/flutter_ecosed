import 'package:flutter/foundation.dart';

import 'result.dart';

final class ResultImport implements EcosedResult {
  const ResultImport({
    required this.callback,
  });

  final Future<void> Function(dynamic result) callback;

  @override
  void success(dynamic result) => callback(result);

  @override
  Never error(
    String errorCode,
    String? errorMessage,
    dynamic errorDetails,
  ) {
    throw FlutterError(
      '错误代码:$errorCode\n'
      '错误消息:$errorMessage\n'
      '详细信息:$errorDetails',
    );
  }

  @override
  Never notImplemented() {
    throw UnimplementedError();
  }
}
