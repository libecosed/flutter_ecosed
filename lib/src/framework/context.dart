import 'want.dart';
import 'service.dart';

abstract base class Context {
  void startActivity(Want want);
  void startService(Want want);
  void stopService(Want want);
  void bindService(Want want, ServiceConnection connect);
  void unbindService(Want want);
}
