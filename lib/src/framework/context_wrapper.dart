import 'package:flutter/widgets.dart' hide Intent;

import 'context.dart';
import 'intent.dart';
import 'service.dart';

base class ContextWrapper extends Context {
  late Context mBase;
  late BuildContext mBuild;

  /// 附加构建上下文
  void attachBuildContext(BuildContext context) {
    mBuild = context;
  }

  /// 附加基本上下文
  void attachBaseContext(Context base) {
    mBase = base;
  }

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
