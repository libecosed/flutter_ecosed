import 'intent.dart';

abstract class Context {
  void startActivity(Intent intent);
  void startService(Intent intent);
  void stopService(Intent intent);
}
