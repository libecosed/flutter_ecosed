import 'context_wrapper.dart';
import 'want.dart';

abstract interface class IBinder {
  Service get getService;
}

base class Binder extends IBinder {
  @override
  Service get getService {
    throw UnimplementedError('未实现getService方法');
  }
}

abstract base class Service extends ContextWrapper {
  Service() : super(attach: true);
  void onCreate() {}
  IBinder onBind(Want want);
  bool onUnbind(Want want) => true;
  void onDestroy() {}
}

abstract interface class ServiceConnection {
  void onServiceConnected(String name, IBinder service);
  void onServiceDisconnected(String name);
}
