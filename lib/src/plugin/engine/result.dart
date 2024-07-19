abstract interface class EcosedResult {
  void success(dynamic result);
  void error(String errorCode, String? errorMessage, dynamic errorDetails);
  void notImplemented();
}
