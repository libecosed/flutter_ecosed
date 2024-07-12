import 'package:flutter/widgets.dart' hide Intent;
import 'package:flutter_ecosed/src/framework/context_impl.dart';

import 'context.dart';
import 'intent.dart';
import 'service.dart';

base class ContextWrapper extends Context {
  ContextWrapper({bool attach = true}) {
    if (attach) {
      final ContextImpl impl = ContextImpl();
      attachBaseContext(impl);
    }
  }

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

  Context getBaseContext() {
    return mBase;
  }

  BuildContext getBuildContext() {
    return mBuild;
  }

  @override
  void startActivity(Intent intent) {
    mBase.startActivity(intent);
  }

  @override
  void startService(Intent intent) {
    mBase.startService(intent);
  }

  @override
  void stopService(Intent intent) {
    mBase.stopService(intent);
  }

  @override
  void bindService(Intent intent, ServiceConnection connect) {
    mBase.bindService(intent, connect);
  }

  @override
  void unbindService(Intent intent) {
    mBase.unbindService(intent);
  }
}
