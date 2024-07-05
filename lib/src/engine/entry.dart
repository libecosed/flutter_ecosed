import 'package:flutter/foundation.dart';

import 'engine.dart';

class CallProxyImport implements MethodCallProxy {
  const CallProxyImport({
    required this.callMethod,
    required this.callArguments,
  });

  final String callMethod;
  final dynamic callArguments;

  @override
  String get methodProxy => callMethod;

  @override
  dynamic get argumentsProxy => callArguments;
}

class ResultProxyImport implements ResultProxy {
  const ResultProxyImport({
    required this.callback,
  });

  final Future<void> Function(dynamic result) callback;

  @override
  void success(result) => callback(result);

  @override
  void error(String errorCode, String? errorMessage, errorDetails) {
    throw FlutterError(
      '错误代码:$errorCode\n'
      '错误消息:$errorMessage\n'
      '详细信息:$errorDetails',
    );
  }

  @override
  void notImplemented() {
    throw UnimplementedError();
  }
}
