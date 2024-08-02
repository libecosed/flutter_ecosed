import 'package:flutter/widgets.dart' hide Intent;

import 'context.dart';
import 'context_impl.dart';
import 'want.dart';
import 'service.dart';

base class ContextWrapper extends Context {
  ContextWrapper({required bool attach}) {
    if (attach) mBase = ContextImpl();
  }

  /// 基本上下文
  Context? mBase;

  /// 构建上下文
  BuildContext? mBuild;

  /// 附加构建上下文
  void attachBuildContext(BuildContext context) => mBuild = context;

  /// 附加基本上下文
  void attachBaseContext(Context base) => mBase = base;

  /// 获取基本上下文
  Context getBaseContext() {
    assert(() {
      if (mBase == null) {
        throw FlutterError('基本上下文为空!');
      }
      return true;
    }());
    return mBase!;
  }

  /// 获取构建上下文
  BuildContext getBuildContext() {
    assert(() {
      if (mBuild == null) {
        throw FlutterError('构建上下文为空!');
      }
      return true;
    }());
    return mBuild!;
  }

  @override
  void startActivity(Want want) {
    mBase?.startActivity(want);
  }

  @override
  void startService(Want want) {
    mBase?.startService(want);
  }

  @override
  void stopService(Want want) {
    mBase?.stopService(want);
  }

  @override
  void bindService(Want want, ServiceConnection connect) {
    mBase?.bindService(want, connect);
  }

  @override
  void unbindService(Want want) {
    mBase?.unbindService(want);
  }
}
