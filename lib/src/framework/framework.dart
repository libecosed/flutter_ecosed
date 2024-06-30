abstract class Context {
  void startActivity(Intent intent);
}

base class ContextWrapper extends Context {
  @override
  void startActivity(Intent intent) {}
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
