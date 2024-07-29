import 'context_wrapper.dart';

base class Activity extends ContextWrapper {
  Activity() : super(attach: true);

  void onCreate() {}
  void onStart() {}
  void onResume() {}
  void onPause() {}
  void onStop() {}
  void onDestroy() {}
}
