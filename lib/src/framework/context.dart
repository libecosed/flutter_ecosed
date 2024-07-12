import 'intent.dart';
import 'service.dart';

abstract base class Context {
  void startActivity(Intent intent);
  void startService(Intent intent);
  void stopService(Intent intent);
  void bindService(Intent intent, ServiceConnection connect);
  void unbindService(Intent intent);
}
