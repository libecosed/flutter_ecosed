import 'package:flutter_ecosed/src/values/tag.dart';

import '../framework/activity.dart';
import '../framework/intent.dart';
import '../framework/log.dart';
import '../framework/service.dart';

final class FlutterEcosedPlugin extends Service {
  @override
  void onCreate() {
    super.onCreate();
    Log.i(engineTag, 'onCreate');
  }

  @override
  IBinder onBind(Intent intent) {
    return LocalBinder(service: this);
  }

  void test() {}
}

final class LocalBinder extends Binder {
  LocalBinder({required this.service});

  final FlutterEcosedPlugin service;

  @override
  Service get getService => service;
}

final class TestActivity extends Activity {
  late FlutterEcosedPlugin myService;

  @override
  void onCreate() {
    super.onCreate();

    myService.test();
  }
}

class MyConnection implements ServiceConnection {
  MyConnection({required this.calback});

  final void Function(FlutterEcosedPlugin myService) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    LocalBinder binder = service as LocalBinder;
    calback.call(binder.getService as FlutterEcosedPlugin);
  }

  @override
  void onServiceDisconnected(String name) {
    // TODO: implement onServiceDisconnected
  }
}
