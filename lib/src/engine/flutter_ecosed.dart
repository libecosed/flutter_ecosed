import '../framework/want.dart';
import '../framework/log.dart';
import '../framework/service.dart';
import '../values/tag.dart';

final class FlutterEcosedPlugin extends Service {
  @override
  void onCreate() {
    super.onCreate();
    Log.i(engineTag, 'onCreate');
  }

  @override
  IBinder onBind(Want want) => LocalBinder(service: this);

  void test() {}
}

final class LocalBinder extends Binder {
  LocalBinder({required this.service});

  final FlutterEcosedPlugin service;

  @override
  Service get getService => service;
}

final class MyConnection implements ServiceConnection {
  MyConnection({required this.calback});

  final void Function(FlutterEcosedPlugin service) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    LocalBinder binder = service as LocalBinder;
    calback.call(binder.getService as FlutterEcosedPlugin);
  }

  @override
  void onServiceDisconnected(String name) {}
}
