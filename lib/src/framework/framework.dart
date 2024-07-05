import 'package:flutter/widgets.dart';

abstract class Context {
  void startActivity(Intent intent);
  void startService(Intent intent);
}

base class ContextWrapper extends Context {
  void attachBaseContext(Context base) {}

  @override
  void startActivity(Intent intent) {}

  @override
  void startService(Intent intent) {}
}

class Intent {
  Intent();

  factory Intent.ofName() {
    return Intent();
  }
}

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

class EcosedManifests {
  static final List<Activity> activitys = <Activity>[MainActivity()];
  static final List<Service> services = <Service>[MainService()];
}

class Log {
  static void i(String tag, String message) {
    _printLog(tag, message, null);
  }

  static void d(String tag, String message) {
    _printLog(tag, message, null);
  }

  static void e(String tag, String message, dynamic exceptino) {
    _printLog(tag, message, exceptino);
  }

  static void v(String tag, String message) {
    _printLog(tag, message, null);
  }

  static void w(String tag, String message) {
    _printLog(tag, message, null);
  }

  static void _printLog(String tag, String message, dynamic exceptino) {
    debugPrint('tag:$tag - message:$message\n$exceptino');
  }
}

class Toast {
  
}

final class MainActivity extends Activity {
  @override
  void onCreate() {
    super.onCreate();
  }
}

final class MainService extends Service {
  @override
  void onCreate() {
    super.onCreate();
  }
}
