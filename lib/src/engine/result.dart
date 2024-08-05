abstract interface class EcosedResult {
  /// 成功
  void success(dynamic result);

  /// 错误
  Never error(
    String errorCode,
    String? errorMessage,
    dynamic errorDetails,
  );

  /// 未实现
  Never notImplemented();
}
