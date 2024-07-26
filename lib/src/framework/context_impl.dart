import 'context.dart';
import 'want.dart';
import 'service.dart';

final class ContextImpl extends Context {
  @override
  void startActivity(Want want) {}

  @override
  void startService(Want want) {
    want.getService().onCreate();
  }

  @override
  void stopService(Want want) {
    want.getService().onDestroy();
  }

  @override
  void bindService(Want want, ServiceConnection connect) {
    var a = want.getService().onBind(want);
    connect.onServiceConnected(want.classes.toString(), a);
  }

  @override
  void unbindService(Want want) {
    want.getService().onUnbind(want);
  }
}
