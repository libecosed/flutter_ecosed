import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../framework/service.dart';
import '../framework/want.dart';
import '../interface/ecosed_platform.dart';
import '../utils/platform.dart';
import 'binding.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

final class EngineEmbedded extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_embedded';

  @override
  String get description => '服务嵌入';

  @override
  String get title => 'EngineEmbedded';

  /// 服务实例
  late FlutterEcosedPlugin _service;

  @override
  Future<void> onEcosedAdded(PluginBinding binding) async {
    return await super.onEcosedAdded(binding).then((added) {
      final MyConnection connect = MyConnection(
        calback: (service) => _service = service,
      );
      final Want want = Want(classes: FlutterEcosedPlugin());
      startService(want);
      bindService(want, connect);
      return added;
    });
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    switch (call.method) {
      case 'getPlugins':
        result.success(_service.getPlatformPluginList());
      case 'openDialog':
        result.success(_service.openPlatformDialog());
      case 'closeDialog':
        result.success(_service.closePlatformDialog());
      default:
        result.notImplemented();
    }
  }
}

final class FlutterEcosedPlugin extends Service implements EcosedPlatform {
  FlutterEcosedPlugin();

  /// 平台实例
  late EcosedPlatform _instance;

  @override
  void onCreate() {
    super.onCreate();
    if (kUseNative) {
      _instance = EcosedPlatform.instance;
    }
  }

  @override
  IBinder onBind(Want want) => LocalBinder(service: this);

  @override
  Future<List?> getPlatformPluginList() async {
    return await _invoke(
      invoke: () async => List.empty(),
      mobile: (instance) async => await instance.getPlatformPluginList(),
      error: (exception) async {
        return List.empty();
      },
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _invoke(
      invoke: () async => true,
      mobile: (instance) async => await instance.openPlatformDialog(),
      error: (exception) async {
        return false;
      },
    );
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await _invoke(
      invoke: () async => true,
      mobile: (instance) async => await instance.closePlatformDialog(),
      error: (exception) async {
        return false;
      },
    );
  }

  Future<dynamic> _invoke({
    required Future<dynamic> Function() invoke,
    required Future<dynamic> Function(EcosedPlatform instance) mobile,
    required Future<dynamic> Function(Exception exception) error,
  }) async {
    if (kIsWeb || kIsWasm) {
      return await invoke.call();
    } else if (Platform.isAndroid || Platform.isIOS) {
      try {
        return await mobile.call(_instance);
      } on Exception catch (exception) {
        return await error.call(exception);
      }
    } else {
      try {
        return await invoke.call();
      } on Exception catch (exception) {
        return await error.call(exception);
      }
    }
  }
}

final class LocalBinder extends Binder {
  LocalBinder({required this.service});

  final FlutterEcosedPlugin service;

  @override
  Service get getService => service;
}

final class MyConnection implements ServiceConnection {
  MyConnection({required this.calback});

  final void Function(FlutterEcosedPlugin service) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    LocalBinder binder = service as LocalBinder;
    calback.call(binder.getService as FlutterEcosedPlugin);
  }

  @override
  void onServiceDisconnected(String name) {}
}
