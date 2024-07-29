abstract interface class EcosedResult {
  void success(dynamic result);
  Never error(
    String errorCode,
    String? errorMessage,
    dynamic errorDetails,
  );
  Never notImplemented();
}
