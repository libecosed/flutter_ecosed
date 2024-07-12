import 'package:flutter_ecosed/src/framework/intent.dart';

import 'context_wrapper.dart';

abstract interface class IBinder {

}

base class Binder extends IBinder {

}

base class Service extends ContextWrapper {
  void onCreate() {}
  IBinder onBind(Intent intent) => Binder();
  bool onUnbind(Intent intent) => true;
  void onDestroy() {}

  @override
  String toString() {
    return super.toString();
  }
}

abstract interface class ServiceConnection {
  void onServiceConnected(String name, IBinder service);
  void onServiceDisconnected(String name);
}