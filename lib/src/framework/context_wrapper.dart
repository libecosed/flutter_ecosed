import 'context.dart';
import 'intent.dart';

base class ContextWrapper extends Context {
  void attachBaseContext(Context base) {}

  @override
  void startActivity(Intent intent) {}

  @override
  void startService(Intent intent) {}

  @override
  void stopService(Intent intent) {}
}
