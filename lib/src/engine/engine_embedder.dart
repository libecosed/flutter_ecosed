import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecosed/src/values/strings.dart';

import '../base/base_wrapper.dart';
import '../framework/service.dart';
import '../framework/want.dart';
import '../interface/ecosed_platform.dart';
import '../plugin/plugin_runtime.dart';
import '../utils/platform.dart';
import 'binding.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

base mixin EmbedderMixin implements BaseWrapper {
  @override
  EcosedRuntimePlugin get embedder => PlatformEmbedder();
}

final class EngineEmbedder extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_embedder';

  @override
  String get description => '服务嵌入';

  @override
  String get title => 'EngineEmbedder';

  /// 服务实例
  late PlatformEmbedder _embedder;

  @override
  Future<void> onEcosedAdded(PluginBinding binding) async {
    return await super.onEcosedAdded(binding).then((added) {
      final Want want = Want(classes: PlatformEmbedder());
      final EmbedderConnection connect = EmbedderConnection(
        calback: (embedder) => _embedder = embedder,
      );
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
        result.success(_embedder.getPlatformPluginList());
      case 'openDialog':
        result.success(_embedder.openPlatformDialog());
      case 'closeDialog':
        result.success(_embedder.closePlatformDialog());
      default:
        result.notImplemented();
    }
  }
}

final class PlatformEmbedder extends Service
    implements EcosedRuntimePlugin, EcosedPlatform {
  /// 平台实例
  late EcosedPlatform _instance;

  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => 'platform_embedder';

  @override
  String get pluginDescription => 'PlatformEmbedder';

  @override
  String get pluginName => 'PlatformEmbedder';

  @override
  void onCreate() {
    super.onCreate();
    if (kUseNative) _instance = EcosedPlatform.instance;
  }

  @override
  IBinder onBind(Want want) => EmbedderBinder(embedder: this);

  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {}

  @override
  Widget pluginWidget(BuildContext context) {
    return const Placeholder();
  }

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
    } else if (kUseNative) {
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

final class EmbedderBinder extends Binder {
  EmbedderBinder({required this.embedder});

  final PlatformEmbedder embedder;

  @override
  Service get getService => embedder;
}

final class EmbedderConnection implements ServiceConnection {
  EmbedderConnection({required this.calback});

  final void Function(PlatformEmbedder embedder) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    EmbedderBinder binder = service as EmbedderBinder;
    calback.call(binder.getService as PlatformEmbedder);
  }

  @override
  void onServiceDisconnected(String name) {}
}
