import 'package:flutter/widgets.dart';

abstract class Context {
  void startActivity(Intent intent);
  void startService(Intent intent);
  void stopService(Intent intent);
}

base class ContextWrapper extends Context {
  void attachBaseContext(Context base) {}

  @override
  void startActivity(Intent intent) {}

  @override
  void startService(Intent intent) {}

  @override
  void stopService(Intent intent) {}
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
  /// Info级别
  static void i(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// Debug级别
  static void d(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// Error级别
  static void e(String tag, String message, dynamic exceptino) {
    _printLog(tag, message, exceptino, true);
  }

  static void v(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  static void w(String tag, String message) {
    _printLog(tag, message, null, false);
  }

  /// 打印日志
  static void _printLog(
    String tag,
    String message,
    dynamic exceptino,
    bool hasException,
  ) {
    if (hasException) {
      debugPrint('tag: $tag - message: $message - exceptino:\n$exceptino');
    } else {
      debugPrint('tag: $tag - message: $message');
    }
  }
}

class AlertDialog {}

class Toast {}

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
