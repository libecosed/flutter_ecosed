import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../framework/service.dart';
import '../framework/want.dart';
import '../interface/ecosed_platform.dart';
import '../platform/ecosed.dart';
import '../plugin/plugin_runtime.dart';
import '../utils/platform.dart';
import '../values/strings.dart';

final class PlatformEmbedder extends Service
    with FlutterEcosed
    implements EcosedRuntimePlugin, EcosedPlatform {
  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => 'platform_embedder';

  @override
  String get pluginDescription => 'PlatformEmbedder';

  @override
  String get pluginName => 'PlatformEmbedder';

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
      invoke: () async {
        return List.empty();
      },
      mobile: () async {
        return await getPlatformPluginList();
      },
      error: (exception) async {
        return List.empty();
      },
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _invoke(
      invoke: () async {
        return true;
      },
      mobile: () async {
        return await openPlatformDialog();
      },
      error: (exception) async {
        return false;
      },
    );
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await _invoke(
      invoke: () async {
        return true;
      },
      mobile: () async {
        return await closePlatformDialog();
      },
      error: (exception) async {
        return false;
      },
    );
  }

  Future<dynamic> _invoke({
    required Future<dynamic> Function() invoke,
    required Future<dynamic> Function() mobile,
    required Future<dynamic> Function(Exception exception) error,
  }) async {
    if (kIsWeb || kIsWasm) {
      return await invoke.call();
    } else if (kUseNative) {
      try {
        return await mobile.call();
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