import 'context.dart';
import 'intent.dart';
import 'service.dart';

final class ContextImpl extends Context {
  @override
  void startActivity(Intent intent) {}

  @override
  void startService(Intent intent) {
    intent.getService().onCreate();
  }

  @override
  void stopService(Intent intent) {
    intent.getService().onDestroy();
  }

  @override
  void bindService(Intent intent, ServiceConnection connect) {
    var a = intent.getService().onBind(intent);
    connect.onServiceConnected(intent.classes.toString(), a);
  }

  @override
  void unbindService(Intent intent) {
    intent.getService().onUnbind(intent);
  }
}
