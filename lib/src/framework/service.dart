import 'context_wrapper.dart';

base class Service extends ContextWrapper {
  void onCreate() {}
  void onStartCommand() {}
  void onBind() {}
  void onRebind() {}
  void onUnbind() {}
  void onDestroy() {}
}
