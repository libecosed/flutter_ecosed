

import '../framework/activity.dart';
import '../framework/intent.dart';
import '../framework/service.dart';

final class FlutterEcosedPlugin extends Service {
  @override
  void onCreate() {
    super.onCreate();
  }

  @override
  IBinder onBind(Intent intent) {
    return LocalBinder(service: this);
  }


  void test() {

  }
}

final class LocalBinder extends Binder {
  LocalBinder({required this.service});

  final FlutterEcosedPlugin service;

  FlutterEcosedPlugin getServices() => service;
}

final class TestActivity extends Activity {
  late FlutterEcosedPlugin myService;

  @override
  void onCreate() {
    // TODO: implement onCreate
    super.onCreate();

    var con = MyConnection(oi: (service) {
      myService = service;
    });

    var intent = Intent(classes: FlutterEcosedPlugin());

    startService(intent);
    bindService(intent, con);


    myService.test();

  
  }
}

class MyConnection implements ServiceConnection {
  MyConnection({required this.oi});

  final void Function(FlutterEcosedPlugin myService) oi;

  @override
  void onServiceConnected(String name, IBinder service) {
    LocalBinder binder = service as LocalBinder;
    oi.call(binder.getServices());
  }

  @override
  void onServiceDisconnected(String name) {
    // TODO: implement onServiceDisconnected
  }
}


