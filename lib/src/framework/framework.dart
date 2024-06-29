abstract class Context {}

class ContextWrapper extends Context {}

base class Service extends ContextWrapper {
  void onCreate() {}
  void onStartCommand() {}
  void onBind() {}
  void onRebind() {}
  void onUnbind() {}
  void onDestroy() {}
}

base class Activity extends ContextWrapper {
  void onCreate() {}
  void onStart() {}
  void onResume() {}
  void onPause() {}
  void onStop() {}
  void onDestroy() {}
}
