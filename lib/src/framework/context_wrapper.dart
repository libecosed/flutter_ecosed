import 'package:flutter/widgets.dart' hide Intent;

import 'context.dart';
import 'context_impl.dart';
import 'intent.dart';
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
  void attachBuildContext(BuildContext context) {
    assert(() {
      if (mBuild != null) {
        throw FlutterError('请勿重复执行attachBuildContext!');
      }
      return true;
    }());
    mBuild = context;
  }

  /// 附加基本上下文
  void attachBaseContext(Context base) {
    assert(() {
      if (mBase != null) {
        throw FlutterError('请勿重复执行attachBaseContext!');
      }
      return true;
    }());
    mBase = base;
  }

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
  void startActivity(Intent intent) {
    mBase?.startActivity(intent);
  }

  @override
  void startService(Intent intent) {
    mBase?.startService(intent);
  }

  @override
  void stopService(Intent intent) {
    mBase?.stopService(intent);
  }

  @override
  void bindService(Intent intent, ServiceConnection connect) {
    mBase?.bindService(intent, connect);
  }

  @override
  void unbindService(Intent intent) {
    mBase?.unbindService(intent);
  }
}
